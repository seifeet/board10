module UsersHelper
  def correct_user
    @user = User.find(params[:id])
    redirect_to(@user) unless current_user?(@user) || current_user.admin?
  rescue ActiveRecord::RecordNotFound
    page_not_found
    end
end
