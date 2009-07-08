class CreateAsignaciones < ActiveRecord::Migration
  def self.up
    create_table :asignaciones do |t|
      t.integer :campo_id
      t.integer :volumen_asignado_id
      t.decimal :porcentaje, :precision => 2, :scale => 2
      t.decimal :volumen, :precision => 14, :scale => 2
      t.decimal :saldo_mes, :precision => 14, :scale => 2
      t.decimal :volumen_ypfb,:precision => 14, :scale => 2
      t.timestamps
    end
    add_index :asignaciones, :campo_id
    add_index :asignaciones, :volumen_asignado_id
  end

  def self.down
    drop_table :asignaciones
  end
end
