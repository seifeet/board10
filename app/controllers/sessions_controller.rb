class SessionsController < ApplicationController
  include ApplicationHelper
  def new
    @title = "Sign in"
    #@level_ups = Vote.level_ups.where('updated_at > ? and created_at > ?',
    #   Time.now.utc - hours_back.hours, Time.now.utc - days_back.days).limit(10)
    @level_ups = Vote.level_ups.limit(200)
  end

  def create
    @recaptcha_test = true
    if params[:recaptcha_challenge_field]
      @failed_user = User.find_by_email(params[:session][:email])
      if @failed_user
        @recaptcha_test = verify_recaptcha(:model => @failed_user, 
          :message => "Please try this challenge again.")
      end
    end

    if @recaptcha_test
      user = User.authenticate(params[:session][:email], params[:session][:password])
    end

    if @recaptcha_test && !user.nil?
      # set login_attampts to zero
      user.update_attribute(:login_attempts, 0)
      sign_in user
      redirect_back_or home_path
    else
      @title = "Sign in"
      flash.now[:error] = "Invalid email/password combination" if @recaptcha_test
      # - Try to find the user by email
      @failed_user = User.find_by_email(params[:session][:email]) unless @failed_user
      # - If exists, increments login_attampts
      if @failed_user
        @failed_user.update_attribute(:login_attempts, @failed_user.login_attempts+1)
        # set @recaptcha = true to open recaptcha dialog
        @recaptcha = true if @failed_user.login_attempts >= 5
      else
        flash.now[:error] = "Invalid email/password combination"
      end

      render 'new'
    end
  end

  def destroy
    flash.now[:success] = "Goodbye!"
    sign_out
    redirect_to signin_path
  end

end
