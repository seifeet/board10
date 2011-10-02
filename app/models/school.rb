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
  
  def self.search(search)
    if search
      tmp = search.sub(' ', '%')
      where('CONCAT( city, \' \', state, \' \', city, \' \', name, \' \', state, \' \', city ) LIKE ?', "%#{tmp}%")
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
    state + ', ' + city 
  end
end
