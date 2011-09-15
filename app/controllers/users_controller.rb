class UsersController < ApplicationController
  include UsersHelper
  before_filter :authenticate, :only => [:index, :edit, :update, :show]
  before_filter :correct_user, :only => [:edit, :update, :destroy]
  #before_filter :admin_user

  # GET /users
  # GET /users.json
  def index
    store_location
    @users = User.paginate(:page => params[:page], :per_page => 40).order('created_at ASC')
    @title = 'Boardlers'
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    store_location
    @user = User.find(params[:id])
    
    search_str = ' ' + @user.id.to_s + ' '
    if session[:user_counter].nil?
      @user.update_attribute(:view_count, @user.view_count+1)
      session[:user_counter] = search_str
    elsif session[:user_counter].index(search_str).nil?
      @user.update_attribute(:view_count, @user.view_count+1)
      session[:user_counter] += @user.id.to_s + ' ';
      # reset the :user_counter with too many groups
      session[:user_counter] = search_str if session[:user_counter].split.count > 30
    end
    
    @postings = @user.postings.paginate(:page => params[:page], :per_page => 20 ).order('created_at DESC')
    
    @title = @user.full_name;
    
    respond_to do |format|
      format.html # show.html.erb
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
  
    def delete_postings user
      user.delete_postings
    end
end
