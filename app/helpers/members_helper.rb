module MembersHelper
  def correct_member
    @member = Member.find(params[:id])
    redirect_to(@member.user_id) unless current_user && (current_user.follower?(@member.board_id) || current_user.admin?)
  rescue ActiveRecord::RecordNotFound
    page_not_found
  end
end
