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
  
  def send_invite(invite, board, user)
    @invite = invite
    @user = user
    @board = board
    # here we have to use bcc; otherwise it takes too long:
    # mail(:to => recipient.email_address_with_name,
    #      :bcc => ["bcc@example.com", "Order Watcher <watcher@example.com>"])
    mail(:to => "#{@invite.token_key}", :subject => "#{@user.full_name} invites you to Boardten")
  end
end
