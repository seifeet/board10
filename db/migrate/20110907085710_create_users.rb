class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, :null => false, :uniqueness => true
      t.string :first_name, :null => false, :limit => 150
      t.string :last_name, :null => false, :limit => 150
      t.string :country, :limit => 150
      t.string :state, :limit => 2
      t.string :city, :limit => 150
      t.boolean :admin, :default => false
      t.boolean :active, :default => true
      t.integer :view_count, :default => 0
      t.string :remember_token
      t.string :encrypted_password
      t.string :salt

      t.timestamps
    end
  end
  
  def down
    drop_table :users
  end
end
