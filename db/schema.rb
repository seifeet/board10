# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111201171911) do

  create_table "boards", :force => true do |t|
    t.string   "title",                          :null => false
    t.text     "description"
    t.integer  "view_count",   :default => 0
    t.boolean  "active",       :default => true
    t.integer  "access_level", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  create_table "members", :force => true do |t|
    t.integer  "user_id"
    t.integer  "board_id"
    t.integer  "member_type", :default => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "members", ["board_id"], :name => "index_members_on_board_id"
  add_index "members", ["member_type"], :name => "index_members_on_member_type"
  add_index "members", ["user_id", "board_id"], :name => "index_members_on_user_id_and_board_id", :unique => true
  add_index "members", ["user_id"], :name => "index_members_on_user_id"

  create_table "messages", :force => true do |t|
    t.integer  "from_user",  :null => false
    t.integer  "to_user",    :null => false
    t.string   "subject"
    t.text     "content",    :null => false
    t.integer  "msg_type",   :null => false
    t.integer  "msg_state",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "board_id"
  end

  create_table "postings", :force => true do |t|
    t.integer  "board_id",                             :null => false
    t.boolean  "active_board",       :default => true
    t.integer  "user_id",                              :null => false
    t.boolean  "active_user",        :default => true
    t.integer  "visibility",         :default => 0
    t.string   "subject"
    t.text     "content",                              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "access_level",       :default => 0
    t.integer  "view_count",         :default => 0
    t.integer  "scheduled_event_id"
    t.integer  "original_posting"
  end

  add_index "postings", ["board_id"], :name => "index_postings_on_board_id"
  add_index "postings", ["created_at"], :name => "index_postings_on_created_at"
  add_index "postings", ["original_posting"], :name => "index_postings_on_original_posting"
  add_index "postings", ["user_id"], :name => "index_postings_on_user_id"

  create_table "scheduled_events", :force => true do |t|
    t.integer  "posting_id",                    :null => false
    t.date     "next_event",                    :null => false
    t.date     "start_date",                    :null => false
    t.date     "end_date",                      :null => false
    t.time     "start_time",                    :null => false
    t.time     "end_time",                      :null => false
    t.integer  "repeat",                        :null => false
    t.boolean  "mo",         :default => false
    t.boolean  "tu",         :default => false
    t.boolean  "we",         :default => false
    t.boolean  "th",         :default => false
    t.boolean  "fr",         :default => false
    t.boolean  "sa",         :default => false
    t.boolean  "su",         :default => false
    t.boolean  "month_end"
    t.integer  "month"
    t.integer  "month_day"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scheduled_events", ["end_date"], :name => "index_scheduled_events_on_end_date"
  add_index "scheduled_events", ["next_event"], :name => "index_scheduled_events_on_next_event"
  add_index "scheduled_events", ["posting_id"], :name => "index_scheduled_events_on_posting_id"

  create_table "schools", :force => true do |t|
    t.string   "state",      :limit => 2,   :null => false
    t.string   "city",       :limit => 150, :null => false
    t.string   "name",                      :null => false
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schools", ["city"], :name => "index_schools_on_city"
  add_index "schools", ["name"], :name => "index_schools_on_name"
  add_index "schools", ["state", "city", "name", "url"], :name => "index_schools_on_state_and_city_and_name_and_url", :unique => true
  add_index "schools", ["state"], :name => "index_schools_on_state"

  create_table "user_schools", :force => true do |t|
    t.integer  "user_id"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_schools", ["school_id"], :name => "index_user_schools_on_school_id"
  add_index "user_schools", ["user_id", "school_id"], :name => "index_user_schools_on_user_id_and_school_id", :unique => true
  add_index "user_schools", ["user_id"], :name => "index_user_schools_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                                    :null => false
    t.string   "first_name",             :limit => 150,                    :null => false
    t.string   "last_name",              :limit => 150,                    :null => false
    t.string   "country",                :limit => 150
    t.string   "state",                  :limit => 2
    t.string   "city",                   :limit => 150
    t.boolean  "admin",                                 :default => false
    t.boolean  "active",                                :default => true
    t.integer  "view_count",                            :default => 0
    t.string   "remember_token"
    t.string   "password_digest"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.integer  "login_attempts",                        :default => 0
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "obj_type"
    t.integer  "obj_id"
    t.boolean  "vote",       :default => true
    t.boolean  "level_up",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["obj_id"], :name => "index_votes_on_obj_id"
  add_index "votes", ["obj_type"], :name => "index_votes_on_obj_type"
  add_index "votes", ["updated_at", "level_up"], :name => "index_votes_on_updated_at_and_level_up"
  add_index "votes", ["user_id", "obj_type", "obj_id"], :name => "index_votes_on_user_id_and_obj_type_and_obj_id", :unique => true
  add_index "votes", ["user_id"], :name => "index_votes_on_user_id"

end
