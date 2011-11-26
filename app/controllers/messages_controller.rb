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
    
    if commit == Message::Commit::JOIN || commit == Message::Commit::INVITE
      board = Board.find_board(params[:message][:board_id])
      user = User.find_user(params[:message][:to_user])
      if ( !board.nil? && !user.nil? )
        content = params[:message][:content]
  
        @message.to_user = user.id
        @message.board_id = board.id
        @message.from_user = current_user.id
        @message.subject = commit + " request for board \"#{board.title}\""
        @message.content = content
        @message.msg_type = Message::Type::JOIN if ( commit == Message::Commit::JOIN )
        @message.msg_type = Message::Type::INVITE if ( commit == Message::Commit::INVITE )
        @message.msg_state = Message::State::UNREAD
        valid = true
      end
    end
    
    params[:act] = 'board_search'
    params[:search] = params[:message][:search] if !params[:message][:search].nil?

    respond_to do |format|
      if valid && @message.save
        msg = 'Your request to join the board was sent!'
        flash.now[:success] = msg
      else
        msg = 'Unable to send your request.'
        flash.now[:error] = msg
      end
      format.html { redirect_to home_path, notice: msg }
      format.js
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
        format.js
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
      format.html { redirect_back_or home_path }
      format.json { head :ok }
    end
  end
end
