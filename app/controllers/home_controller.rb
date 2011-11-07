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
      elsif params[:act] == 'post_search'
        if !params[:search].nil? && !params[:search].empty? && !params[:date].nil? && !params[:date].empty?
          @postings_title = "Search Results for \"#{params[:search]}\" on \"#{params[:date]}\":"
        elsif !params[:date].nil? && !params[:date].empty?
          @postings_title = "Search Results on \"#{params[:date]}\":"
        elsif !params[:search].nil? && !params[:search].empty?
          @postings_title = "Search Results for \"#{params[:search]}\":"
        else
          @postings_title = "Search Results:"
        end
        @postings = Posting.search(params[:search],params[:date])
        if !@postings.nil? && !@postings.empty?
          @postings = @postings.paginate(:page => params[:page], :per_page => per_page ).order('created_at DESC')
        end
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
    # Autorefresh form
    @autorefresh = Posting.new

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
    elsif params[:act] != 'post_search' && @messages.nil? # exclude action for messages and post search
       @postings_title = "From all my boards:"
       @postings = paginate_board_postings
    end
    
    if @postings.nil? || @postings.empty?
      @postings_title = "no posts"
      @last_posting = Time.now.utc
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
  
    def paginate_board_postings
      require 'will_paginate/array'
      all_postings = []
      current_user.boards.each do |board|
        if current_user.member?(board)
          all_postings += board.all_member_comments(current_user.id)
        else
          all_postings += board.postings.where(:visibility => 1)
        end
      end
      if !all_postings.nil? && !all_postings.empty?
        all_postings.sort_by!{|posting|[posting.created_at]}.reverse!
      end
      all_postings.uniq!
      if !all_postings.nil? && !all_postings.empty?
        all_postings = all_postings.paginate(:page => params[:page], :per_page => per_page, :total_etries => all_postings.size )
      end
    end
    
    def paginate_school_postings school
      require 'will_paginate/array'
      all_postings = []
      school.boards.each do |board|
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
      if !all_postings.nil? && !all_postings.empty?
        all_postings = all_postings.paginate(:page => params[:page], :per_page => per_page, :total_etries => all_postings.size )
      end 
    end 

end
