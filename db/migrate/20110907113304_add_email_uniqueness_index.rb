class AddEmailUniquenessIndex < ActiveRecord::Migration
  # To avoid creation of duplicated entries because
  # clicking on “Submit” twice, sending two requests in quick succession.
  # An error will appear in the Rails log, but that doesn’t do any harm. 
  # You can actually catch the ActiveRecord::StatementInvalid exception that gets raised.
  def self.up
    add_index :users, :email, :unique => true
  end

  def self.down
    remove_index :users, :email
  end
end
