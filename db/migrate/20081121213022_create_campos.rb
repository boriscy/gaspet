class CreateCampos < ActiveRecord::Migration
  def self.up
    create_table :campos do |t|
      t.string :nombre, :null => false
      t.integer :area_id
      t.integer :departamento_id
      t.string :codigo, :limit => 10, :null => false
      t.string :sinonimo, :limit => 30

      t.timestamps
    end
    add_index :campos, :area_id
  end

  def self.down
    drop_table :campos
  end
end
