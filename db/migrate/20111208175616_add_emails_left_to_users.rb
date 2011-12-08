class AddEmailsLeftToUsers < ActiveRecord::Migration
  def change
    add_column :users, :emails_left, :integer, :default => 50
  end
end
