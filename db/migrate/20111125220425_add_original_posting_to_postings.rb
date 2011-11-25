class AddOriginalPostingToPostings < ActiveRecord::Migration
  def change
    add_column :postings, :original_posting, :integer
    add_index :postings, :original_posting
  end
end
