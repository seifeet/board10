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
  
  def validate_emails user_emails
    email_results = Hash.new
    if user_emails && !user_emails.blank?
      # substitute not allowed chars with space
      results = user_emails.gsub(/[^a-zA-Z 0-9@\!\#\$\%\&\'\*\+\-\/\=\?\^\_\`\{\|\}\~\.\"]+/,' ').split
      if results
        email_results = Hash.new
        for email in results do
          email_results[email] = ( email =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/ ? "&radic;" : "x" )
        end
      end
    end
    email_results
  end
end
