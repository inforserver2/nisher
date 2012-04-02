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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120328142215) do

  create_table "addresses", :force => true do |t|
    t.integer  "user_id"
    t.string   "street_name"
    t.string   "number"
    t.string   "neighborhood"
    t.string   "complement"
    t.string   "city_name"
    t.string   "state_name"
    t.string   "zip"
    t.integer  "country_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "addresses", ["country_id"], :name => "index_addresses_on_country_id"
  add_index "addresses", ["user_id"], :name => "index_addresses_on_user_id"

  create_table "bank_account_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "bank_accounts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "bank_id"
    t.integer  "bank_account_type_id"
    t.string   "agency"
    t.string   "account"
    t.string   "fullname_owner"
    t.string   "cpf_owner"
    t.string   "extra"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "bank_accounts", ["bank_account_type_id"], :name => "index_bank_accounts_on_bank_account_type_id"
  add_index "bank_accounts", ["bank_id"], :name => "index_bank_accounts_on_bank_id"
  add_index "bank_accounts", ["user_id"], :name => "index_bank_accounts_on_user_id"

  create_table "banks", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "blacklist_usernames", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "boletos", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.float    "price",       :default => 0.0
    t.integer  "status",      :default => 0
    t.string   "order_id"
    t.string   "address1"
    t.string   "address2"
    t.string   "cpfcnpj"
    t.date     "expire_date"
    t.datetime "closed_at"
    t.string   "token"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "bolls", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "carts", :force => true do |t|
    t.integer  "order_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "carts", ["order_id"], :name => "index_carts_on_order_id"

  create_table "comm_types", :force => true do |t|
    t.string   "name"
    t.boolean  "show",       :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "comms", :force => true do |t|
    t.float    "value",        :default => 0.0,   :null => false
    t.integer  "status",       :default => 0,     :null => false
    t.integer  "type_id",      :default => 1,     :null => false
    t.integer  "comm_type_id"
    t.integer  "order_id"
    t.integer  "user_id",                         :null => false
    t.integer  "from_user_id"
    t.integer  "to_user_id"
    t.integer  "payment_id"
    t.boolean  "blocked",      :default => false, :null => false
    t.datetime "blocked_at"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "comms", ["order_id"], :name => "index_comms_on_order_id"
  add_index "comms", ["user_id"], :name => "index_comms_on_user_id"

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "subject"
    t.text     "message"
    t.integer  "sponsor_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "frete_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "fretes", :force => true do |t|
    t.string   "to_name"
    t.string   "street_name"
    t.string   "number"
    t.string   "neighborhood"
    t.string   "complement"
    t.string   "city_name"
    t.string   "state_name"
    t.integer  "country_id"
    t.string   "zip_to"
    t.decimal  "weight_total"
    t.integer  "length_total"
    t.integer  "width_total"
    t.integer  "height_total"
    t.float    "price",         :default => 0.0
    t.text     "query"
    t.integer  "frete_type_id"
    t.integer  "cart_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "fretes", ["cart_id"], :name => "index_fretes_on_cart_id"
  add_index "fretes", ["country_id"], :name => "index_fretes_on_country_id"
  add_index "fretes", ["frete_type_id"], :name => "index_fretes_on_frete_type_id"

  create_table "jobs", :force => true do |t|
    t.string   "name"
    t.integer  "type_id"
    t.text     "log"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "line_items", :force => true do |t|
    t.integer  "product_id"
    t.integer  "cart_id"
    t.float    "total_comm_value", :default => 0.0
    t.integer  "product_taste_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "quantity",         :default => 1
    t.float    "unit_price",       :default => 0.0
  end

  create_table "matrices", :force => true do |t|
    t.integer  "user_id"
    t.integer  "upline_id",                      :null => false
    t.integer  "downlines_count", :default => 0
    t.integer  "level1",          :default => 0
    t.integer  "level2",          :default => 0
    t.integer  "level3",          :default => 0
    t.integer  "level4",          :default => 0
    t.integer  "level5",          :default => 0
    t.integer  "level6",          :default => 0
    t.integer  "level7",          :default => 0
    t.integer  "level8",          :default => 0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "matrices", ["upline_id"], :name => "index_matrices_on_upline_id"
  add_index "matrices", ["user_id", "upline_id"], :name => "index_matrices_on_user_id_and_upline_id"
  add_index "matrices", ["user_id"], :name => "index_matrices_on_user_id"

  create_table "multiusers", :force => true do |t|
    t.string   "cpfcnpj"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "news", :force => true do |t|
    t.string   "email",                         :null => false
    t.boolean  "blocked",    :default => false, :null => false
    t.datetime "blocked_at"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "orders", :force => true do |t|
    t.float    "price",           :default => 0.0
    t.integer  "status",          :default => 0
    t.string   "token"
    t.integer  "user_id"
    t.boolean  "blocked",         :default => false, :null => false
    t.datetime "blocked_at"
    t.text     "extra"
    t.boolean  "closed"
    t.datetime "closed_at"
    t.boolean  "paid_with_money", :default => true
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "p_bank_accounts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "bank_id"
    t.integer  "bank_account_type_id"
    t.integer  "payment_id"
    t.string   "agency"
    t.string   "account"
    t.string   "fullname_owner"
    t.string   "cpf_owner"
    t.string   "extra"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "p_bank_accounts", ["bank_account_type_id"], :name => "index_p_bank_accounts_on_bank_account_type_id"
  add_index "p_bank_accounts", ["bank_id"], :name => "index_p_bank_accounts_on_bank_id"
  add_index "p_bank_accounts", ["payment_id"], :name => "index_p_bank_accounts_on_payment_id"
  add_index "p_bank_accounts", ["user_id"], :name => "index_p_bank_accounts_on_user_id"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "payments", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.float    "value",      :default => 0.0,   :null => false
    t.integer  "status",     :default => 0,     :null => false
    t.text     "obs"
    t.boolean  "closed",     :default => false, :null => false
    t.datetime "closed_at"
    t.boolean  "blocked",    :default => false, :null => false
    t.datetime "blocked_at"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "payments", ["user_id"], :name => "index_payments_on_user_id"

  create_table "product_categories", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "product_categories_products", :id => false, :force => true do |t|
    t.integer "product_category_id"
    t.integer "product_id"
  end

  create_table "product_tastes", :force => true do |t|
    t.string   "name"
    t.integer  "product_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "product_tastes", ["product_id"], :name => "index_product_tastes_on_product_id"

  create_table "products", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image"
    t.float    "price"
    t.integer  "stock"
    t.boolean  "prod_valid",     :default => true
    t.boolean  "prod_qualified", :default => true
    t.boolean  "network_plan",   :default => false
    t.float    "comm_porc",      :default => 100.0
    t.boolean  "visible"
    t.text     "more"
    t.decimal  "weight",         :default => 0.0,   :null => false
    t.integer  "length",         :default => 0,     :null => false
    t.integer  "width",          :default => 0,     :null => false
    t.integer  "height",         :default => 0,     :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "buy",            :default => true
  end

  create_table "prospectos", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.integer  "sponsor_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "testes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.integer  "person_type_id"
    t.integer  "account_type_id"
    t.boolean  "network_setup",   :default => false
    t.string   "name",                               :null => false
    t.string   "password"
    t.integer  "status",          :default => 0
    t.date     "expire_date"
    t.string   "token"
    t.boolean  "blocked",         :default => false, :null => false
    t.datetime "blocked_at"
    t.string   "person_nick"
    t.string   "company_nick"
    t.string   "person_name"
    t.string   "company_name"
    t.string   "respons_name"
    t.string   "respons_cpf"
    t.string   "cpf"
    t.string   "cnpj"
    t.string   "rg"
    t.date     "birth"
    t.string   "birthday"
    t.integer  "gender_id",       :default => 0
    t.string   "email1"
    t.string   "email2"
    t.string   "phone"
    t.string   "mobile"
    t.boolean  "admin",           :default => false
    t.integer  "sponsor_id"
    t.integer  "sponsored_count", :default => 0
    t.string   "redir_from"
    t.integer  "comes_from_id"
    t.integer  "network_plan_id", :default => 0
    t.string   "extra"
    t.boolean  "fake",            :default => false
    t.boolean  "ignore_rules",    :default => false
    t.datetime "last_login"
    t.text     "properties"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "users", ["id", "name", "blocked", "status"], :name => "index_users_on_id_and_name_and_blocked_and_status"
  add_index "users", ["name"], :name => "index_users_on_name", :unique => true

  create_table "visits", :force => true do |t|
    t.integer  "user_id"
    t.integer  "count",      :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "visits", ["user_id"], :name => "index_visits_on_user_id"

end
