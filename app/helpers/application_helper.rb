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
end
