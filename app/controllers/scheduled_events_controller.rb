class ScheduledEventsController < ApplicationController
  include PostingsHelper
  include ApplicationHelper
  before_filter :authenticate, :only => [:create]
  before_filter :owner_user, :only => [:update, :destroy]
  before_filter :admin_user, :only => [:index, :new, :edit, :show]
  # GET /scheduled_events
  # GET /scheduled_events.json
  def index
    @scheduled_events = ScheduledEvent.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @scheduled_events }
    end
  end

  # GET /scheduled_events/1
  # GET /scheduled_events/1.json
  def show
    @scheduled_event = ScheduledEvent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @scheduled_event }
    end
  end

  # GET /scheduled_events/new
  # GET /scheduled_events/new.json
  def new
    @scheduled_event = ScheduledEvent.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @scheduled_event }
    end
  end

  # GET /scheduled_events/1/edit
  def edit
    @scheduled_event = ScheduledEvent.find(params[:id])
  end

  # POST /scheduled_events
  # POST /scheduled_events.json
  def create
    @scheduled_event = ScheduledEvent.new(params[:scheduled_event])

    respond_to do |format|
      if @scheduled_event.save
        format.html { redirect_to @scheduled_event, notice: 'Scheduled event was successfully created.' }
        format.json { render json: @scheduled_event, status: :created, location: @scheduled_event }
      else
        format.html { render action: "new" }
        format.json { render json: @scheduled_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /scheduled_events/1
  # PUT /scheduled_events/1.json
  def update
    @scheduled_event = ScheduledEvent.find(params[:id])

    respond_to do |format|
      if @scheduled_event.update_attributes(params[:scheduled_event])
        format.html { redirect_to @scheduled_event, notice: 'Scheduled event was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @scheduled_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scheduled_events/1
  # DELETE /scheduled_events/1.json
  def destroy
    @scheduled_event = ScheduledEvent.find(params[:id])
    @scheduled_event.destroy

    respond_to do |format|
      format.html { redirect_to scheduled_events_url }
      format.json { head :ok }
    end
  end
end
