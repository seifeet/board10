class AddAccessLevelToPostings < ActiveRecord::Migration
  def change
    add_column :postings, :access_level, :integer, :default => 0
  end
  
  def down
    remove_column :postings, :access_level
  end
end
