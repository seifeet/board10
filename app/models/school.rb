class School < ActiveRecord::Base
  has_many :users, :foreign_key => "school_id", :class_name => "User"
  has_many :boards, :foreign_key => "school_id", :class_name => "Board"
  has_many :postings, :through => :boards
  has_many :scheduled_events, :through => :boards
  
  validates :state, :presence => true, :length   => { :maximum => 2 }
  validates :city, :presence => true, :length   => { :maximum => 150 }
  validates :name, :presence => true
  
  #default_scope :order => 'name ASC'
  
  def self.find_school school_id
    school = @cache[school_id]
    return school if school
    school = self.find(school_id)
    @cache[school_id] = school
    school
    rescue ActiveRecord::RecordNotFound
     nil
  end
  
  def self.search(search, state = nil, city = nil)
    
    if search || state || city
      tmp = nil
      tmp = search.sub(' ', '%') unless search.nil?
      if state && !state.blank?
        where('state = ? and city like ? and CONCAT( name, \' \', name ) LIKE ?', "#{state}", "%#{city}%", "%#{tmp}%").order(:name)
      else
        where('city like ? and CONCAT( name, \' \', name ) LIKE ?', "%#{city}%", "%#{tmp}%").order(:name)
      end
    else
      scoped.order(:name) # the same as all, but does not perform the actual query
    end
  end
  
  def class_type
    'school'
  end
  
  def title
    school_name
  end
  
  def school_name
    name
  end
  
  def location
    State.long_name(state) + ', ' + city 
  end
  
  def public_events
    postings.public_posts.scheduled_events
  end
  
  def school_postings user, from = nil
    all_postings = []
    all_postings = get_school_postings user, from
    if !all_postings.nil? && !all_postings.empty?
      all_postings.sort_by!{|posting|[posting.id]}.reverse!
    end
    #all_postings.uniq!
    all_postings
  end
  
  def get_school_postings user, from = nil
    all_postings = []
    boards.each do |board|
      if from
        all_postings += board.postings.where('visibility = 1 and id > ?', from)
      else
        all_postings += board.postings.public_posts
      end
      #if user.member?(board)
      #  if from.nil?
      #  all_postings += board.postings
      #  else
      #  all_postings += board.postings.where('id > ?', from)
      #  end
      #else # current_user is not a member
      #  if from.nil?
      #  all_postings += board.postings.where(:visibility => 1)
      #  else
      #  all_postings += board.postings.where('visibility = 1 and id > ?', from)
      #  end
      #end
    end
    all_postings
  end
  
  def school_postings_on_date user, date
    all_postings = []
    all_postings = get_school_postings_on_date user, date
    if !all_postings.nil? && !all_postings.empty?
      all_postings.sort_by!{|posting|[posting.id]}.reverse!
    end
    all_postings.uniq!
    all_postings
  end

  def get_school_postings_on_date user, date
    all_postings = []
    boards.each do |board|
      all_postings += board.postings.where('visibility = 1 and created_at <= ?', date.end_of_day)
      #if user.member?(board)
      #  all_postings += board.postings.where('created_at <= ?', date.end_of_day)
      #else # current_user is not a member
      #  all_postings += board.postings.where('visibility = 1 and created_at <= ?', date.end_of_day)
      #end
    end
    all_postings
  end
  
  def get_month_events_for_date(user, date)
    # user has not been used, but it is planned to use it
    school_events = public_events
    events_arr = Array.new
    return events_arr unless school_events
    
    school_events.each do |posting|
      if future_events = posting.get_future_events_for_month(date.beginning_of_month)
        events_arr += future_events
      end
    end
    events_arr
  end

  private
    
    @cache = Hash.new
end
