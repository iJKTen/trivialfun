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

ActiveRecord::Schema.define(version: 2019_01_15_002214) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.string "answer"
    t.boolean "correct"
    t.bigint "team_id"
    t.bigint "question_id"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["team_id"], name: "index_answers_on_team_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.string "title"
    t.date "date"
    t.string "winner"
    t.bigint "venue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["venue_id"], name: "index_games_on_venue_id"
  end

  create_table "players", force: :cascade do |t|
    t.bigint "roster_id"
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["roster_id", "team_id"], name: "index_players_on_roster_id_and_team_id", unique: true
    t.index ["roster_id"], name: "index_players_on_roster_id"
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "questionnaires", force: :cascade do |t|
    t.string "title"
    t.text "answer"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_questionnaires_on_category_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "title"
    t.text "answer"
    t.integer "order"
    t.bigint "round_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["round_id"], name: "index_questions_on_round_id"
  end

  create_table "rosters", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rounds", force: :cascade do |t|
    t.string "title"
    t.integer "order"
    t.bigint "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_rounds_on_game_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "venue_id"
    t.bigint "roster_id"
    t.boolean "newsletter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["roster_id"], name: "index_subscriptions_on_roster_id"
    t.index ["venue_id"], name: "index_subscriptions_on_venue_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.boolean "won"
    t.bigint "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_teams_on_game_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_venues", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "venue_id"
    t.index ["user_id", "venue_id"], name: "index_users_venues_on_user_id_and_venue_id", unique: true
    t.index ["user_id"], name: "index_users_venues_on_user_id"
    t.index ["venue_id"], name: "index_users_venues_on_venue_id"
  end

  create_table "venues", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.string "phone"
    t.integer "total_rounds_per_game"
    t.integer "total_questions_per_round"
    t.integer "maximum_players_per_team"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "time_to_answer_question_in_seconds"
    t.string "email"
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "teams"
  add_foreign_key "games", "venues"
  add_foreign_key "players", "rosters"
  add_foreign_key "players", "teams"
  add_foreign_key "questionnaires", "categories"
  add_foreign_key "questions", "rounds"
  add_foreign_key "rounds", "games"
  add_foreign_key "subscriptions", "rosters"
  add_foreign_key "subscriptions", "venues"
  add_foreign_key "teams", "games"
  add_foreign_key "users_venues", "users"
  add_foreign_key "users_venues", "venues"
end
