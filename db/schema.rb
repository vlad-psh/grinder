# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_02_20_095539) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.bigint "user_id"
    t.date "date"
    t.integer "category"
    t.bigint "seconds", default: 0
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "drills", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil
    t.boolean "is_active", default: true
    t.integer "leitner_session", default: 0
    t.integer "leitner_fresh", default: 0
    t.index ["user_id"], name: "index_drills_on_user_id"
  end

  create_table "drills_progresses", force: :cascade do |t|
    t.bigint "drill_id"
    t.bigint "progress_id"
    t.datetime "created_at", precision: nil
    t.index ["drill_id"], name: "index_drills_progresses_on_drill_id"
    t.index ["progress_id"], name: "index_drills_progresses_on_progress_id"
  end

  create_table "kanji", force: :cascade do |t|
    t.string "title"
    t.integer "jlpt"
    t.integer "jlptn"
    t.integer "grade"
    t.integer "heisig"
    t.integer "strokes", array: true
    t.string "english", array: true
    t.string "on", array: true
    t.string "kun", array: true
    t.string "nanori", array: true
    t.string "searchable_en"
    t.integer "radnum"
    t.jsonb "links"
    t.jsonb "similars"
    t.string "jp"
    t.string "jp_url"
  end

  create_table "kanji_readings", force: :cascade do |t|
    t.string "title"
    t.string "reading"
    t.integer "kind"
  end

  create_table "notes", force: :cascade do |t|
    t.string "content"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
  end

  create_table "progresses", force: :cascade do |t|
    t.bigint "card_id"
    t.bigint "user_id"
    t.integer "seq"
    t.datetime "learned_at", precision: nil
    t.datetime "burned_at", precision: nil
    t.string "title"
    t.integer "kanji_id"
    t.integer "wk_radical_id"
    t.text "comment"
    t.boolean "flagged", default: false
    t.index ["card_id"], name: "index_progresses_on_card_id"
    t.index ["seq"], name: "index_progresses_on_seq"
    t.index ["user_id"], name: "index_progresses_on_user_id"
  end

  create_table "sentence_reviews", force: :cascade do |t|
    t.bigint "sentence_id"
    t.bigint "user_id"
    t.integer "learning_type", default: 0
    t.datetime "reviewed_at", precision: nil
    t.index ["sentence_id"], name: "index_sentence_reviews_on_sentence_id"
    t.index ["user_id"], name: "index_sentence_reviews_on_user_id"
  end

  create_table "sentences", force: :cascade do |t|
    t.string "japanese"
    t.string "english"
    t.string "russian"
    t.json "structure"
    t.json "details"
    t.datetime "created_at", precision: nil
    t.bigint "drill_id"
    t.bigint "user_id"
    t.index ["drill_id"], name: "index_sentences_on_drill_id"
    t.index ["user_id"], name: "index_sentences_on_user_id"
  end

  create_table "sentences_words", force: :cascade do |t|
    t.bigint "sentence_id"
    t.integer "word_seq"
    t.index ["sentence_id"], name: "index_sentences_words_on_sentence_id"
    t.index ["word_seq"], name: "index_sentences_words_on_word_seq"
  end

  create_table "srs_progresses", force: :cascade do |t|
    t.integer "learning_type", default: 0
    t.bigint "progress_id"
    t.bigint "user_id"
    t.integer "deck"
    t.date "scheduled"
    t.date "transition"
    t.string "last_answer"
    t.datetime "reviewed_at", precision: nil
    t.integer "leitner_box"
    t.integer "leitner_last_reviewed_at_session"
    t.integer "leitner_combo", default: 0
    t.integer "fail_count", default: 0
    t.index ["progress_id"], name: "index_srs_progresses_on_progress_id"
    t.index ["user_id"], name: "index_srs_progresses_on_user_id"
  end

  create_table "statistics", force: :cascade do |t|
    t.date "date"
    t.jsonb "learned", default: {"k"=>0, "r"=>0, "w"=>0}
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "login"
    t.string "salt"
    t.string "pwhash"
    t.jsonb "settings", default: {}
    t.string "invite_token"
  end

  create_table "wk_kanji", force: :cascade do |t|
    t.integer "level"
    t.string "title"
    t.bigint "kanji_id"
    t.integer "wk_internal_id"
    t.string "meaning"
    t.jsonb "readings"
    t.string "mmne"
    t.string "mhnt"
    t.string "rmne"
    t.string "rhnt"
  end

  create_table "wk_kanji_radicals", id: false, force: :cascade do |t|
    t.bigint "wk_kanji_id"
    t.bigint "wk_radical_id"
    t.index ["wk_kanji_id"], name: "index_wk_kanji_radicals_on_wk_kanji_id"
    t.index ["wk_radical_id"], name: "index_wk_kanji_radicals_on_wk_radical_id"
  end

  create_table "wk_kanji_words", id: false, force: :cascade do |t|
    t.bigint "wk_kanji_id"
    t.bigint "wk_word_id"
    t.index ["wk_kanji_id"], name: "index_wk_kanji_words_on_wk_kanji_id"
    t.index ["wk_word_id"], name: "index_wk_kanji_words_on_wk_word_id"
  end

  create_table "wk_radicals", force: :cascade do |t|
    t.integer "level"
    t.string "title"
    t.integer "wk_internal_id"
    t.string "meaning"
    t.string "nmne"
    t.string "svg"
  end

  create_table "wk_words", force: :cascade do |t|
    t.integer "level"
    t.string "title"
    t.integer "seq"
    t.integer "wk_internal_id"
    t.string "reading"
    t.string "meaning"
    t.string "pos"
    t.string "mmne"
    t.string "rmne"
    t.jsonb "sentences"
  end

  create_table "word_details", force: :cascade do |t|
    t.integer "seq"
    t.integer "user_id"
    t.string "comment"
  end

  create_table "word_titles", force: :cascade do |t|
    t.integer "seq"
    t.string "title"
    t.boolean "is_kanji", default: true
    t.integer "order"
    t.integer "news"
    t.integer "ichi"
    t.integer "spec"
    t.integer "gai"
    t.integer "nf"
    t.boolean "is_common", default: false
    t.string "pitch"
  end

  create_table "words", force: :cascade do |t|
    t.integer "seq"
    t.integer "nf"
    t.string "kanji"
    t.json "en"
    t.json "ru"
    t.boolean "is_common"
    t.jsonb "kebs"
    t.jsonb "rebs"
    t.integer "jlptn"
    t.string "searchable_jp"
    t.string "searchable_en"
    t.string "searchable_ru"
    t.jsonb "nhk_data"
    t.json "az"
    t.json "meikyo"
    t.index ["seq"], name: "index_words_on_seq"
  end

end
