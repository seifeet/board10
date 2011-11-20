class CreateScheduledEvents < ActiveRecord::Migration
  def change
    create_table :scheduled_events do |t|
      t.integer :posting_id, :null => false
      t.date :next_event_date, :null => false
      t.time :next_event_time, :null => false
      t.date :start_date, :null => false
      t.date :end_date, :null => false
      t.time :start_time, :null => false
      t.time :end_time, :null => false
      t.integer :repeat, :null => false
      t.boolean :mo
      t.boolean :tu
      t.boolean :we
      t.boolean :th
      t.boolean :fr
      t.boolean :sa
      t.boolean :su
      t.boolean :month_end
      t.integer :month
      t.integer :month_day

      t.timestamps
    end
  end
end
