class SessionsController < ApplicationController
  include ApplicationHelper
  def new
    @title = "Sign in"
    #@level_ups = Vote.level_ups.where('updated_at > ? and created_at > ?',
    #   Time.now.utc - hours_back.hours, Time.now.utc - days_back.days).limit(10)
    @level_ups = Vote.level_ups.limit(200)
  end

  def create
    user = User.authenticate(params[:session][:email], 
                               params[:session][:password])
    if !user.nil?
      sign_in user
      redirect_back_or home_path
    else
      @title = "Sign in"
      @recaptcha = true
      flash.now[:error] = "Invalid email/password combination"
      render 'new'
    end
    #if verify_recaptcha(:model => user, :message => "Verification code is wrong.")
      
      
    #else
    #  @title = "Sign in"
    #  render 'new'
    #end
  end

  def destroy
    flash.now[:success] = "Goodbye!"
    sign_out
    redirect_to signin_path
  end

end
