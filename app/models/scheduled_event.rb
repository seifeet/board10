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
  
  def get_next_scheduled_event start
    event_date = get_next_event start
    return nil if event_date.nil?
    new_event = dup
    new_event.next_event = event_date
    new_event
  end
  
  def get_next_event start
    #logger.debug "START-----------------#{start_date}---------------------"
    #logger.debug "NEXT BEFORE-----------------#{next_event}---------------------"
    return start_date if start == start_date && repeat == ScheduledEvent::Repeat::DAILY
    next_event = find_next_date start
    return nil if next_event && next_event > end_date
    #logger.debug "NEXT AFTER-----------------#{next_event}---------------------"
    next_event
  end
  
  def find_next_date start
    # let's dial with the end boundaries
    return nil if start > end_date
    next_date = nil
    # let's dial with the start boundaries
    start = start_date if start < start_date
    if repeat == ScheduledEvent::Repeat::DAILY
      next_date = start + 1.day
    elsif repeat == ScheduledEvent::Repeat::WEEKLY || repeat == ScheduledEvent::Repeat::BIWEEKLY
      # find the first day of the week after the start
      next_date = find_next_date_on_this_week(start)
      # if next_date == start then we have to advance to the next week
      next_date = find_next_date_on_this_week(start.next_week) if next_date == start
    elsif repeat == ScheduledEvent::Repeat::MONTHLY
      next_date = find_next_date_for_monthly(start)
    elsif repeat == ScheduledEvent::Repeat::YEARLY
      # find the day of the year after the start
      next_date = find_next_date_for_yearly(start)
    end
    next_date
  end
  
  # this method will return the next event after the start
  def find_next_date_for_monthly start
    next_date = Date.new(start.year, start.month, ( month_end ? start.end_of_month.day : month_day ))
    unless next_date.future?
      next_date = next_date + 1.month
      next_date = next_date.end_of_month if month_end
    end
    next_date
  end
  
  # this method will return the next event after the start
  def find_next_date_for_yearly start
    next_date = Date.new(start.year, month, ( month_end ? start.end_of_month.day : month_day ))
    unless next_date.future?
      next_date = next_date + 1.year
      next_date = next_date.end_of_month if month_end
    end
    next_date
  end
  
  # this method will return start if next event on this week doesn't exist
  def find_next_date_on_this_week start
    next_date = start
    if mo && (1 - start.wday) > 0
      next_date = start + (1 - start.wday).day
    elsif tu && (2 - start.wday) > 0
      next_date = start + (2 - start.wday).day
    elsif we && (3 - start.wday) > 0
      next_date = start + (3 - start.wday).day
    elsif th && (4 - start.wday) > 0
      next_date = start + (4 - start.wday).day
    elsif fr && (5 - start.wday) > 0
      next_date = start + (5 - start.wday).day
    elsif sa && (6 - start.wday) > 0
      next_date = start + (6 - start.wday).day
    elsif su && (7 - start.wday) > 0
      next_date = start + (7 - start.wday).day
    end
    next_date
  end
  
  def validate_event
    errors = ""
    errors += "Event start date can not be blank<br />" unless start_date
    errors += "Event end date can not be blank<br />" unless end_date
    errors += "Event start time can not be blank<br />" unless start_time
    errors += "Event end time can not be blank<br />" unless end_time
    errors += "Please select type of event: daily, weekly, etc.<br />" unless repeat
    errors += "Event start date can not be after event end date<br />" unless end_date >= start_date
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
      if month.nil?
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
