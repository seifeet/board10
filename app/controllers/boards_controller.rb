class BoardsController < ApplicationController
  include ApplicationHelper
  include BoardsHelper
  #G before_filter :authenticate, :only => [:index, :show] #, :edit, :update]
  #G before_filter :correct_board, :only => [:edit, :update] #, :destroy]
  #G before_filter :correct_owner, :only => [:destroy]
  before_filter :authenticate, :only => [:index, :show, :create, :new]
  before_filter :correct_owner, :only => [:destroy, :edit, :update]
  # GET /boards
  # GET /boards.json
  def index
    store_location # store the page location for back functionality
    @boards = Board.search(params[:search]).paginate(:page => params[:page], :per_page => 50).order('created_at DESC')
    @title = 'Boards'
    respond_to do |format|
      format.html # index.html.erb
      format.js
      #format.json { render json: @boards }
    end
  end

  # GET /boards/1
  # GET /boards/1.json
  def show
    store_location # store the page location for back functionality
    @posting_form = Posting.new
    @board = Board.unscoped.find(params[:id])
    raise ActiveRecord::RecordNotFound if @board.nil?
    @members = @board.members.order('created_at ASC')
    
    if !params[:act].nil?
      if params[:act] == 'invite'
        @search_results = User.search(params[:search])
      end
    end
    
    if ( current_user.member?( @board.id ) )
      @postings = @board.postings.paginate(:page => params[:page], :per_page => per_page )
    else
      @postings = @board.postings.where(:visibility => 1).paginate(:page => params[:page], :per_page => per_page )
    end
   
    if @postings.nil? || @postings.empty?
      @postings_title = "no posts"
      last_post = Posting.find_by_sql("SELECT MAX(id) AS maxid FROM postings")
      @from_posting = last_post[0].maxid
    else
      @from_posting = @postings.first.id
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.js
      format.json { render json: @board }
    end
    rescue ActiveRecord::RecordNotFound
      page_not_found
  end

  # GET /boards/new
  # GET /boards/new.json
  def new
    @board = Board.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @board }
    end
  end

  # GET /boards/1/edit
  def edit
    @board = Board.find(params[:id])
  end

  # POST /boards
  # POST /boards.json
  def create
    board_saved = false
    if ( !params[:board].nil? )
      @board = Board.new(params[:board])
      @board.transaction do 
        if ( !@board.title.empty? && !@board.description.empty? )
          @board.save
          @member = current_user.owner!(@board)
          board_saved = true
        else
          flash.now[:error] = "Please provide title and description for your board."
        end
      end
    end
    
    respond_to do |format|
      if ( !params[:posting].nil? && @posting.save ) || board_saved
        format.html { redirect_to home_path + '?board=' + @board.id.to_s, notice: 'Board was successfully created.' }
        format.js
        format.json { render json: @board, status: :created, location: @board }
      else
        format.html { render action: "new" }
        format.js
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
    rescue ActiveRecord::RecordNotFound
      page_not_found
  end

  # PUT /boards/1
  # PUT /boards/1.json
  def update
    @board = Board.find(params[:id])
    @failures = false
    
    if params[:board][:title] && params[:board][:description] && (params[:board][:title].blank? || params[:board][:description].blank?)
      flash.now[:error] = "Title can't be blank" if params[:board][:title] && params[:board][:title].blank?
      flash.now[:error] = "Description can't be blank" if params[:board][:description] && params[:board][:description].blank?
      @failures = true
    end

    respond_to do |format|
      if !@failures && @board.update_attributes(params[:board])
        flash.now[:success] = 'Your board was successfully updated.'
        format.html { redirect_to @board, notice: 'Board was successfully updated.' }
        format.js
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.js
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
    rescue ActiveRecord::RecordNotFound
      page_not_found
  end

  # DELETE /boards/1
  # DELETE /boards/1.json
  def destroy
    @board = Board.find(params[:id])
    
    if @board.postings.any?
      @board.toggle!(:active)
      delete_postings @board
    else
      @board.destroy
    end

    respond_to do |format|
      format.html { redirect_to home_path, notice: 'Your board became inactive.' }
      format.js
      format.json { head :ok }
    end
    rescue ActiveRecord::RecordNotFound
      page_not_found
  end

  private

  def delete_postings board
    board.delete_postings
  end
end
