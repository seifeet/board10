class GroupsController < ApplicationController
  include UsersHelper
  before_filter :authenticate, :only => [:index, :edit, :update, :show]
  before_filter :correct_user, :only => [:edit, :update, :destroy]
  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.paginate(:page => params[:page], :per_page => 40).order('updated_at DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @posting = Posting.new
    @group = Group.find(params[:id])
    # sending group_id for posting form.
    # if we put postings mox in the group panel permanatly
    # then we can remove this parameter.
    params[:group_id] = @group.id
    @postings = @group.postings.paginate(:page => params[:page], :per_page => 20 ).order('created_at DESC')
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.json
  def create
    if ( !params[:group].nil? )
       @group = Group.new(params[:group])
    else
       @posting = Posting.new(params[:posting])
       # HERE CHECK THAT THE USER BELONGS TO THIS GROUP
       @posting.group_id = @group.id
       @posting.user_id = current_user.id
       @posting = current_user.postings.build(@posting)
    end

    respond_to do |format|
      if ( !params[:posting].nil? && @posting.save ) || @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    #@group.destroy
    
    @group.toggle!(:active)
    delete_postings @group

    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :ok }
    end
  end
  
  private
  
    def delete_postings group
      group.delete_postings
    end
end
