class VotesController < ApplicationController
  # POST /votes
  # POST /votes.json
  def create
    @vote = Vote.new(params[:vote])

    respond_to do |format|
      if current_user.vote!(@vote)
        format.html { redirect_to home_path, notice: 'Your vote was accepted.' }
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
      format.html { redirect_to home_path, notice: 'Your vote was removed.' }
      format.json { head :ok }
    end
    rescue ActiveRecord::RecordNotFound
      page_not_found
  end
end
