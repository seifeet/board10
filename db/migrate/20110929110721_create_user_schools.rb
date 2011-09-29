class CreateUserSchools < ActiveRecord::Migration
  def change
    create_table :user_schools do |t|
      t.integer :user_id
      t.integer :school_id

      t.timestamps
    end
    add_index :user_schools, :user_id
    add_index :user_schools, :school_id
    add_index :user_schools, [:user_id, :school_id], :unique => true
  end
end
