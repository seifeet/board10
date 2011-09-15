class AddViewCountToPostings < ActiveRecord::Migration
  def self.up
    add_column :postings, :view_count, :integer, :default => 0
  end
  
  def self.down
    remove_column :postings, :view_count
  end
end
