module PostingsHelper
  def title_for_public_post
    'Public post or event will be visible for everyone'
  end
  
  def title_for_private_post
    'Private post or event will be visible only for members of the board'
  end
  
  def posts_with_events_for_date events_arr, date
    day_events = Array.new
    for event in events_arr
      if event.next_event == date
        day_events.push Posting.find_posting(event.posting_id)
      end
    end
    day_events
  end
  
  def paginate_school_postings school, date = nil
    return nil unless school
    require 'will_paginate/array'
    if date
      all_postings = school.school_postings_on_date(current_user, date)
    else
      all_postings = school.school_postings current_user
    end
    
    if !all_postings.nil? && !all_postings.empty?
     all_postings.paginate(:page => @page, :per_page => per_page, :total_etries => all_postings.size )
    end
  end
  
end
