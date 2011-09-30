class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :state, :null => false, :limit => 2
      t.string :city, :null => false, :limit => 150
      t.string :name, :null => false
      t.string :url

      t.timestamps
    end
    add_index :schools, :state
    add_index :schools, :city
    add_index :schools, :name
    add_index :schools, [:state, :city, :name], :unique => true
  end
end
