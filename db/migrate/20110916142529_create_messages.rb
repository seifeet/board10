class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :from_user, :null => false
      t.integer :to_user, :null => false
      t.string :subject
      t.text :content, :null => false
      t.integer :msg_type, :null => false
      t.integer :msg_state, :null => false

      t.timestamps
    end
  end
  
  def down
    drop_table :messages
  end 
end
