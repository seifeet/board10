module UsersHelper
  def correct_user
    @user = User.find(params[:id])
    redirect_to(@user) unless current_user?(@user) || current_user.admin?
  rescue ActiveRecord::RecordNotFound
    user_not_found
    end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
