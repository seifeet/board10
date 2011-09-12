class Posting < ActiveRecord::Base
  attr_accessible :subject, :content, :access_level
  
  belongs_to :user
  belongs_to :groups
  
  validates :content, :presence => true
  validates :user_id, :presence => true
  validates :group_id, :presence => true
  
  default_scope :order => 'postings.created_at DESC'
  
  
end
