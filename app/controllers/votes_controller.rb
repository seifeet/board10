class VotesController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate, :only => [:create, :destroy, :update]
  before_filter :admin_user, :only => [:index, :new, :edit, :show]
  # POST /votes
  # POST /votes.json
  def create
    @vote = Vote.new(params[:vote])

    respond_to do |format|
      if current_user.vote!(@vote)
        format.html { redirect_to session[:return_to], notice: 'Your vote was accepted.' }
        format.js
        format.json { render json: @vote, status: :created, location: @vote }
      #else
      #  format.html { render action: "new" }
      #  format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /votes/1
  # DELETE /votes/1.json
  def destroy
    @vote = Vote.find(params[:id])
    current_user.unvote!(@vote)

    respond_to do |format|
      format.html { redirect_to session[:return_to], notice: 'Your vote was removed.' }
      format.js
      format.json { head :ok }
    end
    rescue ActiveRecord::RecordNotFound
      page_not_found
  end
end
