class Member < ActiveRecord::Base
  attr_accessible :board_id, :owner
  
  belongs_to :user, :class_name => "User"
  belongs_to :board, :class_name => "Board"
    
  validates :user_id, :presence => true
  validates :board_id, :presence => true

  validates_uniqueness_of :user_id, :scope => :board_id 
  
end
