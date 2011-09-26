module BoardsHelper
  def correct_board
    @board = Board.find(params[:id])
    redirect_to(@board) unless @board.member?(current_user) || current_user.admin?
  rescue ActiveRecord::RecordNotFound
    page_not_found
  end
  
  def correct_owner
    @board = Board.find(params[:id])
    redirect_to(@board) unless current_user.owner?(@board) || current_user.admin?
  rescue ActiveRecord::RecordNotFound
    page_not_found
  end
end
