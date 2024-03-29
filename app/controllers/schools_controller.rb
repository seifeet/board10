class SchoolsController < ApplicationController
  include ApplicationHelper
  include PostingsHelper
  
  before_filter :authenticate, :only => [:index, :show]
  before_filter :admin_user, :only => [:new, :edit, :create, :update, :destroy]

  # GET /schools
  # GET /schools.json
  def index
    @page = valid_page_or_one params[:page]
    @title = 'Schools'
    store_location # store the page location for back functionality
    if ( params[:search].nil? && params[:state].nil? && params[:city].nil? && ( !current_user.state.nil? || !current_user.city.nil? ) )
      @schools = School.search(params[:search], current_user.state, current_user.city ).paginate(:page => @page, :per_page => per_page)
    else
      @schools = School.search(params[:search], params[:state], params[:city] ).paginate(:page => @page, :per_page => per_page) 
    end
        
    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @schools }
    end
  end

  # GET /schools/1
  # GET /schools/1.json
  def show
    store_location
    
    @school = School.find(params[:id])
    raise ActiveRecord::RecordNotFound if @school.nil?
    
    paginate = true
    @user = current_user
    @level_ups = Vote.level_ups.limit(20)
    
    @date = valid_date_or_today(params[:date])
    if params[:subact] != 'events_only'
      @postings = paginate_school_postings(@school, @date)
    end
    if params[:act] == 'calendar' || params[:subact] == 'events_only'
      @events = @school.get_month_events_for_date(current_user, @date)
      if params[:subact] == 'events_only' && params[:search].nil?
        day_events = posts_with_events_for_date(@events, @date)
        @postings = day_events.paginate(:page => @page, :per_page => per_page, :total_etries => day_events.size )
      end
    end

    # Autorefresh form
    @autorefresh = Posting.new
    
    if @postings.nil? || @postings.empty?
      last_post = Posting.find_by_sql("SELECT MAX(id) AS maxid FROM postings")
      @from_posting = last_post[0].maxid
    else
      @from_posting = @postings.first.id
    end
    
    # logger.debug "\n\n After postings \n\n\n"
    @title = @school.name
    
    @school_boards = @school.boards.order('created_at ASC')

    respond_to do |format|
      format.html # show.html.erb
      format.js
      format.json { render json: @school }
    end
    rescue ActiveRecord::RecordNotFound
      page_not_found
  end

  # GET /schools/new
  # GET /schools/new.json
  def new
    @school = School.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @school }
    end
  end

  # GET /schools/1/edit
  def edit
    @school = School.find(params[:id])
  end

  # POST /schools
  # POST /schools.json
  def create
    @school = School.new(params[:school])

    respond_to do |format|
      if @school.save
        format.html { redirect_to @school, notice: 'School was successfully created.' }
        format.json { render json: @school, status: :created, location: @school }
      else
        format.html { render action: "new" }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /schools/1
  # PUT /schools/1.json
  def update
    @school = School.find(params[:id])

    respond_to do |format|
      if @school.update_attributes(params[:school])
        format.html { redirect_to @school, notice: 'School was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schools/1
  # DELETE /schools/1.json
  def destroy
    @school = School.find(params[:id])
    @school.destroy

    respond_to do |format|
      format.html { redirect_back_or home_path }
      format.js
      format.json { head :ok }
    end
  end

end
