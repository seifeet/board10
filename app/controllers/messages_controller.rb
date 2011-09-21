class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.json
  def index
    store_location
    @messages = current_user.recieved

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    store_location
    @message = Message.find(params[:id])
    
    if ( @message.msg_state == Message::State::UNREAD )
       @message.update_attribute(:msg_state, Message::State::READ)
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.json
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.json
  def create
    commit = params[:commit]
    @message = Message.new(params[:message])
    valid = false
    
    if commit == Message::Commit::JOIN
      group = Group.find_group(params[:message][:group_id])
      user = User.find_user(params[:message][:to_user])
      if ( !group.nil? && !user.nil? )
        content = params[:message][:content]
  
        @message.to_user = user.id
        @message.group_id = group.id
        @message.from_user = current_user.id
        @message.subject = "Request to join your group \"#{group.title}\""
        @message.content = content
        @message.msg_type = Message::Type::JOIN
        @message.msg_state = Message::State::UNREAD
        valid = true
      end
    end

    # it does not flash messages for some reason.... :(
    respond_to do |format|
      if valid && @message.save
        msg = 'Your request to join the group was sent!'
      else
        msg = 'Unable to send your request.'
      end
      format.html { redirect_to session[:return_to], notice: msg }
      format.json { render json: @message }
    end
    rescue ActiveRecord::RecordNotFound
      page_not_found
  end

  # PUT /messages/1
  # PUT /messages/1.json
  def update
    @message = Message.find(params[:id])
    commit = params[:commit]
    if commit == Message::Commit::REJECT
      @message.update_attribute(:msg_state, Message::State::REJECTED)
    end

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to session[:return_to], notice: 'Message was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :ok }
    end
  end
end
