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

ActiveRecord::Schema.define(version: 20180226051410) do

  create_table "channels", force: :cascade do |t|
    t.string "channel_id"
    t.integer "league_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "webhook_url"
    t.string "server_name"
    t.index ["league_id"], name: "index_channels_on_league_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "event_leaderboards", force: :cascade do |t|
    t.text "content"
    t.integer "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_leaderboards_on_event_id"
  end

  create_table "events", primary_key: "event_id", force: :cascade do |t|
    t.datetime "open_at"
    t.datetime "close_at"
    t.integer "season_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "countries"
    t.integer "stages"
    t.index ["season_id"], name: "index_events_on_season_id"
  end

  create_table "leagues", primary_key: "team_id", force: :cascade do |t|
    t.string "league_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "season_standings", force: :cascade do |t|
    t.text "content"
    t.integer "season_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["season_id"], name: "index_season_standings_on_season_id"
  end

  create_table "seasons", primary_key: "season_id", force: :cascade do |t|
    t.integer "league_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_seasons_on_league_id"
  end

  create_table "stage_leaderboards", force: :cascade do |t|
    t.text "content"
    t.integer "stage_id"
    t.integer "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location"
    t.string "location_image"
    t.string "stage_name"
    t.string "stage_image"
    t.string "time_of_day"
    t.string "weather"
    t.string "weather_image"
    t.boolean "stage_retry"
    t.boolean "has_service_area"
    t.boolean "allow_career_engineers"
    t.boolean "allow_vehicle_tuning"
    t.boolean "is_checkpoint"
    t.index ["event_id"], name: "index_stage_leaderboards_on_event_id"
  end

end
