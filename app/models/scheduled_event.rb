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
  
  def get_next_event
    case repeat
    when ScheduledEvent::Repeat::DAILY
      
    when ScheduledEvent::Repeat::WEEKLY

    when ScheduledEvent::Repeat::BIWEEKLY

    when ScheduledEvent::Repeat::MONTHLY

    when ScheduledEvent::Repeat::YEARLY

    else

    end
    start_date
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
