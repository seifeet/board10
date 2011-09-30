class UserSchool < ActiveRecord::Base
  attr_accessible :school_id
  
  belongs_to :user, :class_name => "User"
  belongs_to :school, :class_name => "School"
    
  validates :user_id, :presence => true
  validates :school_id, :presence => true

  validates_uniqueness_of :user_id, :scope => :school_id
  
end
