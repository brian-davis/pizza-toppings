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

ActiveRecord::Schema[7.2].define(version: 2024_11_07_231101) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pizza_toppings", force: :cascade do |t|
    t.bigint "pizza_id", null: false
    t.bigint "topping_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pizza_id", "topping_id"], name: "index_pizza_toppings_on_pizza_id_and_topping_id", unique: true
    t.index ["pizza_id"], name: "index_pizza_toppings_on_pizza_id"
    t.index ["topping_id"], name: "index_pizza_toppings_on_topping_id"
  end

  create_table "pizzas", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "chef_id", null: false
    t.index ["chef_id"], name: "index_pizzas_on_chef_id"
    t.index ["name", "chef_id"], name: "index_pizzas_on_name_and_chef_id", unique: true
  end

  create_table "toppings", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "owner_id", null: false
    t.index ["name", "owner_id"], name: "index_toppings_on_name_and_owner_id", unique: true
    t.index ["owner_id"], name: "index_toppings_on_owner_id"
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
    t.bigint "manager_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["manager_id"], name: "index_users_on_manager_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "pizza_toppings", "pizzas"
  add_foreign_key "pizza_toppings", "toppings"
  add_foreign_key "pizzas", "users", column: "chef_id"
  add_foreign_key "toppings", "users", column: "owner_id"
  add_foreign_key "users", "users", column: "manager_id"
end
