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

ActiveRecord::Schema.define(version: 20140917033212) do

  create_table "products", force: true do |t|
    t.string  "brand"
    t.string  "model"
    t.integer "cadr_dust"
    t.boolean "aham_verified"
    t.float   "power_max"
    t.float   "noise_max"
    t.string  "made_in"
    t.float   "weight"
    t.float   "price"
    t.integer "air_volume"
    t.integer "fan_speed_levels"
    t.boolean "sleep_mode"
    t.boolean "timing"
    t.boolean "quality_meter"
    t.boolean "filter_reminder"
    t.boolean "remote_control"
    t.float   "score"
    t.string  "reviews_link"
    t.string  "etao_link"
  end

end
