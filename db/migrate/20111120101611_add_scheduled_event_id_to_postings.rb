class AddScheduledEventIdToPostings < ActiveRecord::Migration
  def change
    add_column :postings, :scheduled_event_id, :integer
  end
end
