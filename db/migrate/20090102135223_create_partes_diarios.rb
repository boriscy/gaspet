class CreatePartesDiarios < ActiveRecord::Migration
  def self.up
    create_table :partes_diarios do |t|
      t.integer :campo_id
      t.date :fecha
      # Liquidos
      t.decimal :produccion_liquidos, :precision => 14, :scale => 2
      t.decimal :petroleo, :precision => 14, :scale => 2
      t.decimal :condensado, :precision => 14, :scale => 2
      t.decimal :densidad_api, :precision => 14, :scale => 2
      t.decimal :gasolina, :precision => 14, :scale => 2
      t.decimal :agua, :precision => 14, :scale => 2
      t.decimal :petroleo_entregado, :precision => 14, :scale => 2
      # Gas
      t.decimal :produccion_gas, :precision => 14, :scale => 2
      t.decimal :inyeccion, :precision => 14, :scale => 2
      t.decimal :entregado_gasoducto, :precision => 14, :scale => 2
      t.decimal :entregado_proceso, :precision => 14, :scale => 2
      t.decimal :licuables, :precision => 14, :scale => 2
      t.decimal :glp_mc, :precision => 14, :scale => 2
      t.decimal :combustible, :precision => 14, :scale => 2
      t.decimal :residual, :precision => 14, :scale => 2
      t.decimal :quemado, :precision => 14, :scale => 2
      t.decimal :co2, :precision => 14, :scale => 2
      # Saldos
      t.decimal :saldo_petroleo, :precision => 14, :scale => 2
      t.decimal :saldo_glp, :precision => 14, :scale => 2

      t.timestamps
    end

    add_index :partes_diarios, [:fecha, :campo_id], :unique => true
  end

  def self.down
    drop_table :partes_diarios
  end
end
