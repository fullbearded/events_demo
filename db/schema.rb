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

ActiveRecord::Schema.define(version: 20170615150941) do

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "uid",        limit: 32,    default: "", null: false, comment: "unique id"
    t.text     "content",    limit: 65535
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "uid",            limit: 32,  default: "",    null: false, comment: "unique id"
    t.string   "name",                       default: "",    null: false, comment: "name"
    t.string   "description",    limit: 500, default: "",    null: false, comment: "description"
    t.boolean  "guest_lockable",             default: false, null: false, comment: "hide sensitive content"
    t.integer  "project_type",               default: 0,     null: false, comment: "project type: 0 standard, 1 pipeline"
    t.boolean  "publishable",                default: false, null: false, comment: "everyone can visit project"
    t.integer  "team_id",                    default: 0,     null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.index ["team_id"], name: "index_projects_on_team_id", using: :btree
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
    t.index ["name"], name: "index_roles_on_name", using: :btree
  end

  create_table "tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       default: "", null: false
    t.integer  "team_id",    default: 0,  null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["team_id"], name: "index_tags_on_team_id", using: :btree
  end

  create_table "teams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "uid",        limit: 32, default: "", null: false, comment: "unique id"
    t.string   "name",                  default: "", null: false, comment: "team name"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "teams_users", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "team_id", null: false
    t.integer "user_id", null: false
    t.index ["team_id", "user_id"], name: "index_teams_users_on_team_id_and_user_id", using: :btree
    t.index ["user_id", "team_id"], name: "index_teams_users_on_user_id_and_team_id", using: :btree
  end

  create_table "todos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "the tasks" do |t|
    t.string   "title",                     default: "", null: false, comment: "task title"
    t.text     "description", limit: 65535
    t.integer  "priority",                  default: 0,  null: false, comment: "task priority"
    t.integer  "project_id",                default: 0,  null: false
    t.integer  "tag_id",                    default: 0,  null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.index ["project_id"], name: "index_todos_on_project_id", using: :btree
    t.index ["tag_id"], name: "index_todos_on_tag_id", using: :btree
  end

  create_table "user_groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "user group" do |t|
    t.string   "uid",        limit: 32, default: "", null: false, comment: "unique id"
    t.string   "name",       limit: 50, default: "", null: false, comment: "group name"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "uid",              limit: 32,  default: "", null: false, comment: "unique id"
    t.string   "crypted_password",             default: "", null: false
    t.string   "salt",                         default: "", null: false
    t.string   "name",             limit: 30,  default: "", null: false, comment: "user name"
    t.string   "email",            limit: 100, default: "", null: false, comment: "user email"
    t.string   "mobile",           limit: 11,  default: "", null: false, comment: "user mobile"
    t.string   "remark",                       default: "", null: false, comment: "user remark"
    t.integer  "team_id",                      default: 0,  null: false
    t.integer  "user_group_id",                default: 0,  null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["team_id"], name: "index_users_on_team_id", using: :btree
    t.index ["user_group_id"], name: "index_users_on_user_group_id", using: :btree
  end

  create_table "users_roles", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree
  end

end
