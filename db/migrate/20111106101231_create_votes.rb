class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :user_id
      t.integer :obj_type
      t.integer :obj_id
      t.boolean :vote, :default => true
      t.boolean :level_up, :default => false

      t.timestamps
    end
    add_index :votes, :user_id
    add_index :votes, :obj_type
    add_index :votes, :obj_id
    add_index :votes, [:user_id, :obj_type, :obj_id], :unique => true
    add_index :votes, [:updated_at, :level_up]
  end
end
