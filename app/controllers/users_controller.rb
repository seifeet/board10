class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy, :show]
  before_filter :correct_user, :only => [:edit, :update, :destroy]
  before_filter :admin_user,   :only => :destroy

  # GET /users
  # GET /users.json
  def index
    @users = User.where(:active => true).paginate(:page => params[:page], :per_page => 40).order('created_at ASC')
    @title = 'Boardlers'
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
    
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.active_user.find(params[:id])
    @postings = @user.postings.paginate(:page => params[:page], :per_page => 20 )
    @title = @user.full_name;
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end

    rescue ActiveRecord::RecordNotFound
      user_not_found
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
    @user = User.active_user.find(params[:id])
    
    @title = 'Edit - ' + @user.full_name
    
    rescue ActiveRecord::RecordNotFound
      user_not_found
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
    @user = User.active_user.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
    rescue ActiveRecord::RecordNotFound
      user_not_found
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.active_user.find(params[:id])
    
    @user.toggle!(:active)

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
    rescue ActiveRecord::RecordNotFound
      user_not_found
  end
  
  private
  
    def user_not_found
      # etu hren' nado meniat'!
      flash[:success] = "Profile Unavailable"
      redirect_to '404'
    end

    def authenticate
      deny_access unless signed_in?
    end
    
    def correct_user
      @user = User.active_user.find(params[:id])
      redirect_to(@user) unless current_user?(@user) # || current_user.admin?
      rescue ActiveRecord::RecordNotFound
      user_not_found
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
