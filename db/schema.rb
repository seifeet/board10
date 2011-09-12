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

ActiveRecord::Schema.define(:version => 20110909234414) do

  create_table "groups", :force => true do |t|
    t.string   "title",                          :null => false
    t.text     "description"
    t.integer  "view_count",   :default => 0
    t.boolean  "active",       :default => true
    t.integer  "access_level", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "postings", :force => true do |t|
    t.integer  "group_id",                       :null => false
    t.boolean  "active_group", :default => true
    t.integer  "user_id",                        :null => false
    t.boolean  "active_user",  :default => true
    t.integer  "visibility",   :default => 0
    t.string   "subject"
    t.text     "content",                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "access_level", :default => 0
  end

  add_index "postings", ["created_at"], :name => "index_postings_on_created_at"
  add_index "postings", ["group_id"], :name => "index_postings_on_group_id"
  add_index "postings", ["user_id"], :name => "index_postings_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                             :null => false
    t.string   "first_name",      :limit => 150,                    :null => false
    t.string   "last_name",       :limit => 150,                    :null => false
    t.string   "country",         :limit => 150
    t.string   "state",           :limit => 2
    t.string   "city",            :limit => 150
    t.boolean  "admin",                          :default => false
    t.boolean  "active",                         :default => true
    t.integer  "view_count",                     :default => 0
    t.string   "remember_token"
    t.string   "password_digest"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
