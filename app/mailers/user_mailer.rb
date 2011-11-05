class UserMailer < ActionMailer::Base
  default from: "myotherneeds@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail(:to => "#{user.full_name} <#{user.email}>", :subject => "Boardten: Password Reset")
  end
  
  def registration_confirmation(user)
    @user = user # to pass @user variable to the body of the email
    #attachments["laoding.gif"] = File.read("#{Rails.root}/public/images/loading.gif")
    mail(:to => "#{user.full_name} <#{user.email}>", :subject => "Boardten: Your Registeration Confirmation")
  end
end
