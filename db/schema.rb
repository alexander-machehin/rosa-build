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

ActiveRecord::Schema.define(version: 20140709194335) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email",                   default: "",   null: false
    t.string   "encrypted_password",      default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "ssh_key"
    t.string   "uname"
    t.string   "role"
    t.string   "language",                default: "en"
    t.integer  "own_projects_count",      default: 0,    null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.text     "professional_experience"
    t.string   "site"
    t.string   "company"
    t.string   "location"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "failed_attempts",         default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.integer  "build_priority",          default: 50
    t.boolean  "sound_notifications",     default: true
    t.boolean  "hide_email",              default: true, null: false
    t.index ["authentication_token"], :name => "index_users_on_authentication_token"
    t.index ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
    t.index ["email"], :name => "index_users_on_email", :unique => true
    t.index ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
    t.index ["uname"], :name => "index_users_on_uname", :unique => true
    t.index ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true
  end

  create_table "activity_feeds", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "kind"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id", "kind"], :name => "index_activity_feeds_on_user_id_and_kind"
    t.index ["user_id"], :name => "fk__activity_feeds_user_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_activity_feeds_user_id"
  end

  create_table "advisories", force: true do |t|
    t.string   "advisory_id"
    t.text     "description", default: ""
    t.text     "references",  default: ""
    t.text     "update_type", default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["advisory_id"], :name => "index_advisories_on_advisory_id", :unique => true
    t.index ["update_type"], :name => "index_advisories_on_update_type"
  end

  create_table "platforms", force: true do |t|
    t.string   "description"
    t.string   "name",                                             null: false
    t.integer  "parent_platform_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "released",                        default: false,  null: false
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "visibility",                      default: "open", null: false
    t.string   "platform_type",                   default: "main", null: false
    t.string   "distrib_type"
    t.integer  "status"
    t.datetime "last_regenerated_at"
    t.integer  "last_regenerated_status"
    t.string   "last_regenerated_log_sha1"
    t.string   "automatic_metadata_regeneration"
    t.index ["name"], :name => "index_platforms_on_name", :unique => true, :case_sensitive => false
  end

  create_table "advisories_platforms", id: false, force: true do |t|
    t.integer "advisory_id"
    t.integer "platform_id"
    t.index ["advisory_id", "platform_id"], :name => "advisory_platform_index", :unique => true
    t.index ["advisory_id"], :name => "fk__advisories_platforms_advisory_id"
    t.index ["advisory_id"], :name => "index_advisories_platforms_on_advisory_id"
    t.index ["platform_id"], :name => "fk__advisories_platforms_platform_id"
    t.index ["platform_id"], :name => "index_advisories_platforms_on_platform_id"
    t.foreign_key ["advisory_id"], "advisories", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_advisories_platforms_advisory_id"
    t.foreign_key ["platform_id"], "platforms", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_advisories_platforms_platform_id"
  end

  create_table "projects", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "visibility",               default: "open"
    t.text     "description"
    t.string   "ancestry"
    t.boolean  "has_issues",               default: true
    t.boolean  "has_wiki",                 default: false
    t.string   "srpm_file_name"
    t.string   "srpm_content_type"
    t.integer  "srpm_file_size"
    t.datetime "srpm_updated_at"
    t.string   "default_branch",           default: "master"
    t.boolean  "is_package",               default: true,     null: false
    t.integer  "maintainer_id"
    t.boolean  "publish_i686_into_x86_64", default: false
    t.string   "owner_uname",                                 null: false
    t.boolean  "architecture_dependent",   default: false,    null: false
    t.integer  "autostart_status"
    t.index ["name", "owner_id", "owner_type"], :name => "index_projects_on_name_and_owner_id_and_owner_type", :unique => true, :case_sensitive => false
  end

  create_table "advisories_projects", id: false, force: true do |t|
    t.integer "advisory_id"
    t.integer "project_id"
    t.index ["advisory_id", "project_id"], :name => "advisory_project_index", :unique => true
    t.index ["advisory_id"], :name => "fk__advisories_projects_advisory_id"
    t.index ["advisory_id"], :name => "index_advisories_projects_on_advisory_id"
    t.index ["project_id"], :name => "fk__advisories_projects_project_id"
    t.index ["project_id"], :name => "index_advisories_projects_on_project_id"
    t.foreign_key ["advisory_id"], "advisories", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_advisories_projects_advisory_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_advisories_projects_project_id"
  end

  create_table "arches", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], :name => "index_arches_on_name", :unique => true
  end

  create_table "authentications", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["provider", "uid"], :name => "index_authentications_on_provider_and_uid", :unique => true
    t.index ["user_id"], :name => "fk__authentications_user_id"
    t.index ["user_id"], :name => "index_authentications_on_user_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_authentications_user_id"
  end

  create_table "groups", force: true do |t|
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uname"
    t.integer  "own_projects_count",  default: 0, null: false
    t.text     "description"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "mass_builds", force: true do |t|
    t.integer  "build_for_platform_id",                          null: false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "arch_names"
    t.integer  "user_id"
    t.integer  "build_lists_count",             default: 0,      null: false
    t.boolean  "stop_build",                    default: false,  null: false
    t.text     "projects_list"
    t.integer  "missed_projects_count",         default: 0,      null: false
    t.text     "missed_projects_list"
    t.boolean  "new_core",                      default: true
    t.integer  "save_to_platform_id",                            null: false
    t.text     "extra_repositories"
    t.text     "extra_build_lists"
    t.boolean  "increase_release_tag",          default: false,  null: false
    t.boolean  "use_cached_chroot",             default: true,   null: false
    t.boolean  "use_extra_tests",               default: false,  null: false
    t.string   "description"
    t.string   "auto_publish_status",           default: "none", null: false
    t.text     "extra_mass_builds"
    t.boolean  "include_testing_subrepository", default: false,  null: false
    t.boolean  "auto_create_container",         default: false,  null: false
    t.integer  "status",                        default: 2000,   null: false
    t.index ["build_for_platform_id"], :name => "fk__mass_builds_platform_id"
    t.index ["user_id"], :name => "fk__mass_builds_user_id"
    t.foreign_key ["build_for_platform_id"], "platforms", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_mass_builds_platform_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_mass_builds_user_id"
  end

  create_table "build_lists", force: true do |t|
    t.integer  "status"
    t.string   "project_version"
    t.integer  "project_id"
    t.integer  "arch_id"
    t.datetime "notified_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_circle",                     default: false
    t.text     "additional_repos"
    t.string   "name"
    t.string   "update_type"
    t.integer  "build_for_platform_id"
    t.integer  "save_to_platform_id"
    t.text     "include_repos"
    t.integer  "user_id"
    t.string   "package_version"
    t.string   "commit_hash"
    t.integer  "priority",                      default: 0,         null: false
    t.datetime "started_at"
    t.integer  "duration"
    t.integer  "advisory_id"
    t.integer  "mass_build_id"
    t.integer  "save_to_repository_id"
    t.text     "results"
    t.boolean  "new_core",                      default: true
    t.string   "last_published_commit_hash"
    t.integer  "container_status"
    t.boolean  "auto_create_container",         default: false
    t.text     "extra_repositories"
    t.text     "extra_build_lists"
    t.integer  "publisher_id"
    t.integer  "group_id"
    t.text     "extra_params"
    t.string   "external_nodes"
    t.integer  "builder_id"
    t.boolean  "include_testing_subrepository"
    t.string   "auto_publish_status",           default: "default", null: false
    t.boolean  "use_cached_chroot",             default: false,     null: false
    t.boolean  "use_extra_tests",               default: true,      null: false
    t.index ["advisory_id"], :name => "fk__build_lists_advisory_id"
    t.index ["advisory_id"], :name => "index_build_lists_on_advisory_id"
    t.index ["arch_id"], :name => "fk__build_lists_arch_id"
    t.index ["arch_id"], :name => "index_build_lists_on_arch_id"
    t.index ["group_id"], :name => "fk__build_lists_group_id"
    t.index ["mass_build_id", "status"], :name => "index_build_lists_on_mass_build_id_and_status"
    t.index ["mass_build_id"], :name => "fk__build_lists_mass_build_id"
    t.index ["project_id", "save_to_repository_id", "build_for_platform_id", "arch_id"], :name => "maintainer_search_index"
    t.index ["project_id"], :name => "fk__build_lists_project_id"
    t.index ["project_id"], :name => "index_build_lists_on_project_id"
    t.index ["user_id"], :name => "fk__build_lists_user_id"
    t.foreign_key ["advisory_id"], "advisories", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_build_lists_advisory_id"
    t.foreign_key ["arch_id"], "arches", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_build_lists_arch_id"
    t.foreign_key ["group_id"], "groups", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_build_lists_group_id"
    t.foreign_key ["mass_build_id"], "mass_builds", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_build_lists_mass_build_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_build_lists_project_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_build_lists_user_id"
  end

  create_table "build_list_items", force: true do |t|
    t.string   "name"
    t.integer  "level"
    t.integer  "status"
    t.integer  "build_list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "version"
    t.index ["build_list_id"], :name => "fk__build_list_items_build_list_id"
    t.index ["build_list_id"], :name => "index_build_list_items_on_build_list_id"
    t.foreign_key ["build_list_id"], "build_lists", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_build_list_items_build_list_id"
  end

  create_table "build_list_packages", force: true do |t|
    t.integer  "build_list_id"
    t.integer  "project_id"
    t.integer  "platform_id"
    t.string   "fullname"
    t.string   "name"
    t.string   "version"
    t.string   "release"
    t.string   "package_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "actual",             default: false
    t.string   "sha1"
    t.integer  "epoch"
    t.text     "dependent_packages"
    t.index ["actual", "platform_id"], :name => "index_build_list_packages_on_actual_and_platform_id"
    t.index ["build_list_id"], :name => "fk__build_list_packages_build_list_id"
    t.index ["build_list_id"], :name => "index_build_list_packages_on_build_list_id"
    t.index ["name", "project_id"], :name => "index_build_list_packages_on_name_and_project_id"
    t.index ["platform_id"], :name => "fk__build_list_packages_platform_id"
    t.index ["platform_id"], :name => "index_build_list_packages_on_platform_id"
    t.index ["project_id"], :name => "fk__build_list_packages_project_id"
    t.index ["project_id"], :name => "index_build_list_packages_on_project_id"
    t.foreign_key ["build_list_id"], "build_lists", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_build_list_packages_build_list_id"
    t.foreign_key ["platform_id"], "platforms", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_build_list_packages_platform_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_build_list_packages_project_id"
  end

  create_table "build_scripts", force: true do |t|
    t.integer  "project_id", null: false
    t.string   "treeish",    null: false
    t.string   "commit"
    t.string   "sha1"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["project_id", "treeish"], :name => "index_build_scripts_on_project_id_and_treeish", :unique => true
    t.index ["project_id"], :name => "fk__build_scripts_project_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_build_scripts_project_id"
  end

  create_table "comments", force: true do |t|
    t.string   "commentable_type"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "commentable_id",           precision: 50, scale: 0
    t.integer  "project_id"
    t.text     "data"
    t.boolean  "automatic",                                         default: false
    t.decimal  "created_from_commit_hash", precision: 50, scale: 0
    t.integer  "created_from_issue_id"
    t.index ["automatic"], :name => "index_comments_on_automatic"
    t.index ["commentable_id"], :name => "index_comments_on_commentable_id"
    t.index ["commentable_type"], :name => "index_comments_on_commentable_type"
    t.index ["created_from_commit_hash"], :name => "index_comments_on_created_from_commit_hash"
    t.index ["created_from_issue_id"], :name => "index_comments_on_created_from_issue_id"
    t.index ["project_id"], :name => "fk__comments_project_id"
    t.index ["user_id"], :name => "fk__comments_user_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_comments_project_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_comments_user_id"
  end

  create_table "event_logs", force: true do |t|
    t.integer  "user_id"
    t.string   "user_name"
    t.integer  "eventable_id"
    t.string   "eventable_type"
    t.string   "eventable_name"
    t.string   "ip"
    t.string   "kind"
    t.string   "protocol"
    t.string   "controller"
    t.string   "action"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["eventable_id", "eventable_type"], :name => "index_event_logs_on_eventable_id_and_eventable_type"
    t.index ["user_id"], :name => "index_event_logs_on_user_id"
  end

  create_table "flash_notifies", force: true do |t|
    t.text     "body_ru",                   null: false
    t.text     "body_en",                   null: false
    t.string   "status",                    null: false
    t.boolean  "published",  default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hooks", force: true do |t|
    t.text     "data"
    t.integer  "project_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["project_id"], :name => "fk__hooks_project_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_hooks_project_id"
  end

  create_table "issues", force: true do |t|
    t.integer  "serial_id"
    t.integer  "project_id"
    t.integer  "assignee_id"
    t.string   "title"
    t.text     "body"
    t.string   "status",      default: "open"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.datetime "closed_at"
    t.integer  "closed_by"
    t.index ["assignee_id"], :name => "fk__issues_user_id"
    t.index ["project_id", "serial_id"], :name => "index_issues_on_project_id_and_serial_id", :unique => true
    t.index ["project_id"], :name => "fk__issues_project_id"
    t.index ["user_id"], :name => "index_issues_on_user_id"
    t.foreign_key ["assignee_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_issues_user_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_issues_project_id"
  end

  create_table "repositories", force: true do |t|
    t.string   "description",                                     null: false
    t.integer  "platform_id",                                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                                            null: false
    t.boolean  "publish_without_qa",              default: true
    t.boolean  "synchronizing_publications",      default: false, null: false
    t.string   "publish_builds_only_from_branch"
    t.index ["platform_id"], :name => "fk__repositories_platform_id"
    t.index ["platform_id"], :name => "index_repositories_on_platform_id"
    t.foreign_key ["platform_id"], "platforms", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_repositories_platform_id"
  end

  create_table "key_pairs", force: true do |t|
    t.text     "public",           null: false
    t.text     "encrypted_secret", null: false
    t.string   "key_id",           null: false
    t.integer  "user_id",          null: false
    t.integer  "repository_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["repository_id"], :name => "fk__key_pairs_repository_id"
    t.index ["repository_id"], :name => "index_key_pairs_on_repository_id", :unique => true
    t.index ["user_id"], :name => "fk__key_pairs_user_id"
    t.foreign_key ["repository_id"], "repositories", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_key_pairs_repository_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_key_pairs_user_id"
  end

  create_table "key_pairs_backup", force: true do |t|
    t.integer  "repository_id", null: false
    t.integer  "user_id",       null: false
    t.string   "key_id",        null: false
    t.text     "public",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["repository_id"], :name => "fk__key_pairs_backup_repository_id"
    t.index ["repository_id"], :name => "index_key_pairs_backup_on_repository_id", :unique => true
    t.index ["user_id"], :name => "fk__key_pairs_backup_user_id"
    t.foreign_key ["repository_id"], "repositories", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_key_pairs_backup_repository_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_key_pairs_backup_user_id"
  end

  create_table "labels", force: true do |t|
    t.string   "name",       null: false
    t.string   "color",      null: false
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["project_id"], :name => "fk__labels_project_id"
    t.index ["project_id"], :name => "index_labels_on_project_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_labels_project_id"
  end

  create_table "labelings", force: true do |t|
    t.integer  "label_id",   null: false
    t.integer  "issue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["issue_id"], :name => "fk__labelings_issue_id"
    t.index ["issue_id"], :name => "index_labelings_on_issue_id"
    t.index ["label_id"], :name => "fk__labelings_label_id"
    t.foreign_key ["issue_id"], "issues", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_labelings_issue_id"
    t.foreign_key ["label_id"], "labels", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_labelings_label_id"
  end

  create_table "node_instructions", force: true do |t|
    t.integer  "user_id",               null: false
    t.text     "encrypted_instruction", null: false
    t.text     "output"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], :name => "fk__node_instructions_user_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_node_instructions_user_id"
  end

  create_table "platform_arch_settings", force: true do |t|
    t.integer  "platform_id", null: false
    t.integer  "arch_id",     null: false
    t.integer  "time_living", null: false
    t.boolean  "default"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["arch_id"], :name => "fk__platform_arch_settings_arch_id"
    t.index ["platform_id", "arch_id"], :name => "index_platform_arch_settings_on_platform_id_and_arch_id", :unique => true
    t.index ["platform_id"], :name => "fk__platform_arch_settings_platform_id"
    t.foreign_key ["arch_id"], "arches", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_platform_arch_settings_arch_id"
    t.foreign_key ["platform_id"], "platforms", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_platform_arch_settings_platform_id"
  end

  create_table "products", force: true do |t|
    t.string   "name",             null: false
    t.integer  "platform_id",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.integer  "project_id"
    t.string   "params"
    t.string   "main_script"
    t.integer  "time_living"
    t.integer  "autostart_status"
    t.string   "project_version"
    t.index ["platform_id"], :name => "fk__products_platform_id"
    t.index ["project_id"], :name => "fk__products_project_id"
    t.foreign_key ["platform_id"], "platforms", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_products_platform_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_products_project_id"
  end

  create_table "product_build_lists", force: true do |t|
    t.integer  "product_id"
    t.integer  "status",                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.string   "project_version"
    t.string   "commit_hash"
    t.string   "params"
    t.string   "main_script"
    t.text     "results"
    t.integer  "arch_id"
    t.integer  "time_living"
    t.integer  "user_id"
    t.boolean  "not_delete",      default: false
    t.boolean  "autostarted",     default: false
    t.index ["arch_id"], :name => "fk__product_build_lists_arch_id"
    t.index ["product_id"], :name => "fk__product_build_lists_product_id"
    t.index ["product_id"], :name => "index_product_build_lists_on_product_id"
    t.index ["project_id"], :name => "fk__product_build_lists_project_id"
    t.index ["user_id"], :name => "fk__product_build_lists_user_id"
    t.foreign_key ["arch_id"], "arches", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_product_build_lists_arch_id"
    t.foreign_key ["product_id"], "products", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_product_build_lists_product_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_product_build_lists_project_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_product_build_lists_user_id"
  end

  create_table "project_imports", force: true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.string   "version"
    t.datetime "file_mtime"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "platform_id"
    t.index ["name", "platform_id"], :name => "index_project_imports_on_name_and_platform_id", :unique => true, :case_sensitive => false
    t.index ["platform_id"], :name => "fk__project_imports_platform_id"
    t.index ["project_id"], :name => "fk__project_imports_project_id"
    t.foreign_key ["platform_id"], "platforms", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_project_imports_platform_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_project_imports_project_id"
  end

  create_table "project_statistics", force: true do |t|
    t.integer  "average_build_time", default: 0, null: false
    t.integer  "build_count",        default: 0, null: false
    t.integer  "arch_id",                        null: false
    t.integer  "project_id",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["arch_id"], :name => "fk__project_statistics_arch_id"
    t.index ["project_id", "arch_id"], :name => "index_project_statistics_on_project_id_and_arch_id", :unique => true
    t.index ["project_id"], :name => "fk__project_statistics_project_id"
    t.foreign_key ["arch_id"], "arches", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_project_statistics_arch_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_project_statistics_project_id"
  end

  create_table "project_tags", force: true do |t|
    t.integer  "project_id"
    t.string   "commit_id"
    t.string   "sha1"
    t.string   "tag_name"
    t.integer  "format_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["project_id"], :name => "fk__project_tags_project_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_project_tags_project_id"
  end

  create_table "project_to_repositories", force: true do |t|
    t.integer  "project_id"
    t.integer  "repository_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "autostart_options"
    t.index ["project_id"], :name => "fk__project_to_repositories_project_id"
    t.index ["repository_id", "project_id"], :name => "index_project_to_repositories_on_repository_id_and_project_id", :unique => true
    t.index ["repository_id"], :name => "fk__project_to_repositories_repository_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_project_to_repositories_project_id"
    t.foreign_key ["repository_id"], "repositories", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_project_to_repositories_repository_id"
  end

  create_table "pull_requests", force: true do |t|
    t.integer "issue_id",                 null: false
    t.integer "to_project_id",            null: false
    t.integer "from_project_id",          null: false
    t.string  "to_ref",                   null: false
    t.string  "from_ref",                 null: false
    t.string  "from_project_owner_uname"
    t.string  "from_project_name"
    t.index ["from_project_id"], :name => "index_pull_requests_on_from_project_id"
    t.index ["issue_id"], :name => "fk__pull_requests_issue_id"
    t.index ["issue_id"], :name => "index_pull_requests_on_issue_id"
    t.index ["to_project_id"], :name => "index_pull_requests_on_to_project_id"
    t.foreign_key ["issue_id"], "issues", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_pull_requests_issue_id"
  end

  create_table "register_requests", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "token"
    t.boolean  "approved",   default: false
    t.boolean  "rejected",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "interest"
    t.text     "more"
    t.string   "language"
    t.index ["email"], :name => "index_register_requests_on_email", :unique => true, :case_sensitive => false
    t.index ["token"], :name => "index_register_requests_on_token", :unique => true, :case_sensitive => false
  end

  create_table "relations", force: true do |t|
    t.integer  "actor_id"
    t.string   "actor_type"
    t.integer  "target_id"
    t.string   "target_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.index ["actor_type", "actor_id"], :name => "index_relations_on_actor_type_and_actor_id"
    t.index ["target_type", "target_id"], :name => "index_relations_on_target_type_and_target_id"
  end

  create_table "repository_statuses", force: true do |t|
    t.integer  "repository_id",                         null: false
    t.integer  "platform_id",                           null: false
    t.integer  "status",                    default: 0
    t.datetime "last_regenerated_at"
    t.integer  "last_regenerated_status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "last_regenerated_log_sha1"
    t.index ["platform_id"], :name => "fk__repository_statuses_platform_id"
    t.index ["repository_id", "platform_id"], :name => "index_repository_statuses_on_repository_id_and_platform_id", :unique => true
    t.index ["repository_id"], :name => "fk__repository_statuses_repository_id"
    t.foreign_key ["platform_id"], "platforms", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_repository_statuses_platform_id"
    t.foreign_key ["repository_id"], "repositories", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_repository_statuses_repository_id"
  end

  create_table "settings_notifiers", force: true do |t|
    t.integer  "user_id",                                       null: false
    t.boolean  "can_notify",                    default: true
    t.boolean  "new_comment",                   default: true
    t.boolean  "new_comment_reply",             default: true
    t.boolean  "new_issue",                     default: true
    t.boolean  "issue_assign",                  default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "new_comment_commit_owner",      default: true
    t.boolean  "new_comment_commit_repo_owner", default: true
    t.boolean  "new_comment_commit_commentor",  default: true
    t.boolean  "new_build",                     default: true
    t.boolean  "new_associated_build",          default: true
    t.boolean  "update_code",                   default: false
    t.index ["user_id"], :name => "fk__settings_notifiers_user_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_settings_notifiers_user_id"
  end

  create_table "ssh_keys", force: true do |t|
    t.string   "name"
    t.text     "key",         null: false
    t.string   "fingerprint", null: false
    t.integer  "user_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["fingerprint"], :name => "index_ssh_keys_on_fingerprint", :unique => true
    t.index ["user_id"], :name => "fk__ssh_keys_user_id"
    t.index ["user_id"], :name => "index_ssh_keys_on_user_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_ssh_keys_user_id"
  end

  create_table "subscribes", force: true do |t|
    t.string   "subscribeable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "status",                                      default: true
    t.integer  "project_id"
    t.decimal  "subscribeable_id",   precision: 50, scale: 0
    t.index ["project_id"], :name => "fk__subscribes_project_id"
    t.index ["user_id"], :name => "fk__subscribes_user_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_subscribes_project_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_subscribes_user_id"
  end

  create_table "tokens", force: true do |t|
    t.integer  "subject_id",                              null: false
    t.string   "subject_type",                            null: false
    t.integer  "creator_id",                              null: false
    t.integer  "updater_id"
    t.string   "status",               default: "active"
    t.text     "description"
    t.string   "authentication_token",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["authentication_token"], :name => "index_tokens_on_authentication_token", :unique => true
    t.index ["subject_id", "subject_type"], :name => "index_tokens_on_subject_id_and_subject_type"
  end

end
