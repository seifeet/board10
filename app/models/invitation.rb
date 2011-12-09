class Invitation < ActiveRecord::Base
  validates :token_key, :presence => true
  validates :token_value, :presence => true
  validates :board_id, :presence => true
  
  def create_record(board, email)
    generate_token(:token_value)
    self.token_key = email
    self.board_id = board.id
    save!
  end
  
  private
  
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while Invitation.exists?(column => self[column])
  end
  
end
