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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160416101356) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",                   default: "owner"
    t.string   "name"
    t.string   "phone"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "advertising_events", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "slug"
    t.string   "home_page_background"
    t.string   "win_page_background"
    t.float    "winning_rate"
    t.integer  "maximum_number_of_winners"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.datetime "end_at"
    t.datetime "begin_at"
    t.string   "url"
    t.boolean  "enabled",                   default: true
    t.text     "reference_link_1"
    t.text     "reference_link_2"
    t.integer  "user_id"
  end

  add_index "advertising_events", ["slug"], name: "index_advertising_events_on_slug", using: :btree
  add_index "advertising_events", ["user_id"], name: "index_advertising_events_on_user_id", using: :btree

  create_table "albums", force: :cascade do |t|
    t.string  "name"
    t.integer "position"
  end

  create_table "areas", force: :cascade do |t|
    t.integer "city_id"
    t.integer "district_id"
    t.string  "alias"
    t.string  "name"
    t.integer "position"
  end

  add_index "areas", ["city_id"], name: "index_areas_on_city_id", using: :btree
  add_index "areas", ["district_id"], name: "index_areas_on_district_id", using: :btree

  create_table "authentication_tokens", force: :cascade do |t|
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "authentication_tokens", ["user_id"], name: "index_authentication_tokens_on_user_id", using: :btree

  create_table "cities", force: :cascade do |t|
    t.string  "alias"
    t.string  "name"
    t.integer "position"
  end

  create_table "client_applications", force: :cascade do |t|
    t.string   "name"
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "rate"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "commenter_id"
    t.string   "commenter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["commenter_id"], name: "index_comments_on_commenter_id", using: :btree
  add_index "comments", ["commenter_type"], name: "index_comments_on_commenter_type", using: :btree

  create_table "coupon_invitations", force: :cascade do |t|
    t.integer  "inviter_id"
    t.integer  "invitee_id"
    t.integer  "coupon_id"
    t.integer  "status",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "coupon_invitations", ["coupon_id"], name: "index_coupon_invitations_on_coupon_id", using: :btree
  add_index "coupon_invitations", ["invitee_id"], name: "index_coupon_invitations_on_invitee_id", using: :btree
  add_index "coupon_invitations", ["inviter_id"], name: "index_coupon_invitations_on_inviter_id", using: :btree

  create_table "coupons", force: :cascade do |t|
    t.string   "image"
    t.text     "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "required_minimum_invitees", default: 2
    t.string   "code"
    t.string   "short_description"
    t.integer  "quantity",                  default: 10
    t.integer  "priority",                  default: 0
    t.string   "cash_discount",             default: "0"
    t.string   "bill_discount",             default: "0"
    t.string   "food_discount"
    t.integer  "restaurant_id"
    t.integer  "impressions_count",         default: 0
    t.integer  "number_of_free_volka",      default: 0
  end

  create_table "devices", force: :cascade do |t|
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_agent", default: 0
  end

  add_index "devices", ["token"], name: "index_devices_on_token", using: :btree
  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "districts", force: :cascade do |t|
    t.integer "city_id"
    t.string  "alias"
    t.string  "name"
    t.integer "position"
  end

  create_table "facebook_assests", force: :cascade do |t|
    t.integer  "venue_id"
    t.string   "information"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "facebook_assests", ["venue_id"], name: "index_facebook_assests_on_venue_id", using: :btree

  create_table "facebook_fanpages", force: :cascade do |t|
    t.string   "name"
    t.integer  "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "facebook_photos", force: :cascade do |t|
    t.string   "url"
    t.integer  "venue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "follows", force: :cascade do |t|
    t.integer  "followable_id",                   null: false
    t.string   "followable_type",                 null: false
    t.integer  "follower_id",                     null: false
    t.string   "follower_type",                   null: false
    t.boolean  "blocked",         default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables", using: :btree
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows", using: :btree

  create_table "foody_comments", force: :cascade do |t|
    t.integer "restaurant_id"
    t.integer "user_id"
    t.string  "user_name"
    t.string  "user_avatar"
    t.string  "title"
    t.string  "message"
    t.integer "time"
  end

  create_table "foody_images", force: :cascade do |t|
    t.integer "restaurant_id"
    t.integer "album_id"
    t.string  "url"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "google_place_images", force: :cascade do |t|
    t.string   "url"
    t.integer  "venue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "google_place_images", ["venue_id"], name: "index_google_place_images_on_venue_id", using: :btree

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "uid"
    t.string   "access_token"
    t.string   "access_token_secret"
    t.string   "type"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "user_type",           default: "User"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "content"
    t.integer  "object_id"
    t.string   "object_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "menu_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menu_components", force: :cascade do |t|
    t.string   "content"
    t.integer  "menu_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menus", force: :cascade do |t|
    t.string   "name"
    t.integer  "price"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "image"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "menu_category_id"
  end

  create_table "partners", force: :cascade do |t|
    t.string   "name"
    t.text     "url"
    t.string   "image"
    t.boolean  "active",     default: true
    t.integer  "order"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "rails_push_notifications_apns_apps", force: :cascade do |t|
    t.text     "apns_dev_cert"
    t.text     "apns_prod_cert"
    t.boolean  "sandbox_mode"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "rails_push_notifications_gcm_apps", force: :cascade do |t|
    t.string   "gcm_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rails_push_notifications_mpns_apps", force: :cascade do |t|
    t.text     "cert"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rails_push_notifications_notifications", force: :cascade do |t|
    t.text     "destinations"
    t.integer  "app_id"
    t.string   "app_type"
    t.text     "data"
    t.text     "results"
    t.integer  "success"
    t.integer  "failed"
    t.boolean  "sent",         default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "rails_push_notifications_notifications", ["app_id", "app_type", "sent"], name: "app_and_sent_index_on_rails_push_notifications", using: :btree

  create_table "restaurant_categories", force: :cascade do |t|
    t.string  "alias"
    t.string  "name"
    t.integer "position"
    t.string  "image"
  end

  create_table "restaurant_wait_list_reviews", force: :cascade do |t|
    t.integer  "restaurant_id"
    t.integer  "facebook_fanpage_id"
    t.integer  "status",              default: 0
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "restaurants", force: :cascade do |t|
    t.integer "city_id"
    t.integer "district_id"
    t.integer "area_id"
    t.integer "restaurant_category_id"
    t.string  "alias"
    t.string  "name"
    t.string  "address"
    t.string  "image"
    t.string  "phone"
    t.float   "lat"
    t.float   "lon"
    t.integer "fd_id"
    t.integer "complete"
    t.boolean "should_reserve_table"
    t.boolean "delivery"
    t.boolean "bring_home"
    t.boolean "has_wifi"
    t.boolean "has_kid_zone"
    t.boolean "has_table_outside"
    t.boolean "has_private_room"
    t.boolean "has_air_conditioner"
    t.boolean "has_scard_payment"
    t.boolean "has_karaoke"
    t.boolean "has_free_motobike_parking"
    t.boolean "give_tip"
    t.boolean "has_car_parking"
    t.boolean "has_smoking_area"
    t.boolean "has_member_card"
    t.boolean "has_offical_receipt"
    t.boolean "has_reference_support"
    t.boolean "has_heater"
    t.boolean "has_disable_support"
    t.boolean "has_football_screen"
    t.boolean "has_live_music"
    t.text    "description"
    t.string  "price_range"
    t.string  "food_menu"
    t.string  "open_at"
    t.string  "close_at"
    t.integer "average_menu_price"
    t.string  "food_style"
    t.string  "using_purpose"
    t.integer "capacity"
    t.string  "suitable_time"
    t.string  "extra_fee"
    t.string  "time_to_book_a_table"
    t.string  "website"
    t.string  "facebook_url"
    t.integer "owner_id"
    t.string  "owner_type"
    t.string  "profile_image"
  end

  add_index "restaurants", ["area_id"], name: "index_restaurants_on_area_id", using: :btree
  add_index "restaurants", ["city_id"], name: "index_restaurants_on_city_id", using: :btree
  add_index "restaurants", ["district_id"], name: "index_restaurants_on_district_id", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.string   "text"
    t.integer  "venue_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "rating"
    t.string   "author_name"
  end

  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id", using: :btree
  add_index "reviews", ["venue_id"], name: "index_reviews_on_venue_id", using: :btree

  create_table "server_configurations", force: :cascade do |t|
    t.string   "value"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_advertising_events", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "lucky_code"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "advertising_event_id"
  end

  add_index "user_advertising_events", ["advertising_event_id"], name: "index_user_advertising_events_on_advertising_event_id", using: :btree
  add_index "user_advertising_events", ["user_id"], name: "index_user_advertising_events_on_user_id", using: :btree

  create_table "user_coupons", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "coupon_id"
    t.integer  "status",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "token"
    t.string   "Code"
  end

  add_index "user_coupons", ["coupon_id"], name: "index_user_coupons_on_coupon_id", using: :btree
  add_index "user_coupons", ["user_id"], name: "index_user_coupons_on_user_id", using: :btree

  create_table "user_vouchers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "coupon_id"
    t.integer  "status"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_vouchers", ["coupon_id"], name: "index_user_vouchers_on_coupon_id", using: :btree
  add_index "user_vouchers", ["user_id"], name: "index_user_vouchers_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "avatar"
    t.string   "verification_token"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "unverified_email"
    t.string   "email_verification_token"
    t.text     "facebook_token"
    t.integer  "facebook_token_expiration"
    t.text     "facebook_image_url"
    t.string   "age_range"
    t.string   "location"
  end

  add_index "users", ["phone"], name: "index_users_on_phone", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "venues", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.float    "longitude"
    t.float    "latitude"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "full_address"
    t.string   "google_place_id"
    t.text     "google_place_reference"
    t.boolean  "crawled?",               default: false
    t.integer  "admin_id"
    t.text     "opening_hours"
    t.text     "website"
    t.string   "formatted_phone_number"
  end

  add_index "venues", ["admin_id"], name: "index_venues_on_admin_id", using: :btree

  add_foreign_key "advertising_events", "admins", column: "user_id", on_delete: :cascade
  add_foreign_key "authentication_tokens", "users"
  add_foreign_key "coupon_invitations", "coupons"
  add_foreign_key "coupons", "restaurants"
  add_foreign_key "devices", "users"
  add_foreign_key "user_coupons", "coupons"
  add_foreign_key "user_coupons", "users"
  add_foreign_key "user_vouchers", "coupons"
  add_foreign_key "user_vouchers", "users"
end
