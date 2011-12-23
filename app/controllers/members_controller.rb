class MembersController < ApplicationController
  include ApplicationHelper
  include MembersHelper
  before_filter :authenticate, :only => [:create]
  before_filter :correct_member, :only => [:destroy]
  before_filter :admin_user, :only => [:index, :new, :edit, :show, :update]
  # GET /members
  # GET /members.json
  def index
    page = valid_page_or_one params[:page]
    @users = User.paginate(:page => page, :per_page => per_page).order('created_at DESC')

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
    @board = Board.find_board(params[:member][:board_id])
    @action = 'join'
    if ( !user.nil? && !@board.nil? )
      logger.debug "----------------Member.new-------------------------------------"
      @member = Member.new(params[:member])
      @member.user_id = user.id
      if params[:commit] == Member::Commit::FOLLOW
        logger.debug "----------------Adding a follower #{user.full_name}-------------------------------------"
        @member.user_id = current_user.id # follower could be only the current user
        @member.member_type = Member::MemberType::FOLLOWER
        # follower? is true if a user is a follower, member or owner
        if !current_user.follower?(@board)
        logger.debug "----------------Saving follower #{user.full_name}-------------------------------------"
        @action = 'follow'
        @member.save
        flash.now[:success] = "Board \"#{@board.title}\" was linked to your profile."
        else
        flash.now[:warning] = "Your profile already linked to \"#{@board.title}\"."
        end
      else
        logger.debug "----------------Adding a member #{user.full_name}-------------------------------------"
        if !user.member?(@board)
          logger.debug "----------------User #{user.full_name} is not a member-------------------------------------"
          follower = user.follower?(@board)
          if follower
          logger.debug "----------------Updating follower #{user.full_name} to become a member-------------------------------------"
          follower.update_attribute(:member_type, Member::MemberType::MEMBER)
          else
          logger.debug "----------------Saving #{user.full_name} as a member-------------------------------------"
          @member.member_type = Member::MemberType::MEMBER
          @member.save
          end
        else
          logger.debug "----------------Saving a follower #{user.full_name}-------------------------------------"
          @member.member_type = Member::MemberType::MEMBER
          @member.save
        end
        flash.now[:success] = "#{user.full_name} was added to your Board \"#{@board.title}\"."
      end
    end

    if params[:commit] == Message::Commit::CONFIRM
      msg_id = params[:member][:message]
      unless ( msg_id.nil? )
        message = Message.find(msg_id)
        unless ( message.nil? )
        message.update_attribute(:msg_state, Message::State::CONFIRMED)
        end
      end
    end
    
    params[:act] = 'board_search'
    params[:search] = params[:member][:search] if !params[:member][:search].nil?

    respond_to do |format|
    #if @member.save
      format.html { redirect_to home_path }
      format.js
      format.json { render json: home_path, status: :created, location: home_path }
    #else
    #  format.html { render action: "new" }
    #  format.json { render json: @member.errors, status: :unprocessable_entity }
    #end
    end
  end

  # PUT /members/1
  # PUT /members/1.json
  def update
    @member = Member.find(params[:id])

    respond_to do |format|
      if @member.update_attributes(params[:member])
        format.html { redirect_to @member, notice: "Member was successfully updated." }
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
    if @member
      params[:board_id] = @member.board
      # we can't destroy the member right away because it opens security hole,
      # so let's get the board first
      board = @member.board
      # if the current_user is the owner of the board let's ban the member
      if current_user.owner?(board)
        @member.destroy
      else # otherwise let the user destroy only it's own membership
        @member = current_user.members.find(params[:id])
        @member.destroy
      end
    end

    respond_to do |format|
      format.html { redirect_back_or user_path(params[:id]) }
      format.js
      format.json { head :ok }
    end
  end
end
