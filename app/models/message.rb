class Message < ActiveRecord::Base
  attr_accessible :subject, :message

  belongs_to :user
  
  validates :from_user, :presence => true
  validates :to_user, :presence => true
  validates :message, :presence => true
  validates :type, :presence => true
  validates :state, :presence => true
  
end
