class UsersController < ApplicationController
  include ApplicationHelper
  include UsersHelper
  before_filter :authenticate, :only => [:index, :show] # :edit, :update,
  before_filter :correct_user, :only => [:edit, :update, :destroy]
  #before_filter :admin_user

  # GET /users
  # GET /users.json
  def index
    store_location
    @users = User.search(params[:search]).paginate(:page => params[:page], :per_page => 40)
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

    if current_user.id == @user.id
      @postings_title = "Recent Posts:"
      @postings = @user.postings.paginate(:page => params[:page], :per_page => per_page )
    else
      @postings_title = @user.first_name + "'s Public Posts:"
      @postings = @user.postings.where(:visibility => 1).paginate(:page => params[:page], :per_page => per_page )
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
        # UserMailer.registration_confirmation(@user).deliver
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
end
