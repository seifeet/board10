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
  
  def self.find_board board_id
    member = @cache_boards[board_id]
    return member if member
    member = self.find_by_board_id(board_id)
    @cache_boards[board_id] = member
    member
    rescue ActiveRecord::RecordNotFound
     nil
  end
  
  def self.find_user user_id
    member = @cache_users[user_id]
    return member if member
    member = self.find_by_user_id(user_id)
    @cache_users[user_id] = member
    member
    rescue ActiveRecord::RecordNotFound
     nil
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
    @cache_boards = Hash.new
    @cache_users = Hash.new
    MEMBER_TYPE = { 0 => "member", 1 => "owner", 2 => "follower" }
end
