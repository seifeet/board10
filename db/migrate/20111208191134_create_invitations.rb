class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :token_key, :null => false
      t.string :token_value, :null => false
      t.integer :board_id, :null => false

      t.timestamps
    end
    add_index :invitations, :token_key
  end
end
