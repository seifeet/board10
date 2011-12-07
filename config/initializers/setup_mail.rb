ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "localhost:3000",
  :user_name            => "myotherneeds@gmail.com",
  :password             => "Mypass_19",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

# for link tags inside an email body
ActionMailer::Base.default_url_options[:host] = "localhost:3000"

ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
