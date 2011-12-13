module UserSchoolsHelper
  def user_school
    @user_school = UserSchool.find(params[:id])
    redirect_to(@user_school.user_id) unless current_user && (current_user.has_school?(@user_school.school_id) || current_user.admin?)
  rescue ActiveRecord::RecordNotFound
    page_not_found
  end
end
