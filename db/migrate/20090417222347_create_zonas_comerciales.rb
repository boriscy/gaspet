class CreateZonasComerciales < ActiveRecord::Migration
  def self.up
    create_table :zonas_comerciales do |t|
      t.integer :distrito_id
      t.string :nombre

      t.timestamps
    end
  end

  def self.down
    drop_table :zonas_comerciales
  end
end
