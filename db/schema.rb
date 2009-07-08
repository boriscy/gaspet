# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090419151404) do

  create_table "archivos", :force => true do |t|
    t.integer  "zona_id"
    t.string   "nombre"
    t.string   "archivo"
    t.date     "fecha"
    t.integer  "dimension"
    t.string   "extension",  :limit => 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "archivos", ["nombre"], :name => "index_archivos_on_nombre"
  add_index "archivos", ["zona_id"], :name => "index_archivos_on_zona_id"

  create_table "archivos_categorias", :id => false, :force => true do |t|
    t.integer "archivo_id"
    t.integer "categoria_id"
  end

  add_index "archivos_categorias", ["archivo_id"], :name => "index_archivos_categorias_on_archivo_id"
  add_index "archivos_categorias", ["categoria_id"], :name => "index_archivos_categorias_on_categoria_id"

  create_table "areas", :force => true do |t|
    t.integer  "contrato_id"
    t.string   "nombre"
    t.string   "codigo",      :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "asignaciones", :force => true do |t|
    t.integer  "campo_id"
    t.integer  "volumen_asignado_id"
    t.decimal  "porcentaje",          :precision => 2,  :scale => 2
    t.decimal  "volumen",             :precision => 14, :scale => 2
    t.decimal  "saldo_mes",           :precision => 14, :scale => 2
    t.decimal  "volumen_ypfb",        :precision => 14, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "asignaciones", ["campo_id"], :name => "index_asignaciones_on_campo_id"
  add_index "asignaciones", ["volumen_asignado_id"], :name => "index_asignaciones_on_volumen_asignado_id"

  create_table "campos", :force => true do |t|
    t.string   "nombre",                        :null => false
    t.integer  "area_id"
    t.integer  "departamento_id"
    t.string   "codigo",          :limit => 10, :null => false
    t.string   "sinonimo",        :limit => 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "campos", ["area_id"], :name => "index_campos_on_area_id"

  create_table "campos_zonas", :id => false, :force => true do |t|
    t.integer "campo_id"
    t.integer "zona_id"
  end

  add_index "campos_zonas", ["campo_id"], :name => "index_campos_zonas_on_campo_id"
  add_index "campos_zonas", ["zona_id"], :name => "index_campos_zonas_on_zona_id"

  create_table "categorias", :force => true do |t|
    t.integer  "parent_id"
    t.string   "nombre"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categorias", ["parent_id"], :name => "index_categorias_on_parent_id"

  create_table "contratos", :force => true do |t|
    t.integer  "empresa_id"
    t.string   "nombre"
    t.string   "codigo",     :limit => 20
    t.date     "fecha"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contratos_empresas", :id => false, :force => true do |t|
    t.integer "contrato_id"
    t.integer "empresa_id"
  end

  add_index "contratos_empresas", ["contrato_id"], :name => "index_contratos_empresas_on_contrato_id"
  add_index "contratos_empresas", ["empresa_id"], :name => "index_contratos_empresas_on_empresa_id"

  create_table "departamentos", :force => true do |t|
    t.string   "nombre",      :limit => 20
    t.string   "abreviacion", :limit => 5
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "distritos", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "empresas", :force => true do |t|
    t.string   "nombre"
    t.string   "sinonimo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menus", :force => true do |t|
    t.integer  "parent_id"
    t.string   "nombre"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "vinculo"
    t.string   "icono"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partes_diarios", :force => true do |t|
    t.integer  "campo_id"
    t.date     "fecha"
    t.decimal  "produccion_liquidos", :precision => 14, :scale => 2
    t.decimal  "petroleo",            :precision => 14, :scale => 2
    t.decimal  "condensado",          :precision => 14, :scale => 2
    t.decimal  "densidad_api",        :precision => 14, :scale => 2
    t.decimal  "gasolina",            :precision => 14, :scale => 2
    t.decimal  "agua",                :precision => 14, :scale => 2
    t.decimal  "petroleo_entregado",  :precision => 14, :scale => 2
    t.decimal  "produccion_gas",      :precision => 14, :scale => 2
    t.decimal  "inyeccion",           :precision => 14, :scale => 2
    t.decimal  "entregado_gasoducto", :precision => 14, :scale => 2
    t.decimal  "entregado_proceso",   :precision => 14, :scale => 2
    t.decimal  "licuables",           :precision => 14, :scale => 2
    t.decimal  "glp_mc",              :precision => 14, :scale => 2
    t.decimal  "combustible",         :precision => 14, :scale => 2
    t.decimal  "residual",            :precision => 14, :scale => 2
    t.decimal  "quemado",             :precision => 14, :scale => 2
    t.decimal  "co2",                 :precision => 14, :scale => 2
    t.decimal  "saldo_petroleo",      :precision => 14, :scale => 2
    t.decimal  "saldo_glp",           :precision => 14, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "partes_diarios", ["fecha", "campo_id"], :name => "index_partes_diarios_on_fecha_and_campo_id", :unique => true

  create_table "precios", :force => true do |t|
    t.date     "fecha"
    t.decimal  "henry_hub",  :precision => 8, :scale => 2
    t.decimal  "wti",        :precision => 8, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "productos", :force => true do |t|
    t.string   "nombre",      :limit => 50
    t.string   "abreviacion", :limit => 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pruebas", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recepciones", :force => true do |t|
    t.integer  "zona_comercial_id"
    t.integer  "producto_id"
    t.date     "fecha"
    t.decimal  "programado",        :precision => 14, :scale => 2
    t.decimal  "comercializado",    :precision => 14, :scale => 2
    t.decimal  "cumplimiento",      :precision => 3,  :scale => 2
    t.boolean  "importado",                                        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reportses", :force => true do |t|
    t.date     "fecha"
    t.text     "noticias"
    t.text     "produccion"
    t.text     "precios"
    t.text     "recepciones"
    t.text     "saldos"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "saldos", :force => true do |t|
    t.date     "fecha"
    t.text     "datos"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipo_zonas", :force => true do |t|
    t.string   "nombre",     :limit => 30, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "view_campos_detalles", :id => false, :force => true do |t|
    t.string  "empresa"
    t.string  "area"
    t.string  "campo",                                        :null => false
    t.string  "codigo",          :limit => 10,                :null => false
    t.integer "campo_id",                      :default => 0, :null => false
    t.integer "empresa_id",                    :default => 0, :null => false
    t.integer "area_id",                       :default => 0, :null => false
    t.integer "departamento_id"
  end

  create_table "volumenes_asignados", :force => true do |t|
    t.date     "fecha"
    t.decimal  "volumen_total", :precision => 14, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "volumenes_asignados", ["fecha"], :name => "index_volumenes_asignados_on_fecha", :unique => true

  create_table "zonas", :force => true do |t|
    t.string   "nombre",       :limit => 100, :null => false
    t.integer  "parent_id"
    t.integer  "tipo_zona_id",                :null => false
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "zonas_comerciales", :force => true do |t|
    t.integer  "distrito_id"
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
