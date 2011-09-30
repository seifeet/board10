class UserSchoolsController < ApplicationController
  # GET /user_schools
  # GET /user_schools.json
  def index
    @user_schools = UserSchool.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_schools }
    end
  end

  # GET /user_schools/1
  # GET /user_schools/1.json
  def show
    @user_school = UserSchool.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_school }
    end
  end

  # GET /user_schools/new
  # GET /user_schools/new.json
  def new
    @user_school = UserSchool.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_school }
    end
  end

  # GET /user_schools/1/edit
  def edit
    @user_school = UserSchool.find(params[:id])
  end

  # POST /user_schools
  # POST /user_schools.json
  def create
    user = User.find_user(params[:user_school][:user_id])
    school = School.find_school(params[:user_school][:school_id])
    valid = true
    if ( !user.nil? && !school.nil? && !user.has_school?(school))
      @user_school = UserSchool.new(params[:user_school])
      @user_school.user_id = user.id
    else
      valid = false
    end

    respond_to do |format|
      if valid && @user_school.save
        format.html { redirect_to session[:return_to], notice: 'User school was successfully created.' }
        format.json { render json: @user_school, status: :created, location: @user_school }
      else
        format.html { render action: "new" }
        format.json { render json: @user_school.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_schools/1
  # PUT /user_schools/1.json
  def update
    @user_school = UserSchool.find(params[:id])

    respond_to do |format|
      if @user_school.update_attributes(params[:user_school])
        format.html { redirect_to @user_school, notice: 'User school was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_school.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_schools/1
  # DELETE /user_schools/1.json
  def destroy
    @user_school = UserSchool.find(params[:id])
    @user_school.destroy

    respond_to do |format|
      format.html { redirect_to user_schools_url }
      format.json { head :ok }
    end
  end
end
