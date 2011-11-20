class PostingsController < ApplicationController
  include PostingsHelper
  # allow authenticated users to do only the following actions
  #G before_filter :authenticate, :only => [:index] #, :edit, :update, :destroy]
  before_filter :authenticate, :only => [:create]
  # only owner of this posting can delete it
  before_filter :owner_user, :only => [:edit, :update, :destroy]
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
    board = Board.find_board(params[:board_id]) unless params[:board_id].nil?
    school = School.find_school(params[:school_id]) unless params[:school_id].nil?

    empty_err = false
    posting_saved = false

    # create a new posting or event
    if params[:content] != 'auto_refresh' && ( board.access == Posting::PUBLIC || current_user.member?(board) )
      # create a new posting
      @posting = Posting.new(params[:posting])
      @posting.board_id = board.id
      @posting.user_id = current_user.id
      @posting.content = params[:editor] if params[:posting][:content].nil?
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

        format.html { redirect_to session[:return_to], notice: '' }
        format.js
        format.json { render :json => @posting, status: :created, location: @posting }
      else
        @errors = true
        format.html { redirect_to session[:return_to], notice: ( empty_err ? 'Content is empty.' : 'Unable to save your post.' ) }
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
  
  def prepare_event posting
    posting.scheduled_event.month = params[:date][:month]
    posting.scheduled_event.month_day = params[:date][:day]
    if validate_event(posting.scheduled_event)
      set_next_event(posting.scheduled_event)
      return true
    end
    false
  end
  
  def set_next_event event
    event.next_event = event.start_time
    case event.repeat
    when ScheduledEvent::Repeat::DAILY
      
    when ScheduledEvent::Repeat::WEEKLY

    when ScheduledEvent::Repeat::BIWEEKLY

    when ScheduledEvent::Repeat::MONTHLY

    when ScheduledEvent::Repeat::YEARLY

    else

    end
  end
  
  def validate_event event
    valid = true
    
    unless event.start_date && event.end_date && event.start_time && event.end_time && event.repeat
      flash.now[:error] = "Event start date can not be blank" unless event.start_date
      flash.now[:error] = "Event end date can not be blank" unless event.end_date
      flash.now[:error] = "Event start time can not be blank" unless event.start_time
      flash.now[:error] = "Event end time can not be blank" unless event.end_time
      flash.now[:error] = "Please select type of event: daily, weekly, etc." unless event.repeat
      valid = false
    end
    unless event.end_date > event.start_date
      flash.now[:error] = "Event start date can not be after event end date"
      valid = false
    end
    unless event.end_time > event.start_time
      flash.now[:error] = "Event start time can not be after event end time"
      valid = false
    end
    #logger.debug "event.repeat #{event.repeat}"
    #logger.debug "event.mo #{event.mo} event.tu #{event.tu} event.we #{event.we} event.th #{event.th} event.fr #{event.fr} event.sa #{event.sa} event.su #{event.su}"
    #logger.debug "event.month #{event.month} event.month_day #{event.month_day} event.month_end #{event.month_end}"
    case event.repeat
    when ScheduledEvent::Repeat::DAILY
    when ScheduledEvent::Repeat::WEEKLY
      unless event.mo || event.tu || event.we || event.th || event.fr || event.sa || event.su
        flash.now[:error] = "At least one of the weekdays must be specifaied for a weekly event."
        valid = false
      end
    when ScheduledEvent::Repeat::BIWEEKLY
      unless event.mo || event.tu || event.we || event.th || event.fr || event.sa || event.su
        flash.now[:error] = "At least one of the weekdays must be specifaied for a biweekly event."
        valid = false
      end
    when ScheduledEvent::Repeat::MONTHLY
      if event.month_end.nil? && event.month_day.nil? #params[:date][:day] 
        flash.now[:error] = "For monthly event a month day or the month end has to be specified."
        valid = false
      end
    when ScheduledEvent::Repeat::YEARLY
      if event.month.nil?
        flash.now[:error] = "For yearly event month can't be blank."
        valid = false
      end
      if event.month_end.nil? && event.month_day.nil? #params[:date][:day] 
        flash.now[:error] = "For yearly event a month day or the month end has to be specified."
        valid = false
      end
    else
      flash.now[:error] = "Unknown event type."
      valid = false
    end
    valid
  end
  
  def owner_user
    @posting = current_user.postings.find_by_id(params[:id])
    redirect_to user_path(params[:id]) if @posting.nil?
  end

end
