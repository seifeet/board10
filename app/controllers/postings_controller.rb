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

    # create a new posting
    if params[:content] != 'auto_refresh' && current_user.member?(board)
    @posting = Posting.new(params[:posting])
    @posting.board_id = board.id
    @posting.user_id = current_user.id
    @posting.content = params[:editor] if params[:posting][:content].nil?
    empty_err = true if @posting.content.nil? || @posting.content.empty?
    elsif # no saving for autorefresh
    no_save = true
    # remeber the latest current posting in case we will not find any new posts
    last_post = Posting.find_by_sql("SELECT MAX(id) AS maxid FROM postings")
    end

    respond_to do |format|
      if no_save || ( !empty_err && @posting.save )
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
        flash.now[:error] = ( empty_err ? 'Content is empty.' : 'Unable to save your post.' )
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

  def owner_user
    @posting = current_user.postings.find_by_id(params[:id])
    redirect_to user_path(params[:id]) if @posting.nil?
  end

end
