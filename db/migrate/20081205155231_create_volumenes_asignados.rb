class CreateVolumenesAsignados < ActiveRecord::Migration
  def self.up
    create_table :volumenes_asignados do |t|
      t.date :fecha
      t.decimal :volumen_total, :precision => 14, :scale => 2

      t.timestamps
    end
    add_index :volumenes_asignados, :fecha, :unique => true
  end

  def self.down
    drop_table :volumenes_asignados
  end
end
