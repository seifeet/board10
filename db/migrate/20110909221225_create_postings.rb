class CreatePostings < ActiveRecord::Migration
  def change
    create_table :postings do |t|
      t.integer :group_id, :null => false
      t.boolean :active_group, :default => true
      t.integer :user_id, :null => false
      t.boolean :active_user, :default => true
      t.integer :visibility, :default => 0
      t.string :subject
      t.text :content, :null => false

      t.timestamps
    end
    add_index :postings, :user_id
    add_index :postings, :group_id
    add_index :postings, :created_at
  end
   
  def down
    drop_table :postings
  end
end
