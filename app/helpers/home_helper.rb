module HomeHelper
    def only_current_user
      redirect_to signin_path if current_user.nil?
    end
    
    def per_page
      5
    end
    
    def max_num_boards
      3
    end
      
    def max_num_schools
      4
    end
end
