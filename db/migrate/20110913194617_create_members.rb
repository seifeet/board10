class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.integer :user_id
      t.integer :board_id
      t.boolean :owner, :default => false

      t.timestamps
    end
    add_index :members, :user_id
    add_index :members, :board_id
    add_index :members, :owner
    add_index :members, [:user_id, :board_id], :unique => true
  end
  
  def self.down
    drop_table :members
  end
end
