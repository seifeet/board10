class Posting < ActiveRecord::Base
  attr_accessible :subject, :content, :access_level, :visibility

  belongs_to :user
  belongs_to :groups

  # we are calling :mark_inactive before destroy
  # because after distroy there could be no @posting
  # before_destroy :mark_inactive

  validates :content, :presence => true
  validates :user_id, :presence => true
  validates :group_id, :presence => true

  default_scope :order => 'postings.created_at DESC'
  
  def user_status
    USER_STATUS[active_user]
  end
  
  def group_status
    GROUP_STATUS[active_group]
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
end
