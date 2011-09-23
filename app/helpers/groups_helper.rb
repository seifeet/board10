module GroupsHelper
  def correct_group
    @group = Group.find(params[:id])
    redirect_to(@group) unless @group.member?(current_user) || current_user.admin?
  rescue ActiveRecord::RecordNotFound
    page_not_found
  end
  
  def correct_owner
    @group = Group.find(params[:id])
    redirect_to(@group) unless current_user.owner?(@group) || current_user.admin?
  rescue ActiveRecord::RecordNotFound
    page_not_found
  end
end
