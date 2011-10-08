class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  # methods are visible in views and controllers
  helper_method :admin?
    
  def admin?
    current_user.admin?
  end
  
  private
  
  #def current_user
  #  @current_user ||= User.find(session[:user_id]) if session[:user_id]
  #end
  #helper_method :current_user
end
