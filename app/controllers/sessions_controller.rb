class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:session][:email], 
                             params[:session][:password])
    if !user.nil?
      sign_in user
      redirect_back_or user
    else
      # commented part is for activating inactive user 
      # user = User.unscoped.where(:active => false).authenticate(params[:session][:email], params[:session][:password])
      if user.nil?
        flash.now[:error] = "Invalid email/password combination."
        @title = "Sign in"
        render 'new'
      end
    end
  end

  def destroy
    flash.now[:success] = "Goodbye!"
    sign_out
    redirect_to signin_path
  end

end
