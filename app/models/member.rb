class Member < ActiveRecord::Base
  attr_accessible :group_id
  
  belongs_to :user, :class_name => "User"
  belongs_to :group, :class_name => "Group"
    
  validates :user_id, :presence => true
  validates :group_id, :presence => true
  #validates_uniqueness_of :user_id, :scope => :group_id 
  
end
