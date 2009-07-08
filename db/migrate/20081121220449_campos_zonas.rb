class CamposZonas < ActiveRecord::Migration
  def self.up
    create_table :campos_zonas, :id => false do |t|
      t.integer :campo_id
      t.integer :zona_id
    end

    add_index :campos_zonas, :campo_id
    add_index :campos_zonas, [:zona_id]
  end

  def self.down
    drop_table :campos_zonas
  end
end
