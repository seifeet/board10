class SessionsController < ApplicationController
  def new
    @title = "Sign in"
    @level_ups = Vote.level_ups.where('updated_at > ?', Time.now.utc - 5.hours).limit(10)
  end

  def create
    user = User.authenticate(params[:session][:email], 
                             params[:session][:password])
    if !user.nil?
      sign_in user
      redirect_back_or home_path
    else
      @title = "Sign in"
      flash.now[:error] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    flash.now[:success] = "Goodbye!"
    sign_out
    redirect_to signin_path
  end

end
