class GroupsController < ApplicationController
  include GroupsHelper
  before_filter :authenticate, :only => [:index, :edit, :update, :show]
  before_filter :correct_group, :only => [:edit, :update, :destroy]
  # GET /groups
  # GET /groups.json
  def index
    store_location # store the page location for back functionality
    @groups = Group.unscoped.paginate(:page => params[:page], :per_page => 40).order('created_at DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    store_location # store the page location for back functionality
    @posting_form = Posting.new
    @group = Group.unscoped.find(params[:id])
    
    search_str = ' ' + @group.id.to_s + ' '
    if session[:group_counter].nil?
      @group.update_attribute(:view_count, @group.view_count+1)
      session[:group_counter] = search_str
    elsif session[:group_counter].index(search_str).nil?
      @group.update_attribute(:view_count, @group.view_count+1)
      session[:group_counter] += @group.id.to_s + ' ';
      # reset the :group_counter with too many groups
      session[:group_counter] = search_str if session[:group_counter].split.count > 30
    end
    
    # sending group_id for posting form.
    # if we put postings box in the group panel permanatly
    # then we can remove this parameter.
    # params[:group_id] = @group.id
    # if user is a member of the group then get all postings
    if ( current_user.member?( @group.id ) )
      @postings = @group.postings.paginate(:page => params[:page],
      :per_page => 20 ).order('created_at DESC')
    else # get only public postings
      @postings = @group.postings.where(:visibility => 1).paginate(:page => params[:page],
      :per_page => 20 ).order('created_at DESC')
    end
    
    @members = @group.members.paginate(:page => params[:page],
      :per_page => 20 ).order('created_at ASC')

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group }
    end
    rescue ActiveRecord::RecordNotFound
      page_not_found
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
    group_saved = false
    if ( !params[:group].nil? )
      @group = Group.new(params[:group])
      @group.transaction do 
        @group.save
        @member = current_user.owner!(@group)
        group_saved = true
      end
    else
      if ( !current_user.member?(@group.id) )
        raise ActiveRecord::RecordNotFound
      end
      @posting = Posting.new(params[:posting])
      @posting.group_id = @group.id
      @posting.user_id = current_user.id
      @posting = current_user.postings.create!(@posting)
    end

    respond_to do |format|
      if ( !params[:posting].nil? && @posting.save ) || group_saved
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
    rescue ActiveRecord::RecordNotFound
      page_not_found
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
    rescue ActiveRecord::RecordNotFound
      page_not_found
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    #@group.destroy

    @group.toggle!(:active)
    delete_postings @group

    respond_to do |format|
      format.html { redirect_back_or groups_url }
      format.json { head :ok }
    end
    rescue ActiveRecord::RecordNotFound
      page_not_found
  end

  private

  def delete_postings group
    group.delete_postings
  end
end
