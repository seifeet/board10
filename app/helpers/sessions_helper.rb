module SessionsHelper
  def page_not_found
      # etu hren' nado meniat'!
      #flash[:success] = "Profile Unavailable"
      redirect_to '/404.html'
  end
  
  def check element, str
    element.errors.full_messages.each do |msg|
      if msg =~ /#{str}/ 
        return msg
      end
    end
    nil
  end
    
  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    flash[:info] = "Please sign in in order to access this page."
    redirect_to signin_path
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_in(user)
    if params[:remeber_me]
      cookies.permanent[:remember_token] = user.remember_token
    else
      cookies[:remember_token] = user.remember_token
    end
    self.current_user = user
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token]) unless cookies[:remember_token].nil?
    # user_from_remember_token
  end

  def redirect_back_or(default)
    redirect_to(stored_location_or_home || default)
    clear_return_to
  end

  private

  #def user_from_remember_token
  #  User.authenticate_with_salt(*remember_token)
  #end

  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end

  def store_location
    stored_location_or_home = request.fullpath
  end

  def clear_return_to
    stored_location_or_home = nil
  end
end
