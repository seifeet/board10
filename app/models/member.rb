class Member < ActiveRecord::Base
  attr_accessible :board_id, :member_type
  
  belongs_to :user, :class_name => "User"
  belongs_to :board, :class_name => "Board"
    
  validates :user_id, :presence => true
  validates :board_id, :presence => true

  validates_uniqueness_of :user_id, :scope => :board_id 
    
  def class_type
    'member'
  end
  
  class MemberType
    MEMBER = 0
    OWNER = 1
    FOLLOWER = 2
  end
  
  class Commit
    FOLLOW = 'Follow'
    AUTOJOIN = 'Autojoin'
  end
  
  private
    MEMBER_TYPE = { 0 => "member", 1 => "owner", 2 => "follower" }
end
