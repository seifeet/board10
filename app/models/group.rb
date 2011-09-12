class Group < ActiveRecord::Base
  attr_accessible :title, :description, :access_level
  
  has_many :postings, :dependent => :destroy
end
