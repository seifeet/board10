class Membership < ActiveRecord::Base
  attr_accessible :group_id
  
  belongs_to :users, :class_name => "User"
  belongs_to :groups, :class_name => "Group"
  has_many :postings, :through => :groups, :source => :postings
    
  validates :user_id, :presence => true
  validates :group_id, :presence => true
  
  
end
