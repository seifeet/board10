class UsersController < ApplicationController
  include UsersHelper
  before_filter :authenticate, :only => [:index, :show] # :edit, :update,
  before_filter :correct_user, :only => [:edit, :update, :destroy]
  #before_filter :admin_user

  # GET /users
  # GET /users.json
  def index
    store_location
    @users = User.search(params[:search]).paginate(:page => params[:page], :per_page => 40)
    #@users = User.paginate(:page => params[:page], :per_page => 40).order('created_at ASC')
    @title = 'People'
    
    respond_to do |format|
      format.html
      format.js
      format.json { render :json => @users.to_json }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    store_location

    @user = User.find_user(params[:id])
    raise ActiveRecord::RecordNotFound if ( @user.nil? )
    
   if !params[:search].nil? || !params[:state].nil? || !params[:city].nil?
      @search_results = School.search(params[:search], params[:state], params[:city] )
    end
    
    # we can remove this if as soon as Andrey finishs with home page.
    if @user.id != current_user.id
      search_str = ' ' + @user.id.to_s + ' '
      if session[:user_counter].nil?
        @user.view_count = @user.view_count + 1
        @user.save_without_password
        session[:user_counter] = search_str
      elsif session[:user_counter].index(search_str).nil?
        @user.view_count = @user.view_count + 1
        @user.save_without_password
        session[:user_counter] += @user.id.to_s + ' ';
        # reset the :user_counter with too many users
        session[:user_counter] = search_str if session[:user_counter].split.count > 30
      end
    end
    
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
    elsif !params[:board].nil? && params[:board] == "all"
       @postings_title = "From all my boards:"
       @postings = paginate_board_postings @user
    else # for all other non-members show only public posts:
       @postings_title = @user.first_name + "'s Public Posts:"
       @postings = @user.postings.where(:visibility => 1).paginate(:page => params[:page], :per_page => 50 ).order('created_at DESC')
    end
    
    @postings_title = "no posts" if @postings.nil? || @postings.empty?
    
    @show_posting_form = false
    
    # logger.debug "\n\n After postings \n\n\n"
    @title = @user.full_name;
    
    respond_to do |format|
      format.html # show.html.erb
      format.js
      format.json { render json: @user }
    end
    rescue ActiveRecord::RecordNotFound
      page_not_found
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    @title = 'Sign Up'
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    # @user was set in 'before_filter :correct_user'
    #@user = User.find(params[:id])
    @title = 'Edit - ' + @user.full_name
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        sign_in @user
        format.html { redirect_to @user, notice: "Welcome, " + @user.full_name + '!'}
        format.json { render json: @user, status: :created, location: @user }
      else
        @title = "Sign up"
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    # @user was set in 'before_filter :correct_user'
    #@user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    # @user was set in 'before_filter :correct_user'
    #@user = User.find(params[:id])
    
    @user.toggle!(:active)
    delete_postings @user
    
    #flash.now[:success] = "We hope to see you again."
    respond_to do |format|
      format.html { redirect_to signin_path, notice: 'We hope to see you again.' }
      format.json { head :ok }
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
  
    def delete_postings user
      user.delete_postings
    end
end
