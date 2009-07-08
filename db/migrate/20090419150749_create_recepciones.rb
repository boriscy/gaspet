class CreateRecepciones < ActiveRecord::Migration
  def self.up
    create_table :recepciones do |t|
      t.integer :zona_comercial_id
      t.integer :producto_id
      t.date :fecha
      t.decimal :programado, :precision => 14, :scale => 2
      t.decimal :comercializado, :precision => 14, :scale => 2
      t.decimal :cumplimiento, :precision => 3, :scale => 2
      t.boolean :importado, :default => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :recepciones
  end
end
