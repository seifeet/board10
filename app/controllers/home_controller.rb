class HomeController < ApplicationController
  include UsersHelper
  def index
    store_location

    @user = current_user
    
  end

end
