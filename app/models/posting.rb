class Posting < ActiveRecord::Base
  attr_accessible :subject, :content, :access_level, :visibility, :scheduled_event_attributes

  belongs_to :user
  belongs_to :board
  has_one :scheduled_event, :foreign_key => "posting_id", :dependent => :destroy

  accepts_nested_attributes_for :scheduled_event

  validates :content, :presence => true
  validates :user_id, :presence => true
  validates :board_id, :presence => true

  default_scope :order => 'postings.created_at DESC'
  scope :scheduled_events, where("scheduled_event_id is not null")
  
  # **************** abstract methods: ****************
  def class_type
    'posting'
  end
  
  def title
    if access == PUBLIC
      return (subject && !subject.blank? ) ? ( subject + ': ' + content ) : content
    else
      return (subject && !subject.blank? ) ? subject : "Private Post"
    end
  end
  
  def description
    "Board: #{board.title}"
  end
  # **************** end of abstract methods ****************
  
  def self.search(search, date)
    if search && !search.blank? && date && !date.blank?
      tmp = search.sub(' ', '%')
      date_start = valid_date_or_today(date)
      unscoped.where("visibility = 1 and CONCAT( subject, ' ', content ) LIKE ? and created_at <= ?", "%#{tmp}%", date_start.end_of_day)
    elsif date && !date.blank?
      date_start = valid_date_or_today(date)
      unscoped.where("visibility = 1 and created_at <= ?", date_start.end_of_day)
    elsif search && !search.blank?
      tmp = search.sub(' ', '%')
      unscoped.where("visibility = 1 and CONCAT( subject, ' ', content ) LIKE ?", "%#{tmp}%")
    else
      unscoped.where(:visibility => 1) # the same as all, but does not perform the actual query
    end
  end
  
  def self.search_board_postings(user, board, search, date)
    if !user.member?(board)
      if search && !search.blank? && date && !date.blank?
        tmp = search.sub(' ', '%')
        date_start = valid_date_or_today(date)
        unscoped.where("visibility = 1 and board_id = ? and CONCAT( subject, ' ', content ) LIKE ? and created_at <= ?", board.id, "%#{tmp}%", date_start.end_of_day)
      elsif date && !date.blank?
        date_start = valid_date_or_today(date)
        unscoped.where("visibility = 1 and board_id = ? and created_at <= ?", board.id, date_start.end_of_day)
      elsif search && !search.blank?
        tmp = search.sub(' ', '%')
        unscoped.where("visibility = 1 and board_id = ? and CONCAT( subject, ' ', content ) LIKE ?", board.id, "%#{tmp}%")
      else
        unscoped.where("visibility = 1 and board_id = ?", board.id) # the same as all, but does not perform the actual query
      end
    else
      if search && !search.blank? && date && !date.blank?
        tmp = search.sub(' ', '%')
        date_start = valid_date_or_today(date)
        unscoped.where("board_id = ? and CONCAT( subject, ' ', content ) LIKE ? and created_at <= ?", board.id, "%#{tmp}%", date_start.end_of_day)
      elsif date && !date.blank?
        date_start = valid_date_or_today(date)
        unscoped.where("board_id = ? and created_at <= ?", board.id, date_start.end_of_day)
      elsif search && !search.blank?
        tmp = search.sub(' ', '%')
        unscoped.where("board_id = ? and CONCAT( subject, ' ', content ) LIKE ?", board.id, "%#{tmp}%")
      else
        unscoped.where(:board_id => board.id) # the same as all, but does not perform the actual query
      end
    end
  end
  
  def get_future_events_for_month start # object of type Date (eg: Date.today)
    return nil if scheduled_event_id.nil?
    return nil unless event = ScheduledEvent.find_event(scheduled_event_id)
    events = Array.new
    current_month = start.month
    while start.month == current_month do
      next_scheduled_event = event.get_next_scheduled_event(start)
      break unless next_scheduled_event && next_scheduled_event.next_event != start
      start = next_scheduled_event.next_event
      events.push next_scheduled_event
    end
    events
  end
  
  def add_vote
    update_attribute(:view_count, view_count+1)
    self.view_count
  end
  
  def remove_vote
    update_attribute(:view_count, view_count-1)
    self.view_count
  end
  
  def user_status
    USER_STATUS[active_user]
  end
  
  def board_status
    GROUP_STATUS[active_board]
  end
  
  def access
    VISIBILITY[visibility]
  end
  
  ACTIVE = 'Active'
  INACTIVE = 'Inactive'
  PRIVATE = 'Private'
  PUBLIC = 'Public'

  private
    GROUP_STATUS = { true => "Active", false => "Inactive" }
    USER_STATUS = { true => "Active", false => "Inactive" }
    VISIBILITY = { 0 => "Private", 1 => "Public" }
    
  def self.valid_date_or_today date
    begin
    date = Date.parse(date)
    rescue ArgumentError
    Date.today
    end
  end
    
  def valid_date_or_today date
    begin
    date = Date.parse(date)
    rescue ArgumentError
    Date.today
    end
  end
end
