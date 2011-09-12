class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :title, :null => false
      t.text :description
      t.integer :view_count, :default => 0
      t.boolean :active, :default => true
      t.integer :access_level, :default => 0

      t.timestamps
    end
  end
  
  def down
    drop_table :groups
  end
end
