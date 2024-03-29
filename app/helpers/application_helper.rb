module ApplicationHelper
  def views_str
    'UP'
  end
  
  def days_back
    1
  end
  
  def hours_back
    5
  end
  
  def per_page
    25
  end
  
  def per_page_search
    25
  end
    
  def max_num_boards
    10
  end
  
  def max_num_schools
    10
  end
  
  def help_note msg
    ("<span class='help_note tips' title='" + msg + "'>note</span>").html_safe
  end

  def school_desc school
    (escape_javascript(school.name) + '<br />' + escape_javascript(school.location)).html_safe if school
  end
  
  def daily_events events
    return nil if events.nil? || events.empty?
    events_str = ":"
    events.each do |event|
      #posting = event.posting
      posting = Posting.find_posting(event.posting_id)
      events_str += "<br /><b>" + escape_javascript(event.start_time.strftime('%I-%M%p')) + " - " + escape_javascript(event.end_time.strftime('%I-%M%p')) + '</b> ' + escape_javascript(strip_and_cut(posting.subject,15)) + "<br />" + escape_javascript(strip_and_cut(posting.content,50))
    end
    events_str
  end
  
  def board_desc board, current_user_as_member
    if board
      str = escape_javascript(board.title)
      if current_user_as_member.member_type == Member::MemberType::OWNER
        str += '<br />You are the owner of this board.'
      else
        owner_user = board.owner
        str += '<br />Owner: ' + escape_javascript(owner_user.full_name)
        str += "<br />You are " + ( current_user_as_member.member_type == Member::MemberType::MEMBER ? 'a member in' : 'following' ) + " this board."
      end
      str.html_safe
    end
  end
  
  def selected_if condition
    condition ? ' selected ' : ''
  end
  
  def valid_page_or_one number
    return 1 unless number
    begin
    page = Integer(number.to_i)
    return ( page.zero? ? 1 : page )
    rescue ArgumentError
      1
    end
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
  
  def output_with_html str, num = 0
    tags = %w(a acronym b strong i em li ul ol h1 h2 h3 h4 h5 h6 blockquote br cite sub sup ins p)
    text = sanitize(str, :tags => tags, :attributes => %w(href title))
    if num != 0
      truncate(text, :length => num)
    end
    text
  end
  
  def logo
    image_tag("logo.png", :alt => "Site Logo", :class => "round")
  end
  def strip_and_cut(str, num = 120)
    truncate( strip_tags(str), :length => num )
  end
  
  def back
    redirect_to stored_location_or_home 
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
  
  def stored_location_or_home
    !session[:return_to].nil? ? session[:return_to] : home_path
  end

  def admin_user
    redirect_to(root_path) unless current_user && current_user.admin?
  end
end

