class CreateArchivos < ActiveRecord::Migration
  def self.up
    create_table :archivos do |t|
      t.integer :zona_id
      t.string :nombre
      t.string :archivo
      t.date :fecha
      t.integer :dimension
      t.string :extension, :limit => 10

      t.timestamps
    end
    add_index :archivos, :zona_id
    add_index :archivos, :nombre
  end

  def self.down
    drop_table :archivos
  end
end
