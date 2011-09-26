class AddBoardIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :board_id, :integer
  end
  
  def down
    remove_column :messages, :board_id
  end
end
