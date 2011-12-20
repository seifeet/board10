class User < ActiveRecord::Base
  # Since we will be accepting passwords and password confirmations 
  # as part of the signup process, we need to add the password 
  # and its confirmation to the list of accessible attributes
  # attr_accessible is important for preventing a mass assignment vulnerability
  # We will store only an encrypted password in the database;
  # for the password, we will introduce a virtual attribute 
  # (that is, an attribute not corresponding to a column 
  # in the database) using the attr_accessor method.
  attr_accessor :password, :updating_password
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation, :country, :state, :city
  
  before_create { generate_token(:remember_token) }
  
  default_scope :conditions => {:active => true}
  scope :admin, where(:admin => true)
  # default_scope :order => 'created_at'
  
  # these are messages that were sent to a user
  has_many :recieved, :foreign_key => "to_user", :class_name => "Message"
  # these are messages that a user has sent
  has_many :sent, :foreign_key => "from_user", :class_name => "Message", :dependent => :destroy
  
  has_many :postings, :dependent => :destroy
  has_many :members, :foreign_key => "user_id", :dependent => :destroy
  has_many :boards, :through => :members
  has_many :user_schools, :foreign_key => "user_id"
  has_many :schools, :through => :user_schools
  has_many :votes, :foreign_key => "user_id", :dependent => :destroy
  has_many :scheduled_events, :through => :boards
  
  before_save :encrypt_password, :if => :should_validate_password?
  
  # Automatically create the virtual attribute 'password_confirmation'.
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 },
            :if => :should_validate_password?

  validates :email, :presence => true, 
                    :uniqueness => { :case_sensitive => false }
  validates :first_name, :presence => true, :length   => { :maximum => 150 }
  validates :last_name, :presence => true, :length   => { :maximum => 150 }
  validates :country, :length   => { :maximum => 150 }
  validates :state, :length   => { :maximum => 2 }
  validates :city, :length   => { :maximum => 150 }
  email_regex = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates :email, :format => { :with => email_regex, :message => 'Email must be valid' }
  
  # **************** abstract methods: ****************
  def class_type
    'user'
  end
  
  def title
    full_name
  end
  
  def description
    location
  end
  # **************** end of abstract methods ****************
  
  def self.find_user user_id
    user = @cache[user_id]
    return user if user
    user = self.find(user_id)
    @cache[user_id] = user
    user
    rescue ActiveRecord::RecordNotFound
     nil
  end
  
  def self.search(search)
    if search
      tmp = search.sub(' ', '%')
      where('CONCAT( last_name, \' \', first_name, \' \', last_name ) LIKE ?', "%#{tmp}%")
    else
      scoped # the same as all, but does not perform the actual query
    end
  end
  
  def full_name
    first_name + ' ' + last_name
  end
  
  def location
    ( country.nil? ? '' : country ) + ' ' + ( state.nil? ? '' : state ) + ' ' + ( city.nil? ? '' : city )
  end
  
  def delete_postings
    postings.each do |posting|
      posting.active_user = false
      posting.save
    end
  end
  
  def follower?(board_id)
    members.find_board(board_id)
    rescue ActiveRecord::RecordNotFound
    false
  end
  
  def follower!(board_id)
    member = member?(board_id)
    return member if member
    members.create!(:board_id => board.id, :member_type => Member::MemberType::FOLLOWER)
  end
  
  def member?(board_id)
    member = members.find_board(board_id)
    return member if !member.nil? && (member.member_type == Member::MemberType::MEMBER || member.member_type == Member::MemberType::OWNER)
    false
    rescue ActiveRecord::RecordNotFound
    false
  end
  
  def member!(board)
    members.create!(:board_id => board.id, :member_type => Member::MemberType::MEMBER)
  end
  
  def owner?(board_id)
    member = members.find_board(board_id)
    member.member_type == Member::MemberType::OWNER
    rescue ActiveRecord::RecordNotFound
    false
  end
  
  def owner!(board)
    members.create!(:board_id => board.id, :member_type => Member::MemberType::OWNER)
  end
   
  def unmember!(board_id)
    members.find_board(board_id).destroy
    rescue ActiveRecord::RecordNotFound
    false
  end
  
  def unfollow!(board_id)
    members.find_board(board_id).destroy
    rescue ActiveRecord::RecordNotFound
    false
  end
  
  def has_school?(school_id)
    user_schools.find_by_school_id(school_id)
    rescue ActiveRecord::RecordNotFound
    false
  end
  
  def has_school!(school_id)
    user_schools.create!(:school_id => school_id)
  end
  
  # this method returns a vote (true) if a user has a positive vote
  def voted?(obj)
    votes.find_by_obj_type_and_obj_id_and_vote(Vote.obj_type_by_class(obj), obj.id, true)
    rescue ActiveRecord::RecordNotFound
    false
  end
  
  # this method returns a vote (true) if a user has voted before
  def has_voted?(obj)
    votes.find_by_obj_type_and_obj_id(Vote.obj_type_by_class(obj), obj.id)
    rescue ActiveRecord::RecordNotFound
    false
  end
  
  def vote!(vote)
    obj = Vote.object_by_vote(vote)
    if !obj.nil? 
      user_vote = has_voted?(obj)
      if user_vote && user_vote.vote == false
        obj.add_vote
        user_vote.toggle!(:vote)
      elsif user_vote.nil?
        total = obj.add_vote
        votes.create!(:obj_type => vote.obj_type, :obj_id => vote.obj_id, :level_up => (Vote.raise_level?(total)) )
      end
    end
  end
  
  def unvote!(vote)
    obj = Vote.object_by_vote(vote)
    if !obj.nil? && ( user_vote = has_voted?(obj) ) && user_vote.vote == true
      obj.remove_vote
      vote.toggle!(:vote)
    end
    rescue ActiveRecord::RecordNotFound
    false
  end
  
  def add_vote
    update_attribute(:view_count, view_count+1)
    self.view_count
  end
  
  def remove_vote
    update_attribute(:view_count, view_count-1)
    self.view_count
  end

  def should_validate_password?
    self.updating_password || new_record?
  end
  
  def save_without_password
    self.updating_password = true
    returned_value = self.save
    self.updating_password = false
    returned_value
  end
  
  # needed for 'remember me' functionality
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
    rescue ActiveRecord::RecordNotFound
      page_not_found
  end
  
  def self.authenticate(email, submitted_password)
    user = self.find_by_email(email)

    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
    rescue ActiveRecord::RecordNotFound
      page_not_found
  end
  
  def has_password?(submitted_password)
    # Compare encrypted_password with the encrypted version of
    # submitted_password.
    #logger.debug "\n\n\npassword_digest: #{password_digest}\nencrypt(submitted_password): #{encrypt(submitted_password)}\nsubmitted_password: #{submitted_password}"
    password_digest == encrypt(submitted_password)
  end
  
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
  
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end
  
  def send_invites board, emails
    emails.each do |email, value|
      users = User.where(:email => email)
      if users && users.any? && users.first.id != self.id
        send_invite_internaly(users.first, board) 
      elsif users.nil? || users.empty?
        send_invite_by_email(board, email)
      end
    end
  end
  
  def get_city
    return city if city && !city.blank?
    if schools && schools.any?
      schools.each do |school|
        return school.city if school.postings.any?
      end
    end
    nil
  end
  
  def city_postings user_city = nil
    user_city = get_city if user_city.nil?
    return nil if user_city.nil?
    
    city_schools = School.where(:city => user_city)
    all_postings = []
    city_schools.each do |school|
      all_postings += get_school_postings school
    end
    if !all_postings.nil? && !all_postings.empty?
      all_postings.sort_by!{|posting|[posting.id]}.reverse!
    end
    all_postings.uniq!
    all_postings
  end
  
  def get_school_postings school
    all_postings = []
    school.boards.each do |board|
      all_postings += board.postings.where(:visibility => 1)
    end
    all_postings
  end
  
  def schools_postings from = nil
    all_postings = []
    schools.each do |school|
      all_postings += school.get_school_postings self, from
    end
    if !all_postings.nil? && !all_postings.empty?
      all_postings.sort_by!{|posting|[posting.id]}.reverse!
    end
    all_postings.uniq!
    all_postings
  end
  
  def board_postings from = nil
    all_postings = []
    boards.each do |board|
      if member?(board)
        if from.nil?
        all_postings += board.postings # board.all_member_comments(current_user.id)
        else
        all_postings += board.postings.where('id > ?', from)
        end
      else # current_user is not a member
        if from.nil?
        all_postings += board.postings.where(:visibility => 1)
        else
        all_postings += board.postings.where('visibility = 1 and id > ?', from)
        end
      end
    end
    if !all_postings.nil? && !all_postings.empty?
      all_postings.sort_by!{|posting|[posting.id]}.reverse!
    end
    #all_postings.uniq!
    all_postings
  end
 
  def get_board_events board
    if board.postings && board.postings.any?
    if member?(board) 
        board.postings.scheduled_events
      else
        board.postings.public_posts.scheduled_events
      end
    end
  end
  
  private
    @cache = Hash.new
    
    def send_invite_internaly to_user, board
      message = Message.new
      message.to_user = to_user.id
      message.board_id = board.id
      message.from_user = self.id
      message.subject = "Invite request for board \"#{board.title}\""
      message.content = "Hi!\n\nI would like to invite you to my board \"#{board.title}\".\n\nThank you!"
      message.msg_type = Message::Type::INVITE
      message.msg_state = Message::State::UNREAD
      message.save!
    end
    
    def send_invite_by_email board, email
      invite = Invitation.new
      if invite.create_record(board, email)
        UserMailer.send_invite(invite, board, self).deliver
        self.emails_left -= 1
        save!
      end
    end

    def encrypt_password
      # if we omitted self and wrote 'password_digest = encrypt(password)'
      # Ruby would create a local variable called encrypted_password, 
      # which isn’t what we want at all.
      self.salt = make_salt unless has_password?(password) 
      self.password_digest = encrypt(password)
      #logger.debug "\n\n\npassword: #{password}\nself.salt: #{self.salt}\nself.password_digest: #{self.password_digest}"
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
