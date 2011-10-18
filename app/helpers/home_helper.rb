module HomeHelper
    def only_current_user
      redirect_to signin_path if current_user.nil?
    end
    
    def per_page
      5
    end
end
