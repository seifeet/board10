class CreateScheduledEvents < ActiveRecord::Migration
  def change
    create_table :scheduled_events do |t|
      t.integer :posting_id, :null => false
      t.date :next_event, :null => false
      t.date :start_date, :null => false
      t.date :end_date, :null => false
      t.time :start_time, :null => false
      t.time :end_time, :null => false
      t.integer :repeat, :null => false
      t.boolean :mo, :default => false
      t.boolean :tu, :default => false
      t.boolean :we, :default => false
      t.boolean :th, :default => false
      t.boolean :fr, :default => false
      t.boolean :sa, :default => false
      t.boolean :su, :default => false
      t.boolean :month_end
      t.integer :month
      t.integer :month_day

      t.timestamps
    end
    add_index :scheduled_events, :posting_id
    add_index :scheduled_events, :next_event
    add_index :scheduled_events, :end_date
  end
end
