class MembersController < ApplicationController
  include MembersHelper
  before_filter :authenticate, :only => [:index]
  before_filter :correct_member, :only => [:destroy]
  
  # GET /members
  # GET /members.json
  def index
    @users = User.paginate(:page => params[:page], :per_page => 50).order('created_at DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /members/1
  # GET /members/1.json
  def show
    @member = Member.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @member }
    end
  end

  # GET /members/new
  # GET /members/new.json
  def new
    @member = Member.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @member }
    end
  end

  # GET /members/1/edit
  def edit
    @member = Member.find(params[:id])
  end

  # POST /members
  # POST /members.json
  def create
    user = User.find_user(params[:member][:user_id])
    group = Group.find_group(params[:member][:group_id])
    valid = true
    if ( !user.nil? && !group.nil? && !user.member?(group))
      @member = Member.new(params[:member])
      @member.user_id = user.id
      if params[:commit] == Message::Commit::CONFIRM
        msg_id = params[:member][:message]
        unless ( msg_id.nil? )
          message = Message.find(msg_id)
          unless ( message.nil? )
            message.update_attribute(:msg_state, Message::State::CONFIRMED)
          end
        end
      end
    else
      flash.now[:success] = "user is null" if user.nil?
      flash.now[:success] = "group is null" if group.nil?
      flash.now[:success] = "user is a member is null" if user.member?(group)
      valid = false
    end

    respond_to do |format|
      if valid && @member.save
        format.html { redirect_to session[:return_to], 
          notice: 'Member was successfully created.' }
        format.json { render json: group_path(@member.group_id),
           status: :created, location: group_path(@member.group_id) }
      else
        format.html { render action: "new" }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /members/1
  # PUT /members/1.json
  def update
    @member = Member.find(params[:id])

    respond_to do |format|
      if @member.update_attributes(params[:member])
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member = Member.find(params[:id])
    @member.destroy

    respond_to do |format|
      format.html { redirect_back_or user_path(params[:id]) }
      format.json { head :ok }
    end
  end
end
