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
  
  private
    STATUS = { true => "Active", false => "Inactive" }
    ACCESS = { 0 => "Private", 1 => "Protected", 2 => "Public" }
end
