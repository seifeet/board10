class AddGroupIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :group_id, :integer
  end
  
  def down
    remove_column :messages, :group_id
  end
end
