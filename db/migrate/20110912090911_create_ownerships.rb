class CreateOwnerships < ActiveRecord::Migration
  def change
    create_table :ownerships do |t|
      t.integer :user_id
      t.integer :group_id

      t.timestamps
    end
    add_index :ownerships, :user_id
    add_index :ownerships, :group_id
    add_index :ownerships, [:user_id, :group_id], :unique => true
  end
  
  def self.down
    drop_table :ownerships
  end
end
