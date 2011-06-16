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

ActiveRecord::Schema.define(:version => 20110616103056) do

  create_table "assets", :force => true do |t|
    t.string   "data_file_name",                                 :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id",                                   :null => false
    t.string   "assetable_type",    :limit => 25,                :null => false
    t.string   "type",              :limit => 25
    t.string   "guid",              :limit => 10
    t.integer  "locale",            :limit => 1,  :default => 0
    t.integer  "user_id"
    t.integer  "sort_order",                      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assets", ["assetable_type", "assetable_id"], :name => "index_assets_on_assetable_type_and_assetable_id"
  add_index "assets", ["assetable_type", "type", "assetable_id"], :name => "index_assets_on_assetable_type_and_type_and_assetable_id"
  add_index "assets", ["user_id"], :name => "index_assets_on_user_id"

  create_table "headers", :force => true do |t|
    t.string   "title"
    t.string   "keywords"
    t.text     "description"
    t.string   "headerable_type", :limit => 30, :null => false
    t.integer  "headerable_id",                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "headers", ["headerable_type", "headerable_id"], :name => "fk_headerable"

  create_table "pages", :force => true do |t|
    t.string   "title",        :null => false
    t.text     "content"
    t.integer  "structure_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["structure_id"], :name => "fk_pages"

  create_table "roles", :force => true do |t|
    t.integer  "role_type",  :limit => 1, :default => 0
    t.integer  "user_id",                                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["user_id"], :name => "fk_user"

  create_table "structures", :force => true do |t|
    t.string   "title",                                        :null => false
    t.string   "slug",         :limit => 25,                   :null => false
    t.integer  "kind",         :limit => 1,  :default => 0
    t.integer  "position",     :limit => 2,  :default => 0
    t.boolean  "is_visible",                 :default => true
    t.string   "redirect_url"
    t.integer  "parent_id"
    t.integer  "lft",                        :default => 0
    t.integer  "rgt",                        :default => 0
    t.integer  "depth",                      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "structures", ["kind", "slug"], :name => "index_structures_on_kind_and_slug"
  add_index "structures", ["lft", "rgt"], :name => "index_structures_on_lft_and_rgt"
  add_index "structures", ["parent_id"], :name => "index_structures_on_parent_id"

  create_table "users", :force => true do |t|
    t.string   "name",                   :limit => 150
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                       :default => 0
    t.datetime "locked_at"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
