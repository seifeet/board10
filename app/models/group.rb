class Group < ActiveRecord::Base
  attr_accessible :title, :description, :access_level
  
  has_many :postings, :dependent => :destroy
  
  validates :title, :presence => true
  

  def status
    STATUS[active]
  end
  
  def access
    ACCESS[access_level]
  end
  
  def delete_postings
    postings.each do |posting|
      posting.active_group = false
      posting.save
    end
  end
  
  ACTIVE = 'Active'
  INACTIVE = 'Inactive'
  PRIVATE = 'Private'
  PUBLIC = 'Public'
  
  private
    STATUS = { true => "Active", false => "Inactive" }
    ACCESS = { 0 => "Private", 1 => "Public" }
end
