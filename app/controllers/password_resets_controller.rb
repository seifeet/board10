class PasswordResetsController < ApplicationController
  
  def create
    msg = ""
    if !params[:email].nil? && !params[:email].empty?
      user = User.find_by_email(params[:email])
      user.send_password_reset if user
      msg = "Email was sent with password reset instructions."
    else
      msg = "Please provide your email address."
    end
    redirect_to new_password_reset_path, :notice => msg
  end

  def edit
    # method with an exclamation mark so that if the user isn’t found a 404 error is thrown
    @user = User.find_by_password_reset_token!(params[:id])
  end
  
  # in case of errors show action is required
  def show
    # method with an exclamation mark so that if the user isn’t found a 404 error is thrown
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    # method with an exclamation mark so that if the user isn’t found a 404 error is thrown
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :error => "Password reset has expired."
    elsif @user.update_attributes(params[:user])
      if @user.save_without_password
        sign_in @user
        redirect_to home_path, :notice => "Password has been reset!"
      else
        render :edit
      end
    end
  end

end
