class BoardsController < ApplicationController
  include BoardsHelper
  before_filter :authenticate, :only => [:index, :show] #, :edit, :update]
  before_filter :correct_board, :only => [:edit, :update] #, :destroy]
  before_filter :correct_owner, :only => [:destroy]
  
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
    @board = Board.find_board(params[:id])
    raise ActiveRecord::RecordNotFound if @board.nil?
    
    # increment view_counter
    search_str = ' ' + @board.id.to_s + ' '
    if session[:board_counter].nil?
      @board.update_attribute(:view_count, @board.view_count+1)
      session[:board_counter] = search_str
    elsif session[:board_counter].index(search_str).nil?
      @board.update_attribute(:view_count, @board.view_count+1)
      session[:board_counter] += @board.id.to_s + ' ';
      # reset the :board_counter with too many boards
      session[:board_counter] = search_str if session[:board_counter].split.count > 30
    end
    
    @members = @board.members.order('created_at ASC')
    
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
        @board.save
        @member = current_user.owner!(@board)
        board_saved = true
      end
    end
    #else
    #  if ( !current_user.member?(@board.id) )
    #    raise ActiveRecord::RecordNotFound
    #  end

    #  @posting = Posting.new(params[:posting])
    #  @posting.board_id = @board.id
    #  @posting.user_id = current_user.id
    #  @posting = current_user.postings.create!(@posting)
    #end
    
    respond_to do |format|
      if ( !params[:posting].nil? && @posting.save ) || board_saved
        format.html { redirect_to session[:return_to], notice: 'Board was successfully created.' }
        format.json { render json: @board, status: :created, location: @board }
      else
        format.html { render action: "new" }
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

    respond_to do |format|
      if @board.update_attributes(params[:board])
        format.html { redirect_to @board, notice: 'Board was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
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
    #@board.destroy

    @board.toggle!(:active)
    delete_postings @board

    respond_to do |format|
      format.html { redirect_back_or boards_url }
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
