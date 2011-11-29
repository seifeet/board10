module PostingsHelper
  def title_for_public_post
    'Public post or event will be visible for everyone'
  end
  
  def title_for_private_post
    'Private post or event will be visible only for members of the board'
  end
  
  def board_postings from = nil
    all_postings = []
    current_user.boards.each do |board|
      if current_user.member?(board)
        if from.nil?
        all_postings += board.postings # board.all_member_comments(current_user.id)
        else
        all_postings += board.postings.where('id > ?', from)
        end
      else # current_user is not a member
        if from.nil?
        all_postings += board.postings.where(:visibility => 1)
        else
        all_postings += board.postings.where('visibility = 1 and id > ?', from)
        end
      end
    end
    if !all_postings.nil? && !all_postings.empty?
      all_postings.sort_by!{|posting|[posting.id]}.reverse!
    end
    all_postings.uniq!
    all_postings
  end

  def school_postings school, from = nil
    all_postings = []
    all_postings = get_school_postings school, from
    if !all_postings.nil? && !all_postings.empty?
      all_postings.sort_by!{|posting|[posting.id]}.reverse!
    end
    all_postings.uniq!
    all_postings
  end
  
  def school_postings_on_date school, date
    all_postings = []
    all_postings = get_school_postings_on_date school, date
    if !all_postings.nil? && !all_postings.empty?
      all_postings.sort_by!{|posting|[posting.id]}.reverse!
    end
    all_postings.uniq!
    all_postings
  end
  
  def get_school_postings school, from = nil
    all_postings = []
    school.boards.each do |board|
      if current_user.member?(board)
        if from.nil?
        all_postings += board.postings
        else
        all_postings += board.postings.where('id > ?', from)
        end
      else # current_user is not a member
        if from.nil?
        all_postings += board.postings.where(:visibility => 1)
        else
        all_postings += board.postings.where('visibility = 1 and id > ?', from)
        end
      end
    end
    all_postings
  end
  
  def get_school_postings_on_date school, date
    all_postings = []
    school.boards.each do |board|
      if current_user.member?(board)
        all_postings += board.postings.where('created_at <= ?', date.end_of_day)
      else # current_user is not a member
        all_postings += board.postings.where('visibility = 1 and created_at <= ?', date.end_of_day)
      end
    end
    all_postings
  end
  
  def schools_postings from = nil
    all_postings = []
    current_user.schools.each do |school|
      all_postings += get_school_postings school, from
    end
    if !all_postings.nil? && !all_postings.empty?
      all_postings.sort_by!{|posting|[posting.id]}.reverse!
    end
    all_postings.uniq!
    all_postings
  end
end
