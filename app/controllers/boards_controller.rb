class BoardsController < ApplicationController
  include ApplicationHelper
  include PostingsHelper
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
    page = valid_page_or_one params[:page]
    @boards = Board.search(params[:search]).paginate(:page => page, :per_page => 50).order('created_at DESC')
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
    @board = Board.unscoped.find(params[:id])
    raise ActiveRecord::RecordNotFound if @board.nil?
    
    page = valid_page_or_one params[:page]
    paginate = true
    @user = current_user
    @level_ups = Vote.level_ups.limit(20)
    
    # ACTIONS
    if !params[:act].nil?
      if params[:act] ==  'cancel'
        # don't do anything
      elsif params[:act] == 'edit_board'
        logger.debug "---------------------params[:act] == 'edit_board'------------------------------------"
        @new_board = @board if current_user.owner?( @board )
        @postings_title = "Edit Board:"

      elsif params[:act] == 'post_search'
        logger.debug "----------------------params[:act] == 'post_search' || params[:act] == 'posts'-----------------------------------"
        if !params[:search].nil? && !params[:search].empty? && !params[:date].nil? && !params[:date].empty?
          @postings_title = "Search Results for \"#{params[:search]}\" on \"#{params[:date]}\":"
        elsif !params[:date].nil? && !params[:date].empty?
          @postings_title = "Search Results on \"#{params[:date]}\":"
        elsif !params[:search].nil? && !params[:search].empty?
          @postings_title = "Search Results for \"#{params[:search]}\":"
        else
          @postings_title = "Search posts:"
        end
        @postings = Posting.search(params[:search],params[:date])

      elsif params[:act] == 'invite' && current_user.owner?( @board )
        logger.debug "----------------------params[:act] == 'invite' || params[:act] == 'users'-----------------------------------"
        @postings = User.search(params[:search])
        @postings_title = "Search people:"
        
      elsif params[:act] == 'invite_by_email' && current_user.owner?( @board )
        @email_results = validate_emails params[:emails]
        @email_errors = @email_results.has_value? 'x'
        if @email_results && !@email_results.empty? && !@email_errors
          if board = Board.find_board(params[:board])
            current_user.send_invites(board, @email_results)
          end
        end

      elsif params[:act] == 'messages'
        logger.debug "-----------------------params[:act] == 'messages'----------------------------------"
        @messages = current_user.recieved.paginate(:page => page, :per_page => per_page )
        @postings_title = 'Messages'
      end
      
      if paginate && !@postings.nil? && !@postings.empty?
        @postings = @postings.paginate(:page => page, :per_page => per_page_search ).order('created_at DESC')
      end
    end
    
    if @postings.nil? && @messages.nil?
      logger.debug "------------------------@postings.nil? && @messages.nil?---------------------------------"
      @date = valid_date_or_today(params[:date])
      if !@board.nil? && params[:act] != 'invite' && params[:act] != 'edit_event'
        @events = @board.get_month_events_for_date(current_user, @date)
        if params[:subact] != 'events_only'
          @postings = Posting.search_board_postings(current_user, @board, params[:search], params[:date]).paginate(:page => page, :per_page => per_page ).order('created_at DESC')
        elsif params[:subact] == 'events_only' && params[:search].nil? && @events
          day_events = posts_with_events_for_date(@events, @date)
          @postings = day_events.paginate(:page => @page, :per_page => per_page, :total_etries => day_events.size )
        end
      end
    end
    
    # Autorefresh form
    @autorefresh = Posting.new
    
    # FORM FOR POSITNGS
    @posting_form = Posting.new
    # FORM FOR EVENT
    if params[:act] == 'add_event'
      logger.debug "---------------------------params[:act] == 'add_event'------------------------------"
      @new_event = Posting.new
      @new_event.build_scheduled_event
    elsif params[:act] == 'edit_event'
      logger.debug "---------------------------params[:act] == 'edit_event'------------------------------"
      edit_event = Posting.find_posting(params[:event_id])
      if edit_event && current_user.id == edit_event.user_id
        @new_event = edit_event
      end
    end

    if @postings.nil? || @postings.empty?
      last_post = Posting.find_by_sql("SELECT MAX(id) AS maxid FROM postings")
      @from_posting = last_post[0].maxid
    else
      @from_posting = @postings.first.id
    end
    
    # logger.debug "\n\n After postings \n\n\n"
    @title = @board.title
    
    @members = @board.members.order('created_at ASC')
    
    logger.debug "-----------------END OF CONTROLLER----------------------------------------"
    
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
