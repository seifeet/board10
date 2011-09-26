class Board < ActiveRecord::Base
  attr_accessible :title, :description, :access_level
  
  #default_scope :conditions => {:active => true}
  
  has_many :members, :foreign_key => "board_id", :dependent => :destroy
  has_many :postings, :dependent => :destroy
  
  validates :title, :presence => true
  
  def self.search(search)
    if search && !search.blank?
      tmp = search.sub(' ', '%')
      where('CONCAT( title, \' \', description ) LIKE ?', "%#{tmp}%")
    else
      unscoped # the same as all, but does not perform the actual query
    end
  end
  
  def all_member_comments user_id
    Posting.joins('inner join `members` on `postings`.`board_id` = `members`.`board_id`').
    where("`members`.`user_id` = ? ", user_id )
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
  
  def member?(user_id)
    members.find_by_user_id(user_id)
    rescue ActiveRecord::RecordNotFound
    false
  end
  
  def member!(user)
    members.create!(:user_id => user.id)
  end
  
  def owner?(user_id)
    members.find_by_user_id_and_owner(user_id,true)
    rescue ActiveRecord::RecordNotFound
    false
  end
  
  def owner!(user)
    members.create!(:user_id => user.id, :owner => true)
  end
  
  def unmember!(user_id)
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
