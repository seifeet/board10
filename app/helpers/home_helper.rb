module HomeHelper
    def only_current_user
      redirect_to signin_path if current_user.nil?
    end
    
    def per_page
      25
    end
    
    def max_num_boards
      4
    end
      
    def max_num_schools
      3
    end
end
