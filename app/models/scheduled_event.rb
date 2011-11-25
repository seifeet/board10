class ScheduledEvent < ActiveRecord::Base
  attr_accessible :start_date, :end_date, :start_time, :end_time, :repeat, :mo,
                  :tu, :we, :th, :fr, :sa, :su, :month, :month_day, :month_end
  
  belongs_to :posting, :class_name => "Posting"
  
  class Repeat
    DAILY = 0
    WEEKLY = 1
    BIWEEKLY = 2
    MONTHLY = 3
    YEARLY = 4
  end
  
  def description
    desc = ""
    if repeat == ScheduledEvent::Repeat::DAILY
      if start_date == end_date
        desc = "Event on #{start_date.strftime("%m/%d/%Y")}:<br />"
      else
        desc = "Daily Event (#{start_date.strftime("%m/%d/%Y")} - #{end_date.strftime("%m/%d/%Y")}):<br />"
      end
      desc += "From " + start_time.strftime("%I:%M%p") +
           " to " + end_time.strftime("%I:%M%p")
    elsif repeat == ScheduledEvent::Repeat::WEEKLY
      if start_date == end_date
        desc = "This week event on " + week_days + "<br />"
        desc += "From " + start_time.strftime("%I:%M%p") +
           " to " + end_time.strftime("%I:%M%p")
      else
        desc = "Weekly Event (#{start_date.strftime("%m/%d/%Y")} - #{end_date.strftime("%m/%d/%Y")}):<br />"
        desc += "From " + start_time.strftime("%I:%M%p") +
           " to " + end_time.strftime("%I:%M%p") + " on " + week_days
      end
      
    elsif repeat == ScheduledEvent::Repeat::BIWEEKLY
      if start_date == end_date
        desc = "This week event on " + week_days + "<br />"
        desc += "From " + start_time.strftime("%I:%M%p") +
           " to " + end_time.strftime("%I:%M%p")
      else
        desc = "Biweekly Event (#{start_date.strftime("%m/%d/%Y")} - #{end_date.strftime("%m/%d/%Y")}):<br />"
        desc += "From " + start_time.strftime("%I:%M%p") +
           " to " + end_time.strftime("%I:%M%p") + " on " + week_days
      end
    elsif repeat == ScheduledEvent::Repeat::MONTHLY
      if start_date == end_date
        desc = "Event on #{start_date.strftime("%m/%d/%Y")}:<br />"
      else
        desc = "Monthly Event (#{start_date.strftime("%m/%d/%Y")} - #{end_date.strftime("%m/%d/%Y")}):<br />"
      end
      desc += "From " + start_time.strftime("%I:%M%p") +
           " to " + end_time.strftime("%I:%M%p")
      if start_date != end_date && month_end
        desc += " on every month end"
      elsif start_date != end_date
        desc += " on " + month_day.ordinalize + " every month"
      end
    elsif repeat == ScheduledEvent::Repeat::YEARLY
      if start_date == end_date
        desc = "Event on #{start_date.strftime("%m/%d/%Y")}:<br />"
      else
        desc = "Yearly Event (#{start_date.strftime("%m/%d/%Y")} - #{end_date.strftime("%m/%d/%Y")}):<br />"
      end
      desc += "From " + start_time.strftime("%I:%M%p") +
           " to " + end_time.strftime("%I:%M%p")
      if month_end && start_date != end_date
        desc += " every month end"
      elsif start_date != end_date
        desc += " on " + Date::MONTHNAMES[month] + " " + month_day.ordinalize + " every year"
      end
    end
    desc
  end
  
  def week_days
    days =""
    days += "Monday " if mo
    days += "Tuesday " if tu
    days += "Wednesday " if we
    days += "Thursday " if th
    days += "Friday " if fr
    days += "Saturday " if sa
    days += "Sunday " if su
    days
  end
  
  def self.find_event event_id
    self.find(event_id)
    rescue ActiveRecord::RecordNotFound
     nil
  end
  
  def get_first_event_date start
    return nil if start.nil? || start > end_date || start.beginning_of_month < start_date.beginning_of_month
    if new_record?
      # correct start_date if it is in the past:
      today = Date.today
      start_date = today if start < today
    end
    if repeat == ScheduledEvent::Repeat::DAILY
      next_event = start
    elsif repeat == ScheduledEvent::Repeat::WEEKLY || repeat == ScheduledEvent::Repeat::BIWEEKLY
      next_event = next_week_date start
    elsif repeat == ScheduledEvent::Repeat::MONTHLY
      next_event = find_next_date_for_monthly(start)
    elsif repeat == ScheduledEvent::Repeat::YEARLY
      next_event = find_next_date_for_yearly(start)
    end
    next_event
  end
  
  def get_next_event_date start
    get_first_event_date(start+1.day)
  end
  
  def next_week_date start
    wday = start.wday
    while !wdays[wday] do
      wday = ( wday == 6 ? 0 : wday + 1 )
      start += 1.day
    end 
    start
  end

  def wday_match? start
    wdays[start.wday]
  end
    
  def wdays
    @wdays_hash ||= {0 => su, 1 => mo, 2 => tu, 3 => we, 4 => th, 5 => fr, 6 => sa}
  end
  
  def future_month_events start
    return nil if start.nil? || start > end_date
    current_month = start.month
    # get_first_event_date will return nil if we are after end_date
    curr_event = get_first_event_date start
    events = []
    if repeat == Repeat::MONTHLY || repeat == Repeat::YEARLY
      events.push clone_scheduled_event(curr_event) if curr_event
      return events
    end
    if curr_event && curr_event.month == current_month
      events.push clone_scheduled_event(curr_event)
    end
    curr_event = start if curr_event.nil?
    while current_month == curr_event.month do
      tmp_date = get_next_event_date(curr_event)
      if tmp_date && tmp_date != curr_event
        events.push clone_scheduled_event(tmp_date)
        curr_event = tmp_date
      else
        curr_event += 1.day
      end
    end
    events
  end
  
  def clone_scheduled_event next_date
    return nil if next_date.nil?
    new_event = dup
    new_event.next_event = next_date
    new_event
  end
  
  # this method will return the next event after the start
  def find_next_date_for_monthly start
    if month_end || (start.month == 2 && month_day > 28) || month_day > 30
      next_date = start.end_of_month
    else
      next_date = Date.new(start.year, start.month, month_day)
    end
    return next_date if next_date <= end_date
    #next_date = next_date + 1.month
    #next_date = next_date.end_of_month if month_end
    nil
  end
  
  # this method will return the next event after the start
  def find_next_date_for_yearly start
    if (month == start.month && month_end) || 
      (month == start.month && start.month == 2 && month_day > 28) ||
      (month == start.month && month_day > 30)
      return start.end_of_month
    elsif month == start.month
      next_date = Date.new(start.year, month, month_day)
    end
    return next_date if next_date && next_date <= end_date
    #unless next_date.future?
    #  next_date = next_date + 1.year
    #  next_date = next_date.end_of_month if month_end
    #end
    #next_date
    nil
  end
  
  def validate_event
    errors = ""
    errors += "Event start date can not be blank<br />" unless start_date
    errors += "Event end date can not be blank<br />" unless end_date
    errors += "Event start time can not be blank<br />" unless start_time
    errors += "Event end time can not be blank<br />" unless end_time
    errors += "Please select type of event: daily, weekly, etc.<br />" unless repeat
    errors += "Event start date #{start_date} can not be after event end date #{end_date}<br />" unless end_date >= start_date
    #errors += "Event start time can not be after or the same as event end time<br />" unless end_time > start_time
    
    case repeat
    when ScheduledEvent::Repeat::DAILY
    when ScheduledEvent::Repeat::WEEKLY
      unless mo || tu || we || th || fr || sa || su
        errors += "At least one of the weekdays must be specifaied for a weekly event.<br />"
      end
    when ScheduledEvent::Repeat::BIWEEKLY
      unless mo || tu || we || th || fr || sa || su
        errors += "At least one of the weekdays must be specifaied for a biweekly event.<br />"
      end
    when ScheduledEvent::Repeat::MONTHLY
      if month_end.nil? && month_day.nil?
        errors += "For monthly event a month day or the month end has to be specified.<br />"
      end
    when ScheduledEvent::Repeat::YEARLY
      if month_end.nil? && month.nil?
        errors += "For yearly event month can't be blank.<br />"
      end
      if month_end.nil? && month_day.nil? #params[:date][:day] 
        errors += "For yearly event a month day or the month end has to be specified.<br />"
      end
    else
      errors += "Unknown event type.<br />"
    end
    errors
  end
  
  private
  
  REPEAT_TYPE = { 0 => "Daily", 1 => "Weekly", 2 => "Biweekly", 3 => "Monthly", 4 => "Yearly" }
end
