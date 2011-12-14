class PostingsController < ApplicationController
  include PostingsHelper
  include ApplicationHelper
  # allow authenticated users to do only the following actions
  #G before_filter :authenticate, :only => [:index] #, :edit, :update, :destroy]
  before_filter :authenticate, :only => [:create, :new]
  # only owner of this posting can delete it
  before_filter :owner_user, :only => [:edit, :update, :destroy]
  # GET /postings
  # GET /postings.json
  def index
    store_location
    
    page = valid_page_or_one params[:page]

    @public_postings = Posting.where(:visibility => 1).paginate(:page => page, :per_page => per_page ).order('created_at DESC')

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
    @posting = Posting.find_posting(params[:id])
    
    page = valid_page_or_one params[:page]
    
    if @posting && @posting.original_posting
      @board = Board.find_board(@posting.board_id)
      @original_post = Posting.find_posting(@posting.original_posting)
      if @board && current_user && current_user.member?( @board.id )
        @postings = @board.postings.where(:original_posting => @posting.original_posting).paginate(:page => page, :per_page => per_page )
      elsif @board
        @postings = @board.postings.where(:visibility => 1, :original_posting => @posting.original_posting).paginate(:page => page, :per_page => per_page )
      end
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
    
    if params[:act] == 'event'
      @posting.build_scheduled_event
    end
    
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
    board = Board.find_board(params[:board_id]) unless params[:board_id].nil?
    school = School.find_school(params[:school_id]) unless params[:school_id].nil?

    empty_err = false
    posting_saved = false
    @public_reply = false
    
    # in replies original_posting will be populated with the id of the first post in that chain
    if params[:content] != 'auto_refresh' && params[:posting][:original_posting]
      original_posting = Posting.find_posting(params[:posting][:original_posting])
      @public_reply = true if original_posting.access == Posting::PUBLIC
    end

    # create a new posting or event
    if params[:content] != 'auto_refresh' && 
      ( @public_reply || board.access == Posting::PUBLIC || current_user.member?(board) )
      # create a new posting
      @posting = Posting.new(params[:posting])
      @posting.board_id = board.id
      @posting.user_id = current_user.id
      #@posting.content = params[:editor] if params[:posting][:content].nil?
      if @posting.content.nil? || @posting.content.empty?
        empty_err = true
        flash.now[:error] = 'Content can not be bank'
      else # save posting and event
        # if it is an event
        if !params[:posting][:scheduled_event_attributes].nil?
          # prepare fields of the event 
          if prepare_event(@posting)
            @posting.transaction do
              # first we save the posting to get the id
              @posting.save
              # then we save the event to get its id
              @posting.scheduled_event.save
              # we set the id on posting as an indicator that posting is an event
              @posting.scheduled_event_id = @posting.scheduled_event.id
              # fainaly save the posting
              posting_saved = @posting.save
            end
            params[:act] = 'edit_event' # sign to home page to add EDIT EVENT button
          end
        else
          posting_saved = @posting.save
        end
      end
    else # no saving for autorefresh
      no_save = true
      # remeber the latest current posting in case we will not find any new posts
      last_post = Posting.find_by_sql("SELECT MAX(id) AS maxid FROM postings")
    end
    
    #params[:content] = params[:posting][:content] if params[:posting][:content]

    respond_to do |format|
      if no_save || ( !empty_err && posting_saved )
        # only get other posts before and after if it comes from home page
        # params[:from_posting] && params[:auto_posting] are used for refresh functionality
        if !params[:from_posting].nil? || !params[:auto_posting].nil?
        @from_posting = @posting.id - 1 if @posting
        # get from_posting value
        if !params[:auto_posting].nil? && !params[:from_posting] != ""
        @from_posting = Integer(params[:auto_posting])
        elsif !params[:from_posting].nil? && !params[:from_posting] != ""
        @from_posting = Integer(params[:from_posting])
        end

        # get all latest postings
        if @from_posting
          if board
            if current_user.member?( board.id )
            @postings = board.postings.where('id > ?', @from_posting)
            else
            @postings = board.postings.where('visibility = 1 and id > ?', @from_posting)
            end
          elsif school
          @postings = school_postings school, @from_posting
          elsif params[:boards] == 'boards'
          @postings = board_postings @from_posting
          end
        end

        # update @from_posting for the next iteration
        if !@postings.nil? && !@postings.empty?
        @from_posting = @postings.first.id
        else
        @from_posting = last_post[0].maxid
        end
        end # for "if !params[:from_posting].nil?"

        format.html { redirect_to stored_location_or_home, notice: '' }
        format.js
        format.json { render :json => @posting, status: :created, location: @posting }
      else
        @errors = true
        format.html { redirect_to stored_location_or_home, notice: ( empty_err ? 'Content is empty.' : 'Unable to save your post.' ) }
        format.js
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
    if !params[:posting][:scheduled_event_attributes].nil?
      event = ScheduledEvent.new(params[:posting][:scheduled_event_attributes])
      params[:act] = 'edit_event' # sign to home page to add EDIT EVENT button
      errors = event.validate_event
      if errors && !errors.blank?
        @errors = true
        flash.now[:error] = errors.html_safe
      end
    end
    respond_to do |format|
      if !@errors && @posting.update_attributes(params[:posting])
        format.html { redirect_to stored_location_or_home, notice: "Your #{@posting.scheduled_event_id ? 'event' : 'post'} was updated." }
        format.js
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.js
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
      format.js
      format.json { head :ok }
    end
  end

  private
  
  def prepare_event posting
    posting.scheduled_event.month = params[:date][:month]
    posting.scheduled_event.month_day = params[:date][:day]
    errors = posting.scheduled_event.validate_event
    if errors && !errors.blank?
      flash.now[:error] = errors.html_safe
      return false
    else
      logger.debug "posting.scheduled_event.start_date-----------------------#{posting.scheduled_event.start_date}------------------------------------"
      posting.scheduled_event.next_event = 
        posting.scheduled_event.get_first_event_date(posting.scheduled_event.start_date)
      return (posting.scheduled_event.next_event ? true : false)
    end
  end

  def owner_user
    @posting = current_user.postings.find_by_id(params[:id]) if current_user
    redirect_to user_path(params[:id]) if current_user.nil? || @posting.nil?
  end

end
