class HomeController < ApplicationController
  include HomeHelper
  include PostingsHelper
  include ApplicationHelper
  before_filter :only_current_user
  
  def index
    return nil if current_user.nil?
    
    store_location
    
    paginate = true

    @user = current_user
    
    # ACTIONS
    if !params[:act].nil?
      if params[:act] == 'boards'
        # show all postings for the board.
        # postings will be filtered according to membership of the current_user
        @postings_title = "From all my boards:"
        @postings = paginate_board_postings
        paginate = false

      elsif params[:act] == 'school_search'
        @postings_title = "Search results for schools:"
        if ( params[:search].nil? && params[:state].nil? && params[:city].nil? && ( !current_user.state.nil? || !current_user.city.nil? ) )
          @postings = School.search(params[:search], current_user.state, current_user.city )
        elsif !params[:state].nil? && ( !params[:search].nil? || !params[:city].nil? )
          @postings = School.search(params[:search], params[:state], params[:city] )
        end

      elsif params[:act] == 'board_search'
        @postings_title = "Search results for boards:"
        @postings = Board.search(params[:search])

      elsif params[:act] == 'post_search'
        if !params[:search].nil? && !params[:search].empty? && !params[:date].nil? && !params[:date].empty?
          @postings_title = "Search Results for \"#{params[:search]}\" on \"#{params[:date]}\":"
        elsif !params[:date].nil? && !params[:date].empty?
          @postings_title = "Search Results on \"#{params[:date]}\":"
        elsif !params[:search].nil? && !params[:search].empty?
          @postings_title = "Search Results for \"#{params[:search]}\":"
        else
          @postings_title = "Search results for posts:"
        end
        @postings = Posting.search(params[:search],params[:date])

      elsif params[:act] == 'invite'
        @postings = User.search(params[:search])

      elsif params[:act] == 'messages'
        @messages = current_user.recieved.paginate(:page => params[:page], :per_page => per_page )
        @postings_title = 'Messages'
      end
      
      if paginate && !@postings.nil? && !@postings.empty?
        @postings = @postings.paginate(:page => params[:page], :per_page => per_page_search ).order('created_at DESC')
      end
      
      if params[:act] == 'new_board'
        @new_board = Board.new
      end
    else params[:school].nil? && params[:board].nil?
      # default to postings from all user's boards:
      # postings will be filtered according to membership of the current_user
      @postings_title = "From all my boards:"
      @postings = paginate_board_postings
      paginate = false
    end
    
    # FORM FOR POSITNGS
    @posting_form = Posting.new
    # Autorefresh form
    @autorefresh = Posting.new

    # show all postings for the school.
    # postings will be filtered according to membership of the current_user
    if !params[:school].nil?
      @school = School.find_school(params[:school])
      @postings = paginate_school_postings @school if !@school.nil?
    elsif !params[:board].nil?
      @board = Board.find_board(params[:board])
      # show all postings of the board if current_user is a member
      if !@board.nil? && params[:act] != 'invite' && current_user.member?( @board )
        @postings = @board.postings.paginate(:page => params[:page], :per_page => per_page ).order('created_at DESC')
      # show only public postings if current_user is not a member
      elsif !@board.nil? && params[:act] != 'invite' && !current_user.member?( @board )
        @postings = @board.postings.where(:visibility => 1).paginate(:page => params[:page], :per_page => per_page ).order('created_at DESC')
      end
    end
    
    if @postings.nil? || @postings.empty?
      @postings_title = "no posts"
      last_post = Posting.find_by_sql("SELECT MAX(id) AS maxid FROM postings")
      @from_posting = last_post[0].maxid
    else
      @from_posting = @postings.first.id
    end
    
    # logger.debug "\n\n After postings \n\n\n"
    @title = @user.full_name;

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @user }
    end
  end

  private
  
  def paginate_board_postings
    require 'will_paginate/array'
    all_postings = board_postings
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
end
