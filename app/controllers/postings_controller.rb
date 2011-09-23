class PostingsController < ApplicationController
  # allow authenticated users to do only the following actions
  before_filter :authenticate, :only => [:index, :show] #, :edit, :update, :destroy]
  # only owner of this posting can delete it
  before_filter :authorized_user, :only => [:edit, :update, :destroy]
  
  # GET /postings
  # GET /postings.json
  def index
    store_location

    @public_postings = Posting.where(:visibility => 1).paginate(:page => params[:page], :per_page => 100 ).order('created_at DESC')
      
    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @postings }
    end
    rescue ActiveRecord::RecordNotFound
      page_not_found
  end

  # GET /postings/1
  # GET /postings/1.json
  def show
    @posting_form = Posting.new
    @posting = Posting.find(params[:id])
    
    search_str = ' ' + @posting.id.to_s + ' '
    if session[:post_counter].nil?
      @posting.update_attribute(:view_count, @posting.view_count+1)
      session[:post_counter] = search_str
    elsif session[:post_counter].index(search_str).nil?
      @posting.update_attribute(:view_count, @posting.view_count+1)
      session[:post_counter] += @posting.id.to_s + ' ';
      # reset the :post_counter with too many groups
      session[:post_counter] = search_str if session[:post_counter].split.count > 30
    end

    respond_to do |format|
      format.html # show.html.erb
      format.js
      format.json { render json: @posting }
    end
    rescue ActiveRecord::RecordNotFound
      page_not_found
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
    unless current_user.member?(group)
      raise ActiveRecord::RecordNotFound
    end
      
    @posting = Posting.new(params[:posting])
    @posting.group_id = group.id
    @posting.user_id = current_user.id
      
    respond_to do |format|
      if @posting.save
        format.html { redirect_to group, notice: 'Posting was successfully created.' }
        format.js
        format.json { render :json => @posting, status: :created, location: group }
      else
        format.html { redirect_to session[:return_to] , notice: 'Content is empty.' }
        #format.js
        format.json { render json: @posting.errors, status: :unprocessable_entity }
      end
    end
    rescue ActiveRecord::RecordNotFound
      page_not_found
  end

  # PUT /postings/1
  # PUT /postings/1.json
  def update
    @posting = Posting.find(params[:id])

    respond_to do |format|
      if @posting.update_attributes(params[:posting])
        format.html { redirect_to group_path(@posting.group_id), notice: 'Posting was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @posting.errors, status: :unprocessable_entity }
      end
    end
    rescue ActiveRecord::RecordNotFound
      page_not_found
  end

  # DELETE /postings/1
  # DELETE /postings/1.json
  def destroy
    # we have initialized the @posting in authorized_user filter
    #@posting = Posting.find(params[:id])
    group_id = @posting.group_id
    @posting.destroy 

    respond_to do |format|
      format.html { redirect_back_or postings_url }
      format.json { head :ok }
    end
  end
  
  private

    def authorized_user
      # ADD: || the owner of the group is trying to delete his group
      @posting = current_user.postings.find_by_id(params[:id])
      redirect_to user_path(params[:id]) if @posting.nil?
    end
  
end
