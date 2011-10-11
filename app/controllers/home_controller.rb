class HomeController < ApplicationController
  include HomeHelper
  before_filter :only_current_user
  
  def index
    return nil if current_user.nil?
    
    store_location

    @user = current_user
    
    # SEARCHES
    if !params[:school_search].nil?
      if ( params[:search].nil? && params[:state].nil? && params[:city].nil? && ( !current_user.state.nil? || !current_user.city.nil? ) )
        @search_results = School.search(params[:search], current_user.state, current_user.city ).limit(50)
      elsif !params[:state].nil? && ( !params[:search].nil? || !params[:city].nil? )
        @search_results = School.search(params[:search], params[:state], params[:city] ).limit(50)
      end
      
    elsif !params[:board_search].nil?
      @search_results = Board.search(params[:search]).limit(50)
    end
    
    # FORM FOR POSITNGS
    @posting_form = Posting.new

    if !params[:school].nil?
      @school = School.find_school(params[:school])
    elsif !params[:board].nil? && params[:board] != "all"
      @board = Board.find_board(params[:board])
    end

    # show all postings for the school.
    # postings will be filtered according to membership of the current_user
    if !@school.nil?
       @postings = paginate_school_postings @school
    # show all postings of the board if current_user is a member
    elsif !@board.nil? && current_user.member?( @board )
       @postings = @board.postings.paginate(:page => params[:page], :per_page => 50 ).order('created_at DESC')
    # show only public postings if current_user is not a member
    elsif !@board.nil? && !current_user.member?( @board )
       @postings = @board.postings.where(:visibility => 1).paginate(:page => params[:page], :per_page => 50 ).order('created_at DESC')
    # show all postings for the board.
    # postings will be filtered according to membership of the current_user
    else # !params[:board].nil? && params[:board] == "all"
       @postings_title = "From all my boards:"
       @postings = paginate_board_postings @user
    # else # for all other non-members show only public posts:
    #   @postings_title = "My Public Posts:"
    #   @postings = @user.postings.where(:visibility => 1).paginate(:page => params[:page], :per_page => 50 ).order('created_at DESC')
    end
    
    @postings_title = "no posts" if @postings.nil? || @postings.empty?
    
    #@show_posting_form = false not used
    
    # logger.debug "\n\n After postings \n\n\n"
    @title = @user.full_name;
    
    @new_board = Board.new
    
    respond_to do |format|
      format.html
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
      
      all_postings.paginate(:page => params[:page], :per_page => 50, :total_etries => all_postings.size )
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
      
      all_postings.paginate(:page => params[:page], :per_page => 50, :total_etries => all_postings.size )
    end 

end
