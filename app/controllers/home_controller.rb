class HomeController < ApplicationController
  include HomeHelper
  include ApplicationHelper
  before_filter :only_current_user
  
  def index
    return nil if current_user.nil?
    
    store_location

    @user = current_user
    
    # ACTIONS
    if !params[:act].nil?
      if params[:act] == 'school_search'
        if ( params[:search].nil? && params[:state].nil? && params[:city].nil? && ( !current_user.state.nil? || !current_user.city.nil? ) )
          @search_results = School.search(params[:search], current_user.state, current_user.city ).limit(per_page_search)
        elsif !params[:state].nil? && ( !params[:search].nil? || !params[:city].nil? )
          @search_results = School.search(params[:search], params[:state], params[:city] ).limit(per_page_search)
        end
      elsif params[:act] == 'board_search'
        @search_results = Board.search(params[:search]).limit(per_page_search)
      elsif params[:act] == 'invite'
        @search_results = User.search(params[:search]).limit(per_page_search)
      elsif params[:act] == 'messages'
        @messages = current_user.recieved.paginate(:page => params[:page], :per_page => per_page )
        @postings_title = 'Messages'
      end
      
      if params[:act] == 'new_board'
        @new_board = Board.new
      end
    end
    
    # FORM FOR POSITNGS
    @posting_form = Posting.new

    if !params[:school].nil?
      @school = School.find_school(params[:school])
    elsif !params[:board].nil?
      @board = Board.find_board(params[:board])
    end

    # show all postings for the school.
    # postings will be filtered according to membership of the current_user
    if !@school.nil?
       @postings = paginate_school_postings @school
    # show all postings of the board if current_user is a member
    elsif !@board.nil? && current_user.member?( @board )
       @postings = @board.postings.paginate(:page => params[:page], :per_page => per_page ).order('created_at DESC')
    # show only public postings if current_user is not a member
    elsif !@board.nil? && !current_user.member?( @board )
       @postings = @board.postings.where(:visibility => 1).paginate(:page => params[:page], :per_page => per_page ).order('created_at DESC')
    # show all postings for the board.
    # postings will be filtered according to membership of the current_user
    elsif @messages.nil? # exclude action for messages
       @postings_title = "From all my boards:"
       @postings = paginate_board_postings @user
    end
    
    if @postings.nil? || @postings.empty?
      @postings_title = "no posts"
      @last_posting = Time.now
    else
      @last_posting = @postings.first.created_at
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
  
    def paginate_board_postings user
      require 'will_paginate/array'
      @boards = user.boards
      all_postings = []
      @boards.each do |board|
        if current_user.member?(board)
          all_postings += board.all_member_comments(user.id)
        else
          all_postings += board.postings.where(:visibility => 1)
        end
      end
      
      if !all_postings.nil? && !all_postings.empty?
        all_postings.sort_by!{|posting|[posting.created_at]}.reverse!
      end
      
      all_postings.uniq!
      
      all_postings.paginate(:page => params[:page], :per_page => per_page, :total_etries => all_postings.size )
    end
    
    def paginate_school_postings school
      require 'will_paginate/array'
      @boards = school.boards
      all_postings = []
      @boards.each do |board|
        if current_user.member?(board)
          all_postings += board.postings
        else
          all_postings += board.postings.where(:visibility => 1)
        end
      end
      
      if !all_postings.nil? && !all_postings.empty?
        all_postings.sort_by!{|posting|[posting.created_at]}.reverse!
      end
      
      all_postings.uniq!
      
      all_postings.paginate(:page => params[:page], :per_page => per_page, :total_etries => all_postings.size )
    end 

end
