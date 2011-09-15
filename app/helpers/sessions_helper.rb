module SessionsHelper
  def page_not_found
      # etu hren' nado meniat'!
      #flash[:success] = "Profile Unavailable"
      redirect_to '/404.html'
  end
    
  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
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
    # ||= sets the @current_user instance variable to the user corresponding
    # to the remember token, but only if @current_user is undefined.
    # In other words, calls the user_from_remember_token method the first time current_user is called,
    # but on subsequent invocations returns @current_user without calling user_from_remember_token.
    # This optimization technique to avoid repeated function calls is known as memoization.
    @current_user ||= user_from_remember_token
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  private

  def user_from_remember_token
    User.authenticate_with_salt(*remember_token)
  end

  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_return_to
    session[:return_to] = nil
  end
end
