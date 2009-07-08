class CreateTipoZonas < ActiveRecord::Migration
  def self.up
    create_table :tipo_zonas do |t|
      t.string :nombre, :limit => 30, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :tipo_zonas
  end
end
