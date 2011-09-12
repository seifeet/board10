module ApplicationHelper
  def logo
    image_tag("logo.png", :alt => "Site Logo", :class => "round")
  end
end
