class Posting < ActiveRecord::Base
  attr_accessible :subject, :content, :access_level, :visibility

  belongs_to :user
  belongs_to :board

  validates :content, :presence => true
  validates :user_id, :presence => true
  validates :board_id, :presence => true

  default_scope :order => 'postings.created_at DESC'
  
  def self.search(search, date)
    if search && !search.blank? && date && !date.blank?
      tmp = search.sub(' ', '%')
      date_start = Date.parse(date)
      unscoped.where("CONCAT( subject, ' ', content ) LIKE ? and created_at <= ?", "%#{tmp}%", date_start)
    elsif date && !date.blank?
      date_start = Date.parse(date)
      unscoped.where("created_at <= ?", date_start)
    elsif search && !search.blank?
      tmp = search.sub(' ', '%')
      unscoped.where("CONCAT( subject, ' ', content ) LIKE ?", "%#{tmp}%")
    else
      unscoped # the same as all, but does not perform the actual query
    end
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
  
  def class_type
    'posting'
  end
  
  ACTIVE = 'Active'
  INACTIVE = 'Inactive'
  PRIVATE = 'Private'
  PUBLIC = 'Public'

  private
    GROUP_STATUS = { true => "Active", false => "Inactive" }
    USER_STATUS = { true => "Active", false => "Inactive" }
    VISIBILITY = { 0 => "Private", 1 => "Public" }
end
