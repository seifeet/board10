# Load the rails application
require File.expand_path('../application', __FILE__)

ENV['RECAPTCHA_PUBLIC_KEY']  = '6LcjtcoSAAAAAOVhPZUH3dbEbOSo961BVvIlfgvd'
ENV['RECAPTCHA_PRIVATE_KEY'] = '6LcjtcoSAAAAAKyq7XHSXd4jRKNGu9xu72TG_Q7e'

# Initialize the rails application
Board10::Application.initialize!
