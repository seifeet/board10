class Message < ActiveRecord::Base
  attr_accessible :subject, :message

  belongs_to :user
  
  validates :from_user, :presence => true
  validates :to_user, :presence => true
  validates :content, :presence => true
  validates :msg_type, :presence => true
  validates :msg_state, :presence => true
  
  class Commit
    JOIN = "Join"
    CONFIRM = 'Confirm'
    REJECT = 'Reject'
    INVITE = 'Invite'
  end
  # Types:
  class Type
    INVITE = 0
    JOIN = 1
    MESSAGE = 2
  end
  
  # Statuses:
  class State
    UNREAD = 0
    READ = 1
    CONFIRMED = 2
    REJECTED = 3
  end
  
  default_scope :order => 'messages.created_at DESC'
  scope :unread, where(:msg_state => State::UNREAD)
  scope :read, where(:msg_state => State::READ)
  scope :confirmed , where(:msg_state => State::CONFIRMED)
  scope :rejected, where(:msg_state => State::REJECTED)
  scope :join_requests, where(:msg_type => Type::JOIN)
  scope :invitations, where(:msg_type => Type::INVITE)
  scope :personal_messages, where(:msg_type => Type::MESSAGE)
  
  private
    MSG_TYPE = { 0 => "invite", 1 => "join", 2 => "message" }
    MSG_STATE = { 0 => "unread", 1 => "read", 2 => "confirmed", 3 => "rejected" }
    
end
