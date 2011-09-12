module UsersHelper
  def avatar_for(user, options = { :size => 50 })
    gravatar_image_tag(user.email.downcase, :alt => user.full_name,
                                            :class => 'gravatar',
                                            :gravatar => options)
  end
end
