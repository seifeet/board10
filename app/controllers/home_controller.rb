class HomeController < ApplicationController
  include HomeHelper
  include PostingsHelper
  include ApplicationHelper
  before_filter :only_current_user, :only => [:index]
  
  def index
    return nil if current_user.nil?
    
    store_location
    
    paginate = true
    @user = current_user
    #i = 1
    #begin
    #  @level_ups = Vote.level_ups.where('updated_at > ? and created_at > ?',
    #    Time.now.utc - (i*hours_back).hours, Time.now.utc - (i*days_back).days).limit(10)
    #  i += 1
    #end while @level_ups.count < 10 && i < 30
    @level_ups = Vote.level_ups.limit(20)
    
    # ACTIONS
    if !params[:act].nil?
      if params[:act] == 'boards'
        logger.debug "-----------------params[:act] == 'boards'----------------------------------------"
        # show all postings for all user's boards.
        # postings will be filtered according to membership of the current_user
        @postings_title = "From all my boards:"
        @postings = paginate_board_postings
        paginate = false

      elsif params[:act] == 'schools'
        logger.debug "-----------------params[:act] == 'schools'----------------------------------------"
        # show all postings for all user's schools.
        # postings will be filtered according to membership of the current_user
        @postings_title = "From all my schools:"
        @postings = paginate_schools_postings
        paginate = false
        
      elsif params[:act] == 'users' || params[:act] == 'user_search'
        logger.debug "-------------------params[:act] == 'users' || params[:act] == 'user_search'--------------------------------------"
        @postings_title = "Search for users:"
        @postings = User.search(params[:search])

      elsif params[:act] == 'school_search'
        logger.debug "--------------------params[:act] == 'school_search'-------------------------------------"
        @postings_title = "Search results for schools:"
        if ( params[:search].nil? && params[:state].nil? && params[:city].nil? && ( !current_user.state.nil? || !current_user.city.nil? ) )
          @postings = School.search(params[:search], current_user.state, current_user.city )
        elsif !params[:state].nil? && ( !params[:search].nil? || !params[:city].nil? )
          @postings = School.search(params[:search], params[:state], params[:city] )
        end

      elsif params[:act] == 'board_search'
        logger.debug "---------------------params[:act] == 'board_search'------------------------------------"
        @postings_title = "Search results for boards:"
        @postings = Board.search(params[:search])
        
      elsif params[:act] == 'new_board'
        logger.debug "---------------------params[:act] == 'new_board'------------------------------------"
        @new_board = Board.new
        @postings_title = "Create New Board:"
        @postings = paginate_board_postings
        paginate = false
        
      elsif params[:act] == 'edit_board'
        logger.debug "---------------------params[:act] == 'edit_board'------------------------------------"
        @new_board = Board.find_board(params[:board])
        @new_board = nil unless current_user.owner?( @new_board )
        @postings_title = "Edit Board:"
        #@postings = paginate_board_postings
        #paginate = false

      elsif params[:act] == 'post_search' || params[:act] == 'posts'
        logger.debug "----------------------params[:act] == 'post_search' || params[:act] == 'posts'-----------------------------------"
        if !params[:search].nil? && !params[:search].empty? && !params[:date].nil? && !params[:date].empty?
          @postings_title = "Search Results for \"#{params[:search]}\" on \"#{params[:date]}\":"
        elsif !params[:date].nil? && !params[:date].empty?
          @postings_title = "Search Results on \"#{params[:date]}\":"
        elsif !params[:search].nil? && !params[:search].empty?
          @postings_title = "Search Results for \"#{params[:search]}\":"
        else
          @postings_title = "Search posts:"
        end
        @postings = Posting.search(params[:search],params[:date])

      elsif params[:act] == 'invite' || params[:act] == 'users'
        logger.debug "----------------------params[:act] == 'invite' || params[:act] == 'users'-----------------------------------"
        @postings = User.search(params[:search])

      elsif params[:act] == 'messages'
        logger.debug "-----------------------params[:act] == 'messages'----------------------------------"
        @messages = current_user.recieved.paginate(:page => params[:page], :per_page => per_page )
        @postings_title = 'Messages'
      end
      
      if paginate && !@postings.nil? && !@postings.empty?
        @postings = @postings.paginate(:page => params[:page], :per_page => per_page_search ).order('created_at DESC')
      end
      
    elsif params[:school].nil? && params[:board].nil?
      logger.debug "-------------------------params[:school].nil? && params[:board].nil?--------------------------------"
      # default to postings from all user's boards:
      # postings will be filtered according to membership of the current_user
      @postings_title = "From all my boards:"
      @postings = paginate_board_postings
      paginate = false
    end
    
    # FORM FOR POSITNGS
    @posting_form = Posting.new
    # FORM FOR EVENT
    if params[:act] == 'add_event'
      logger.debug "---------------------------params[:act] == 'add_event'------------------------------"
      @new_event = Posting.new
      @new_event.build_scheduled_event
    elsif params[:act] == 'edit_event'
      logger.debug "---------------------------params[:act] == 'edit_event'------------------------------"
      edit_event = Posting.find_posting(params[:id])
      if edit_event && current_user.id == edit_event.user_id
        @new_event = edit_event
      end
    end
    # Autorefresh form
    @autorefresh = Posting.new

    # show all postings for the school.
    # postings will be filtered according to membership of the current_user
    if !params[:school].nil?
      logger.debug "-------------------------!params[:school].nil?--------------------------------"
      @date = valid_date_or_today(params[:date])
      @school = School.find_school(params[:school])
      if params[:subact] != 'events_only'
        if @school && params[:date]
          @postings = paginate_school_postings_on_date(@school, @date)
        elsif @school
          @postings = paginate_school_postings @school
        end 
      end
      if params[:subact] == 'calendar' || params[:subact] == 'events_only'
        @events = Array.new
        school_events = @school.postings.public_posts.scheduled_events
        set_events_and_posts school_events
      end
    elsif !params[:board].nil?
      logger.debug "------------------------!params[:board].nil?---------------------------------"
      @date = valid_date_or_today(params[:date])
      @board = Board.find_board(params[:board])
      if !@board.nil? && params[:act] != 'invite' && params[:act] != 'edit_event'
        if params[:subact] != 'events_only'
          @postings = Posting.search_board_postings(current_user, @board, params[:search], params[:date]).paginate(:page => params[:page], :per_page => per_page ).order('created_at DESC')
        end
        @events = Array.new
        if @board.postings && @board.postings.any?
          if current_user.member?(@board)
            board_events = @board.postings.scheduled_events
          else
            board_events = @board.postings.public_posts.scheduled_events
          end
        end
        if board_events
          set_events_and_posts board_events
        end
      end
    end
    
    if @postings.nil? || @postings.empty?
      last_post = Posting.find_by_sql("SELECT MAX(id) AS maxid FROM postings")
      @from_posting = last_post[0].maxid
    else
      @from_posting = @postings.first.id
    end
    
    # logger.debug "\n\n After postings \n\n\n"
    @title = @user.full_name
    
    logger.debug "-----------------END OF CONTROLLER----------------------------------------"
    
    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @user }
    end
  end

  private
  
  def set_events_and_posts events
    events.each do |posting|
      if future_events = posting.get_future_events_for_month(@date.beginning_of_month)
        @events += future_events
        if params[:subact] == 'events_only' && params[:search].nil?
          day_events = Array.new
          for event in @events
            if event.next_event == @date
              day_events.push Posting.find(event.posting_id)
            end
          end
          @postings = day_events.paginate(:page => params[:page], :per_page => per_page, :total_etries => day_events.size )
          paginate = false
        end
      end
    end
  end
  
  def paginate_board_postings
    require 'will_paginate/array'
    all_postings = board_postings
    if !all_postings.nil? && !all_postings.empty?
      all_postings.paginate(:page => params[:page], :per_page => per_page, :total_etries => all_postings.size )
    end
  end
  
  def paginate_school_postings_on_date(school, date)
    require 'will_paginate/array'
    all_postings = school_postings_on_date(school, date)
    if !all_postings.nil? && !all_postings.empty?
     all_postings.paginate(:page => params[:page], :per_page => per_page, :total_etries => all_postings.size )
    end
  end
  
  def paginate_school_postings school
    require 'will_paginate/array'
    all_postings = school_postings school
    if !all_postings.nil? && !all_postings.empty?
     all_postings.paginate(:page => params[:page], :per_page => per_page, :total_etries => all_postings.size )
    end
  end
  
  def paginate_schools_postings
    require 'will_paginate/array'
    all_postings = schools_postings
    if !all_postings.nil? && !all_postings.empty?
     all_postings.paginate(:page => params[:page], :per_page => per_page, :total_etries => all_postings.size )
    end
  end
end
