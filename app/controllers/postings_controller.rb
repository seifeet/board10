class PostingsController < ApplicationController
  # allow authenticated users to do only the following actions
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy, :show]
  # only owner of this posting can delete it
  before_filter :authorized_user, :only => :destroy
  # GET /postings
  # GET /postings.json
  def index
    @postings = Posting.paginate(:page => params[:page], :per_page => 40).order('created_at DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @postings }
    end
    
    rescue ActiveRecord::RecordNotFound
      user_not_found
  end

  # GET /postings/1
  # GET /postings/1.json
  def show
    @posting = Posting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @posting }
    end
  end

  # GET /postings/new
  # GET /postings/new.json
  def new
    @posting = Posting.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @posting }
    end
  end

  # GET /postings/1/edit
  def edit
    @posting = Posting.find(params[:id])
  end

  # POST /postings
  # POST /postings.json
  def create
    group = Group.find(params[:group_id])
    # HERE CHECK THAT THE USER BELONGS TO THIS GROUP
    @posting = Posting.new(params[:posting])
    @posting.group_id = group.id
    @posting.user_id = current_user.id

    respond_to do |format|
      if @posting.save
        format.html { redirect_to group, notice: 'Posting was successfully created.' }
        format.json { render json: group, status: :created, location: group }
      else
        format.html { render action: "new" }
        format.json { render json: @posting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /postings/1
  # PUT /postings/1.json
  def update
    @posting = Posting.find(params[:id])

    respond_to do |format|
      if @posting.update_attributes(params[:posting])
        format.html { redirect_to @posting, notice: 'Posting was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @posting.errors, status: :unprocessable_entity }
      end
    end
    rescue ActiveRecord::RecordNotFound
      user_not_found
  end

  # DELETE /postings/1
  # DELETE /postings/1.json
  def destroy
    # we have initialized the @posting in authorized_user filter
    #@posting = Posting.find(params[:id])
    @posting.destroy # if ( @posting.active_user && @posting.active_group )

    respond_to do |format|
      format.html { redirect_to postings_url }
      format.json { head :ok }
    end
  end
  
  private

    def authorized_user
      # ADD: || the owner of the group is trying to delete his group
      @posting = current_user.postings.find_by_id(params[:id])
      redirect_to root_path if @posting.nil?
    end
  
end
