class Vote < ActiveRecord::Base
  attr_accessible :obj_id, :obj_type, :level_up
  
  belongs_to :user, :class_name => "User"
    
  validates :user_id, :presence => true
  validates :obj_type, :presence => true
  validates :obj_id, :presence => true

  validates_uniqueness_of :user_id, :scope => [:obj_type, :obj_id]
  
  default_scope :order => 'created_at DESC'
  scope :level_ups, where(:level_up => true)
  
  def class_type
    'vote'
  end
  
  def self.raise_level? total
    total % 10 == 0
  end
  
  def object_type type_idx # from ObjectType
    obj_type[type_idx]
  end
  
  def self.obj_type_by_class obj
    if obj.class_type == 'posting'
      Vote::ObjectType::POSTING
    elsif obj.class_type == 'board'
      Vote::ObjectType::BOARD
    elsif obj.class_type == 'user'
      Vote::ObjectType::USER
    elsif obj.class_type == 'school'
      Vote::ObjectType::SCHOOL
    end
  end
  
  def self.object_by_vote vote
    if vote.obj_type == Vote::ObjectType::POSTING
      obj = Posting.find(vote.obj_id)
    elsif vote.obj_type == Vote::ObjectType::BOARD
      obj = Board.find(vote.obj_id)
    elsif vote.obj_type == Vote::ObjectType::USER
      obj = User.find(vote.obj_id)
    elsif vote.obj_type == Vote::ObjectType::SCHOOL
      obj = School.find(vote.obj_id)
    end
    rescue ActiveRecord::RecordNotFound
    nil
  end
  
  class ObjectType
    USER = 0
    BOARD = 1
    SCHOOL = 2
    POSTING = 3
  end
  
  private
  
  obj_type = { 0 => "user", 1 => "board", 2 => "school", 3 => "posting" }
end
