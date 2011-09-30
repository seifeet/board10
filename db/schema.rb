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

ActiveRecord::Schema.define(:version => 20110929201405) do

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
    t.boolean  "owner",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "members", ["board_id"], :name => "index_members_on_board_id"
  add_index "members", ["owner"], :name => "index_members_on_owner"
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
    t.integer  "board_id",                       :null => false
    t.boolean  "active_board", :default => true
    t.integer  "user_id",                        :null => false
    t.boolean  "active_user",  :default => true
    t.integer  "visibility",   :default => 0
    t.string   "subject"
    t.text     "content",                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "access_level", :default => 0
    t.integer  "view_count",   :default => 0
  end

  add_index "postings", ["board_id"], :name => "index_postings_on_board_id"
  add_index "postings", ["created_at"], :name => "index_postings_on_created_at"
  add_index "postings", ["user_id"], :name => "index_postings_on_user_id"

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
  add_index "schools", ["state", "city", "name"], :name => "index_schools_on_state_and_city_and_name", :unique => true
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
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
