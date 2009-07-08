class CreateZonas < ActiveRecord::Migration
  def self.up
    create_table :zonas do |t|
      t.string :nombre, :limit => 100, :null => false
      t.integer :parent_id
      t.integer :tipo_zona_id, :null => false
      t.integer :lft
      t.integer :rgt

      t.timestamps
    end

  end

  def self.down
    drop_table :zonas
  end
end
