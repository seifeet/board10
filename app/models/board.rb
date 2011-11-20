class Board < ActiveRecord::Base
  attr_accessible :title, :description, :access_level, :school_id
  
  default_scope :conditions => {:active => true}
  
  has_many :members, :foreign_key => "board_id", :dependent => :destroy
  has_many :postings, :dependent => :destroy
  has_many :scheduled_events, :through => :postings

  validates :title, :presence => true
  validates :description, :presence => true
  
  # **************** abstract methods: ****************
  def class_type
    'board'
  end
  
  #def title # already has a title field
  #  title
  #end
  
  #def description # already has a description field
  #  location
  #end
  # **************** end of abstract methods ****************
  
  def self.search(search)
    if search && !search.blank?
      tmp = search.sub(' ', '%')
      unscoped.where('CONCAT( title, \' \', description ) LIKE ?', "%#{tmp}%")
    else
      unscoped # the same as all, but does not perform the actual query
    end
  end
  
  def all_member_comments user_id
    Posting.joins('inner join `members` on `postings`.`board_id` = `members`.`board_id`').
    where("`members`.`user_id` = ?", user_id )
  end
  
  def add_vote
    update_attribute(:view_count, view_count+1)
    self.view_count
  end
  
  def remove_vote
    update_attribute(:view_count, view_count-1)
    self.view_count
  end
  
  def status
    STATUS[active]
  end
  
  def access
    ACCESS[access_level]
  end
  
  def delete_postings
    postings.each do |posting|
      posting.active_board = false
      posting.save
    end
  end
  
  # to de implemented:
  # owner of a board can select autojoin option for public boards
  # in this case every user can join the board with one click
  def autojoin
    false
  end
  
  def self.find_board board_id
    self.find(board_id)
    rescue ActiveRecord::RecordNotFound
     nil
  end
  
  def follower?(user_id)
    members.find_by_user_id(user_id)
    rescue ActiveRecord::RecordNotFound
    false
  end
  
  def follower!(user)
    member = member?(board_id)
    return member if member
    members.create!(:user_id => user.id, :member_type => Member::MemberType::FOLLOWER)
  end
  
  def member?(user_id)
    member = members.find_by_user_id(user_id)
    return member if !member.nil? && (member.member_type == Member::MemberType::MEMBER || member.member_type == Member::MemberType::OWNER)
    false
    rescue ActiveRecord::RecordNotFound
    false
  end
  
  def member!(user)
    members.create!(:user_id => user.id, :member_type => Member::MemberType::MEMBER)
  end
  
  def owner?(user_id)
    members.find_by_user_id_and_member_type(user_id,Member::MemberType::OWNER)
    rescue ActiveRecord::RecordNotFound
    false
  end
  
  def owner!(user)
    members.create!(:user_id => user.id, :member_type => Member::MemberType::OWNER)
  end
  
  def unmember!(user_id)
    members.find_by_user_id(user_id).destroy
    rescue ActiveRecord::RecordNotFound
    false
  end
  
  def unfollow!(user_id)
    members.find_by_user_id(user_id).destroy
    rescue ActiveRecord::RecordNotFound
    false
  end
  
  ACTIVE = 'Active'
  INACTIVE = 'Inactive'
  PRIVATE = 'Private'
  PUBLIC = 'Public'
  
  private
    STATUS = { true => "Active", false => "Inactive" }
    ACCESS = { 0 => "Private", 1 => "Public" }
end
