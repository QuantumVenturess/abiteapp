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

ActiveRecord::Schema.define(:version => 20130510163627) do

  create_table "completion_marks", :force => true do |t|
    t.integer  "table_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "completion_marks", ["table_id", "user_id"], :name => "index_completion_marks_on_table_id_and_user_id", :unique => true

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "messages", :force => true do |t|
    t.text     "content"
    t.integer  "room_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "messages", ["room_id"], :name => "index_messages_on_room_id"
  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "notifications", :force => true do |t|
    t.integer  "seat_id"
    t.integer  "table_id"
    t.integer  "user_id"
    t.boolean  "viewed",     :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "message_id"
  end

  add_index "notifications", ["message_id"], :name => "index_notifications_on_message_id"
  add_index "notifications", ["seat_id"], :name => "index_notifications_on_seat_id"
  add_index "notifications", ["table_id"], :name => "index_notifications_on_table_id"
  add_index "notifications", ["user_id"], :name => "index_notifications_on_user_id"
  add_index "notifications", ["viewed"], :name => "index_notifications_on_viewed"

  create_table "places", :force => true do |t|
    t.string   "address"
    t.string   "city"
    t.string   "image_url"
    t.string   "name"
    t.string   "phone"
    t.integer  "postal_code"
    t.string   "slug"
    t.string   "state_code"
    t.string   "yelp_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.float    "latitude",     :default => 0.0
    t.float    "longitude",    :default => 0.0
    t.float    "rating",       :default => 0.0
    t.integer  "review_count", :default => 0
  end

  add_index "places", ["address"], :name => "index_places_on_address"
  add_index "places", ["city"], :name => "index_places_on_city"
  add_index "places", ["latitude"], :name => "index_places_on_latitude"
  add_index "places", ["longitude"], :name => "index_places_on_longitude"
  add_index "places", ["name"], :name => "index_places_on_name"
  add_index "places", ["phone"], :name => "index_places_on_phone"
  add_index "places", ["postal_code"], :name => "index_places_on_postal_code"
  add_index "places", ["rating"], :name => "index_places_on_rating"
  add_index "places", ["review_count"], :name => "index_places_on_review_count"
  add_index "places", ["slug"], :name => "index_places_on_slug", :unique => true
  add_index "places", ["state_code"], :name => "index_places_on_state_code"
  add_index "places", ["yelp_id"], :name => "index_places_on_yelp_id", :unique => true

  create_table "rooms", :force => true do |t|
    t.boolean  "closed",     :default => false
    t.integer  "table_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "rooms", ["closed"], :name => "index_rooms_on_closed"
  add_index "rooms", ["table_id"], :name => "index_rooms_on_table_id", :unique => true

  create_table "seats", :force => true do |t|
    t.integer  "table_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "seats", ["table_id", "user_id"], :name => "index_seats_on_table_id_and_user_id", :unique => true

  create_table "tables", :force => true do |t|
    t.datetime "date_ready"
    t.integer  "max_seats"
    t.integer  "place_id"
    t.boolean  "ready",         :default => false
    t.integer  "user_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.boolean  "complete",      :default => false
    t.datetime "date_complete"
  end

  add_index "tables", ["date_complete"], :name => "index_tables_on_date_complete"
  add_index "tables", ["date_ready"], :name => "index_tables_on_date_ready"
  add_index "tables", ["max_seats"], :name => "index_tables_on_max_seats"
  add_index "tables", ["place_id"], :name => "index_tables_on_place_id"
  add_index "tables", ["ready"], :name => "index_tables_on_ready"
  add_index "tables", ["user_id"], :name => "index_tables_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "access_token"
    t.boolean  "admin",                           :default => false
    t.string   "email"
    t.string   "encrypted_password"
    t.integer  "facebook_id",        :limit => 8
    t.string   "first_name"
    t.string   "image"
    t.integer  "in_count",                        :default => 0
    t.datetime "last_in"
    t.string   "last_name"
    t.string   "location"
    t.string   "name"
    t.string   "salt"
    t.string   "slug"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
  end

  add_index "users", ["access_token"], :name => "index_users_on_access_token"
  add_index "users", ["admin"], :name => "index_users_on_admin"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["facebook_id"], :name => "index_users_on_facebook_id", :unique => true
  add_index "users", ["first_name"], :name => "index_users_on_first_name"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"
  add_index "users", ["location"], :name => "index_users_on_location"
  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["salt"], :name => "index_users_on_salt"
  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true

end
