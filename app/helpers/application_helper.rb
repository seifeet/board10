module ApplicationHelper
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
  
  def determine_type container
    first = container.first
    if first.instance_of?(Posting)
      type = "posting"
    elsif first.instance_of?(Board)
      type = "board"
    elsif first.instance_of?(User)
      type = "user"
    elsif first.instance_of?(Member)
      type = "member"
    elsif first.instance_of?(School)
      type = "school"
    else
      return
    end
      type
  end
end
