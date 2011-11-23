module ApplicationHelper
  
  def days_back
    1
  end
  
  def hours_back
    5
  end
  
  def per_page
    20
  end
  
  def per_page_search
    20
  end
    
  def max_num_boards
    8
  end
      
  def max_num_schools
    8
  end
  
  def valid_date_or_today date
    return Date.today unless date
    begin
    date = Date.parse(date)
    rescue ArgumentError
    Date.today
    end
  end

  def avatar_for(user, options = { :size => 50 })
    #gravatar_image_tag(user.email.downcase, :alt => user.full_name,
    #                                        :class => 'gravatar',
    #                                        :gravatar => options)
  end
  def logo
    image_tag("logo.png", :alt => "Site Logo", :class => "round")
  end
  def strip_and_cut(str, num = 120)
    truncate( strip_tags(str), :length => num )
  end
  
  def back
    redirect_to session[:return_to] 
  end
  
  def wrap(content)
    sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
  end
  
  def wrap_long_string(text, max_width = 120)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text : 
          text.scan(regex).join(zero_width_space)
  end

end

