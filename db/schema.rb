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

ActiveRecord::Schema.define(:version => 20140628130736) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "introdution"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "event_images", :force => true do |t|
    t.string   "event_id"
    t.string   "width"
    t.string   "height"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "event_locations", :force => true do |t|
    t.string   "event_id"
    t.string   "location_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "category_id"
    t.string   "title"
    t.string   "content"
    t.string   "post_time"
    t.string   "user_id"
    t.string   "report_num"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "locations", :force => true do |t|
    t.string   "user_id"
    t.string   "longitude"
    t.string   "latitude"
    t.string   "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.datetime "start_date"
    t.datetime "end_date"
  end

  create_table "meet_groups", :force => true do |t|
    t.string   "senderID"
    t.string   "receiverID"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "meet_locations", :force => true do |t|
    t.string   "location_id"
    t.string   "user_id"
    t.string   "enter_time"
    t.string   "leave_time"
    t.string   "describe"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "my_uuids", :force => true do |t|
    t.string   "UUID"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "report_events", :force => true do |t|
    t.string   "event_id"
    t.string   "user_id"
    t.string   "reason"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "uuid"
    t.string   "major"
    t.string   "minor"
    t.string   "email"
    t.string   "account"
    t.string   "password"
    t.string   "nickname"
    t.string   "sex"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "passport_token"
  end

  create_table "uuids", :force => true do |t|
    t.string   "uuid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
