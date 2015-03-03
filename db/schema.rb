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

ActiveRecord::Schema.define(version: 20150303223408) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "air_qualities", force: :cascade do |t|
    t.text     "title"
    t.text     "link"
    t.text     "description"
    t.integer  "reporte"
    t.text     "imagenclima"
    t.integer  "gradosclima"
    t.text     "calairuser"
    t.text     "colairuser"
    t.text     "iconairuser"
    t.text     "colairno"
    t.text     "calairno"
    t.text     "colairne"
    t.text     "calairne"
    t.text     "colairce"
    t.text     "calairce"
    t.text     "colairso"
    t.text     "calairso"
    t.text     "colairse"
    t.text     "calairse"
    t.text     "imgiuvuser"
    t.text     "caliuvuser"
    t.text     "coliuvuser"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "bicycle_stations", force: :cascade do |t|
    t.integer  "id_station"
    t.text     "name"
    t.text     "address"
    t.text     "address_number"
    t.text     "zip_code"
    t.text     "district_code"
    t.text     "nearby_stations"
    t.text     "location"
    t.text     "station_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "status"
    t.string   "bikes"
    t.string   "slots"
  end

  create_table "infractions", force: :cascade do |t|
    t.text     "folio"
    t.text     "fecha"
    t.text     "situacion"
    t.text     "motivo"
    t.text     "fundamento"
    t.text     "sancion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "id_vehicle"
  end

  create_table "saves", force: :cascade do |t|
    t.text     "access_token"
    t.datetime "fecha"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "taxis", force: :cascade do |t|
    t.text     "code"
    t.text     "placa"
    t.text     "marca_modelo"
    t.text     "status"
    t.datetime "fecha"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "taxis", ["placa"], name: "index_taxis_on_placa", unique: true, using: :btree

  create_table "vehicles", force: :cascade do |t|
    t.text     "placa"
    t.text     "fechas_adeudo_tenecia"
    t.text     "tiene_adeudo_tenencia"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "verifications", force: :cascade do |t|
    t.text     "vin"
    t.text     "marca"
    t.text     "submarca"
    t.text     "modelo"
    t.text     "combustible"
    t.text     "certificado"
    t.text     "cancelado"
    t.text     "vigencia"
    t.text     "verificentro"
    t.text     "linea"
    t.text     "fecha_verificacion"
    t.text     "hora_verificacion"
    t.text     "resultado"
    t.text     "causa_rechazo"
    t.text     "equipo_gdf"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "id_vehicle"
  end

end
