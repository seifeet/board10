module MessagesHelper
  def message_owner
    @message = Message.find(params[:id])
    redirect_to home_path unless current_user && ( current_user.id == @message.from_user || current_user.id == @message.to_user || current_user.admin? )
  rescue ActiveRecord::RecordNotFound
    page_not_found
  end
end
