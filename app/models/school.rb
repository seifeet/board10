class School < ActiveRecord::Base
  has_many :users, :foreign_key => "school_id", :class_name => "User"
  has_many :boards, :foreign_key => "school_id", :class_name => "Board"
  
  validates :state, :presence => true, :length   => { :maximum => 2 }
  validates :city, :presence => true, :length   => { :maximum => 150 }
  validates :name, :presence => true
  
  def self.find_school school_id
    self.find(school_id)
    rescue ActiveRecord::RecordNotFound
     nil
  end
  
  def self.search(search, state = nil, city = nil)
    
    if search || state || city
      tmp = nil
      tmp = search.sub(' ', '%') unless search.nil? 
      where('state = ? and city like ? and CONCAT( name, \' \', name ) LIKE ?', "#{state}", "%#{city}%", "%#{tmp}%")
    else
      scoped # the same as all, but does not perform the actual query
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
  
end
