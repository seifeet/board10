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
  
  def get_next_event start
    logger.debug "START-----------------#{start_date}---------------------"
    logger.debug "NEXT BEFORE-----------------#{next_event}---------------------"
    return nil unless start >= start_date && start <= end_date
    next_event = find_next_date start
    logger.debug "NEXT AFTER-----------------#{next_event}---------------------"
    next_event
  end
  
  def find_next_date start
    if repeat == ScheduledEvent::Repeat::DAILY
      next_date = start + 1.day
    elsif repeat == ScheduledEvent::Repeat::WEEKLY || repeat == ScheduledEvent::Repeat::BIWEEKLY
      # find the first day of the week after the start
      next_date = find_next_date_on_this_week(start)
      # if next_date == start then we have to advance to the next week
      next_date = find_next_date_on_this_week(start.next_week) if next_date == start
    elsif repeat == ScheduledEvent::Repeat::MONTHLY
      # find the day of the month after the start
      #next_date = find_next_date_on_this_month
      #next_date = find_next_date_on_next_month unless next_date
    elsif repeat == ScheduledEvent::Repeat::YEARLY
      # find the day of the year after the start
      #next_date = find_next_date_on_this_year
      #next_date = find_next_date_on_next_year unless next_date
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
    errors += "Event start date can not be after event end date<br />" unless end_date > start_date
    errors += "Event start time can not be after event end time<br />" unless end_time > start_time
    
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
