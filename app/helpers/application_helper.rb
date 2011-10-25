module ApplicationHelper
  
  def per_page
    5
  end
  
  def per_page_search
    25
  end
    
  def max_num_boards
    3
  end
      
  def max_num_schools
    4
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

