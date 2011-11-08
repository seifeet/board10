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
    board = Board.find(params[:board_id]) unless params[:board_id].nil?
    school = School.find(params[:school_id]) unless params[:school_id].nil?
    
    if params[:content] == 'auto_refresh'
      params[:board_id] = board.id unless params[:board_id].nil?
      params[:school_id] = school.id unless params[:school_id].nil?
      params[:act] = 'boards' unless params[:boards].nil?
      @no_save = true
      params[:autorefresh] = true
      @last_posting = params[:auto_posting]
    elsif current_user.member?(board) # only member can create messages
      @posting = Posting.new(params[:posting])
      @posting.board_id = board.id
      @posting.user_id = current_user.id
      @posting.content = params[:editor] if params[:content].nil?
      @err = true if @posting.content.nil? || @posting.content.empty?
      @last_posting = params[:last_posting]
    end
    
    respond_to do |format|
      if @no_save || ( !@err && @posting.save )
        format.html { redirect_to session[:return_to], notice: '' }
        format.js
        format.json { render :json => @posting, status: :created, location: @posting }
      else
        flash.now[:error] = "Content is empty."
        format.html { redirect_to session[:return_to], notice: 'Content is empty.' }
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
        format.html { redirect_to session[:return_to], notice: 'Your posting was updated.' }
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
    board_id = @posting.board_id
    @posting.destroy 

    respond_to do |format|
      format.html { redirect_back_or postings_url }
      format.json { head :ok }
    end
  end
  
  private

    def authorized_user
      # ADD: || the owner of the board is trying to delete his board
      @posting = current_user.postings.find_by_id(params[:id])
      redirect_to user_path(params[:id]) if @posting.nil?
    end
  
end
