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

ActiveRecord::Schema.define(version: 20171130201127) do

  create_table "annotations", force: :cascade do |t|
    t.string  "uuid",             limit: 255
    t.string  "source_uri",       limit: 255
    t.integer "playlist_item_id", limit: 4
    t.text    "annotation",       limit: 65535
    t.string  "type",             limit: 255
  end

  add_index "annotations", ["playlist_item_id"], name: "index_annotations_on_playlist_item_id", using: :btree
  add_index "annotations", ["type"], name: "index_annotations_on_type", using: :btree

  create_table "api_tokens", force: :cascade do |t|
    t.string   "token",      limit: 255, null: false
    t.string   "username",   limit: 255, null: false
    t.string   "email",      limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "api_tokens", ["token"], name: "index_api_tokens_on_token", unique: true, using: :btree
  add_index "api_tokens", ["username"], name: "index_api_tokens_on_username", using: :btree

  create_table "batch_entries", force: :cascade do |t|
    t.integer  "batch_registries_id", limit: 4
    t.text     "payload",             limit: 4294967295
    t.boolean  "complete",                               default: false, null: false
    t.boolean  "error",                                  default: false, null: false
    t.string   "current_status",      limit: 255
    t.text     "error_message",       limit: 65535
    t.string   "media_object_pid",    limit: 255
    t.integer  "position",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "batch_entries", ["batch_registries_id"], name: "index_batch_entries_on_batch_registries_id", using: :btree
  add_index "batch_entries", ["position"], name: "index_batch_entries_on_position", using: :btree

  create_table "batch_registries", force: :cascade do |t|
    t.string   "file_name",            limit: 255
    t.string   "replay_name",          limit: 255
    t.string   "dir",                  limit: 255
    t.integer  "user_id",              limit: 4
    t.string   "collection",           limit: 255
    t.boolean  "complete",                           default: false, null: false
    t.boolean  "processed_email_sent",               default: false, null: false
    t.boolean  "completed_email_sent",               default: false, null: false
    t.boolean  "error",                              default: false, null: false
    t.text     "error_message",        limit: 65535
    t.boolean  "error_email_sent",                   default: false, null: false
    t.boolean  "locked",                             default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.integer  "user_id",       limit: 4,   null: false
    t.string   "user_type",     limit: 255
    t.string   "document_id",   limit: 255
    t.string   "document_type", limit: 255
    t.string   "title",         limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "bookmarks", ["document_id"], name: "index_bookmarks_on_document_id", using: :btree
  add_index "bookmarks", ["user_id"], name: "index_bookmarks_on_user_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "context_id", limit: 255
    t.string   "title",      limit: 255
    t.text     "label",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "identities", force: :cascade do |t|
    t.string   "email",           limit: 255
    t.string   "password_digest", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ingest_batches", force: :cascade do |t|
    t.string   "name",             limit: 50
    t.string   "email",            limit: 255
    t.text     "media_object_ids", limit: 65535
    t.boolean  "finished",                       default: false
    t.boolean  "email_sent",                     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "migration_statuses", force: :cascade do |t|
    t.string   "source_class", limit: 255,   null: false
    t.string   "f3_pid",       limit: 255,   null: false
    t.string   "f4_pid",       limit: 255
    t.string   "datastream",   limit: 255
    t.string   "checksum",     limit: 255
    t.string   "status",       limit: 255
    t.text     "log",          limit: 65535
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "migration_statuses", ["source_class", "f3_pid", "datastream"], name: "index_migration_statuses", using: :btree

  create_table "minter_states", force: :cascade do |t|
    t.string   "namespace",  limit: 255,   default: "default", null: false
    t.string   "template",   limit: 255,                       null: false
    t.text     "counters",   limit: 65535
    t.integer  "seq",        limit: 8,     default: 0
    t.binary   "rand",       limit: 65535
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "minter_states", ["namespace"], name: "index_minter_states_on_namespace", unique: true, using: :btree

  create_table "playlist_items", force: :cascade do |t|
    t.integer  "playlist_id", limit: 4, null: false
    t.integer  "clip_id",     limit: 4, null: false
    t.integer  "position",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "playlist_items", ["clip_id"], name: "index_playlist_items_on_clip_id", using: :btree
  add_index "playlist_items", ["playlist_id"], name: "index_playlist_items_on_playlist_id", using: :btree

  create_table "playlists", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.integer  "user_id",      limit: 4,   null: false
    t.string   "comment",      limit: 255
    t.string   "visibility",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access_token", limit: 255
    t.string   "tags",         limit: 255
  end

  add_index "playlists", ["user_id"], name: "index_playlists_on_user_id", using: :btree

  create_table "role_maps", force: :cascade do |t|
    t.string  "entry",     limit: 255
    t.integer "parent_id", limit: 4
  end

  create_table "searches", force: :cascade do |t|
    t.text     "query_params", limit: 65535
    t.integer  "user_id",      limit: 4
    t.string   "user_type",    limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "searches", ["user_id"], name: "index_searches_on_user_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "stream_tokens", force: :cascade do |t|
    t.string   "token",   limit: 255
    t.string   "target",  limit: 255
    t.datetime "expires"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",   limit: 255, null: false
    t.string   "email",      limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider",   limit: 255
    t.string   "uid",        limit: 255
    t.string   "guest",      limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
