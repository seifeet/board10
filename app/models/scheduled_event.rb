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
  
  private
  
  REPEAT_TYPE = { 0 => "Daily", 1 => "Weekly", 2 => "Biweekly", 3 => "Monthly", 4 => "Yearly" }
end
