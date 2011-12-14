class UsersController < ApplicationController
  include ApplicationHelper
  include UsersHelper
  before_filter :authenticate, :only => [:index, :show] # :edit, :update,
  before_filter :correct_user, :only => [:edit, :update, :destroy]
  before_filter :not_current_user, :only => [:new, :create]
  #before_filter :admin_user

  # GET /users
  # GET /users.json
  def index
    @page = valid_page_or_one params[:page]
    @users = User.search(params[:search]).paginate(:page => @page, :per_page => 40)
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
    @page = valid_page_or_one params[:page]
    @level_ups = Vote.level_ups.limit(20)

    @user = User.find_user(params[:id])
    raise ActiveRecord::RecordNotFound if ( @user.nil? )

    if current_user.id == @user.id
      @postings_title = "Recent posts:"
      @postings = @user.postings.paginate(:page => @page, :per_page => per_page )
    else
      @postings_title = @user.first_name + "'s public posts:"
      @postings = @user.postings.where(:visibility => 1).paginate(:page => @page, :per_page => per_page )
    end
    
    @postings_title = "no posts" if @postings.nil? || @postings.empty?
    
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
    @page = valid_page_or_one params[:page]

    if params[:act] && @invite = Invitation.find_by_token_value(params[:act])
      board = Board.find_board(@invite.board_id)
      if @invite && board
        @recaptcha_off = true
        @user = User.new
        if board.school_id
          school = School.find_school(board.school_id)
          @user.country = 'United States'
          @user.state = school.state
          @user.city = school.city
          params[:school_id] = school.id
        end
        params[:board_id] = @invite.board_id
      end
    elsif params[:act] && @invite.nil?
      raise ActiveRecord::RecordNotFound
    elsif params[:user] && params[:user][:school_id]
      school = School.find_school(params[:user][:school_id])
      if school
        @user = User.new
        @user.country = 'United States'
        @user.state = school.state
        @user.city = school.city
        params[:school_id] = school.id      
      end
    elsif current_user
      @schools = School.search(params[:search], params[:state], params[:city] ).paginate(:page => @page, :per_page => per_page)
    end
    
    @title = 'Sign Up'
    
    respond_to do |format|
      format.html # new.html.erb
      format.js
      format.json { render json: @user }
    end
    rescue ActiveRecord::RecordNotFound
      page_not_found
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
    
    # signup with invite
    if params[:user][:act]
      @invite = Invitation.find_by_token_value(params[:user][:act])
      @user.email = @invite.token_key
      board = Board.find_board(@invite.board_id)
      school = School.find_school(board.school_id) if board.school_id
      @recaptcha = true if @invite && board
    else # regular signup
      school = School.find_school(params[:user][:school_id]) if params[:user][:school_id]
    end
    
    if !@recaptcha
      @recaptcha = verify_recaptcha(:model => @user, :message => "Please try this challenge again.")
    end
    
    respond_to do |format|
      if @recaptcha && @user.save
        sign_in @user
        @user.has_school!(school.id) if school
        @user.member!(board) if board
        @invite.destroy if @invite
        UserMailer.registration_confirmation(@user).deliver
        flash.now[:success] = "Welcome, " + @user.full_name + '!'
        format.html { redirect_to home_path, notice: "Welcome, " + @user.full_name + '!'}
        format.json { render json: @user, status: :created, location: @user }
      else
        @title = "Sign up"
        flash.now[:error] = "Please correct the errors bellow:"
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
        format.html { redirect_to home_path, notice: 'User was successfully updated.' }
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

    def delete_postings user
      user.delete_postings
    end
    
    def not_current_user
      redirect_to home_path if current_user && !current_user.admin?
    end
end
