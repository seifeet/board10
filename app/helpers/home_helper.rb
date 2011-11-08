module HomeHelper
    def only_current_user
      redirect_to signin_path if current_user.nil?
    end
    
    def board_postings from_time = nil, to_time = nil
      require 'will_paginate/array'
      all_postings = []
      current_user.boards.each do |board|
        if current_user.member?(board)
          if from_time.nil? && to_time.nil?
            all_postings += board.postings # board.all_member_comments(current_user.id)
          elsif from_time && to_time
            all_postings += board.postings.where('created_at > ? and created_at <= ?', from_time, to_time)
          end
        else # current_user is not a member
          if from_time.nil? && to_time.nil?
            all_postings += board.postings.where(:visibility => 1)
          elsif from_time && to_time
            all_postings += board.postings.where('visibility = 1 and created_at > ? and created_at <= ?', from_time, to_time)
          end
        end
      end
      if !all_postings.nil? && !all_postings.empty?
        all_postings.sort_by!{|posting|[posting.created_at]}.reverse!
      end
      all_postings.uniq!
      if from_time.nil? && to_time.nil? && !all_postings.nil? && !all_postings.empty?
        all_postings = all_postings.paginate(:page => params[:page], :per_page => per_page, :total_etries => all_postings.size )
      end
    end
    
    def school_postings school, from_time = nil, to_time = nil
      require 'will_paginate/array'
      all_postings = []
      school.boards.each do |board|
        if current_user.member?(board)
          if from_time.nil? && to_time.nil?
            all_postings += board.postings
          else
            all_postings += board.postings.where('created_at > ? and created_at <= ?', from_time, to_time)
          end
        else # current_user is not a member
          if from_time.nil? && to_time.nil?
            all_postings += board.postings.where(:visibility => 1)
          else
            all_postings += board.postings.where('visibility = 1 and created_at > ? and created_at <= ?', from_time, to_time)
          end
        end
      end
      if !all_postings.nil? && !all_postings.empty?
       all_postings.sort_by!{|posting|[posting.created_at]}.reverse!
      end
      all_postings.uniq!
      if from_time.nil? && to_time.nil? && !all_postings.nil? && !all_postings.empty?
        all_postings = all_postings.paginate(:page => params[:page], :per_page => per_page, :total_etries => all_postings.size )
      end 
    end 
end
