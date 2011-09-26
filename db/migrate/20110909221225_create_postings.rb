class CreatePostings < ActiveRecord::Migration
  def change
    create_table :postings do |t|
      t.integer :board_id, :null => false
      t.boolean :active_board, :default => true
      t.integer :user_id, :null => false
      t.boolean :active_user, :default => true
      t.integer :visibility, :default => 0
      t.string :subject
      t.text :content, :null => false

      t.timestamps
    end
    add_index :postings, :user_id
    add_index :postings, :board_id
    add_index :postings, :created_at
  end
   
  def down
    drop_table :postings
  end
end
