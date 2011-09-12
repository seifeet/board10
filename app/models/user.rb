class User < ActiveRecord::Base
  # Since we will be accepting passwords and password confirmations 
  # as part of the signup process, we need to add the password 
  # and its confirmation to the list of accessible attributes
  # attr_accessible is important for preventing a mass assignment vulnerability
  # We will store only an encrypted password in the database;
  # for the password, we will introduce a virtual attribute 
  # (that is, an attribute not corresponding to a column 
  # in the database) using the attr_accessor method.
  attr_accessor :password
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation, :country, :state, :city
  
  default_scope :conditions => {:active => true}
  # default_scope :order => 'created_at'
  
  has_many :postings, :dependent => :destroy
  has_many :ownerships, :foreign_key => "user_id", :dependent => :destroy
  has_many :memberships, :foreign_key => "user_id", :dependent => :destroy
  has_many :groups, :through => :memberships, :source => :group
  has_many :groups, :through => :ownerships, :source => :group
  
  before_save :encrypt_password
  
  # Automatically create the virtual attribute 'password_confirmation'.
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }
  validates :email, :presence => true, 
                    :uniqueness => { :case_sensitive => false }
  validates :first_name, :presence => true, :length   => { :maximum => 150 }
  validates :last_name, :presence => true, :length   => { :maximum => 150 }
  validates :country, :length   => { :maximum => 150 }
  validates :state, :length   => { :maximum => 2 }
  validates :city, :length   => { :maximum => 150 }
  email_regex = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates :email, :format => { :with => email_regex, :message => 'Email must be valid' }
  
  def full_name
    id.to_s + ': ' + first_name + ' ' + last_name
  end
  
  def location
    ( country.nil? ? '' : country ) + ' ' + ( state.nil? ? '' : state ) + ' ' + ( city.nil? ? '' : city )
  end
  
  def member?(group)
    memberships.find_by_group_id(group)
  end

  def member!(group)
    memberships.create!(:group_id => group.id)
  end
  
  def unmember!(group)
    memberships.find_by_group_id(group).destroy
  end

  def owner?(group)
    ownerships.find_by_group_id(group)
  end

  def owner!(group)
    ownerships.create!(:group_id => group.id)
  end
  
  def unowner!(group)
    ownerships.find_by_group_id(group).destroy
  end
  
  def belongs(group)
    memberships.each do |member|
      return true if group.id == member.group_id
    end
    
    ownerships.each do |owner|
      return true if group.id == owner.group_id
    end
    false
  end
  
  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    # Compare encrypted_password with the encrypted version of
    # submitted_password.
    password_digest == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  # needed for 'remember me' functionality
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  def delete_postings
    postings.each do |posting|
      posting.active_user = false
      posting.save
    end
  end
  
  private

    def encrypt_password
      # if we omitted self and wrote 'password_digest = encrypt(password)'
      # Ruby would create a local variable called encrypted_password, 
      # which isn’t what we want at all.
      self.salt = make_salt if new_record? # new_record? evaluates to true only upon user creation. 
      self.password_digest = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
