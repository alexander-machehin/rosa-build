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

ActiveRecord::Schema.define(:version => 20111019173246) do

  create_table "arches", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "arches", ["name"], :name => "index_arches_on_name", :unique => true

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["provider", "uid"], :name => "index_authentications_on_provider_and_uid", :unique => true
  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "build_list_items", :force => true do |t|
    t.string   "name"
    t.integer  "level"
    t.integer  "status"
    t.integer  "build_list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "build_list_items", ["build_list_id"], :name => "index_build_list_items_on_build_list_id"

  create_table "build_lists", :force => true do |t|
    t.integer  "bs_id"
    t.string   "container_path"
    t.integer  "status"
    t.string   "branch_name"
    t.integer  "project_id"
    t.integer  "arch_id"
    t.datetime "notified_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_circle",        :default => false
    t.text     "additional_repos"
    t.string   "name"
  end

  add_index "build_lists", ["arch_id"], :name => "index_build_lists_on_arch_id"
  add_index "build_lists", ["bs_id"], :name => "index_build_lists_on_bs_id", :unique => true
  add_index "build_lists", ["project_id"], :name => "index_build_lists_on_project_id"

  create_table "containers", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "project_id", :null => false
    t.integer  "owner_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "downloads", :force => true do |t|
    t.string   "name",                      :null => false
    t.string   "version"
    t.string   "distro"
    t.string   "platform"
    t.integer  "counter",    :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_logs", :force => true do |t|
    t.integer  "user_id"
    t.string   "user_name"
    t.integer  "object_id"
    t.string   "object_type"
    t.string   "object_name"
    t.string   "ip"
    t.string   "kind"
    t.string   "protocol"
    t.string   "controller"
    t.string   "action"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uname"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "right_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "platforms", :force => true do |t|
    t.string   "name"
    t.string   "unixname"
    t.integer  "parent_platform_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "released",           :default => false
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "visibility",         :default => "open"
    t.string   "platform_type",      :default => "main"
    t.string   "distrib_type"
  end

  create_table "private_users", :force => true do |t|
    t.integer  "platform_id"
    t.string   "login"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "name",                                :null => false
    t.integer  "platform_id",                         :null => false
    t.integer  "build_status",     :default => 2,     :null => false
    t.string   "build_path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "build"
    t.text     "counter"
    t.text     "ks"
    t.text     "menu"
    t.string   "tar_file_name"
    t.string   "tar_content_type"
    t.integer  "tar_file_size"
    t.datetime "tar_updated_at"
    t.boolean  "is_template",      :default => false
    t.boolean  "system_wide",      :default => false
    t.text     "cron_tab"
    t.boolean  "use_cron",         :default => false
  end

  create_table "project_to_repositories", :force => true do |t|
    t.integer  "project_id"
    t.integer  "repository_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "unixname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "visibility", :default => "open"
  end

  create_table "relations", :force => true do |t|
    t.integer  "object_id"
    t.string   "object_type"
    t.integer  "target_id"
    t.string   "target_type"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "repositories", :force => true do |t|
    t.string   "name",                            :null => false
    t.integer  "platform_id",                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unixname",                        :null => false
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "visibility",  :default => "open"
  end

  create_table "rights", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "role_lines", :force => true do |t|
    t.integer  "role_id"
    t.integer  "relation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "to"
    t.string   "on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rpms", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "arch_id",    :null => false
    t.integer  "project_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rpms", ["project_id", "arch_id"], :name => "index_rpms_on_project_id_and_arch_id"
  add_index "rpms", ["project_id"], :name => "index_rpms_on_project_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uname"
    t.string   "nickname"
    t.text     "ssh_key"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["nickname"], :name => "index_users_on_nickname", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
