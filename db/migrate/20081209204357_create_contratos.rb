class CreateContratos < ActiveRecord::Migration
  def self.up
    create_table :contratos do |t|
      t.integer :empresa_id
      t.string :nombre
      t.string :codigo, :limit => 20
      t.date :fecha

      t.timestamps
    end
  end

  def self.down
    drop_table :contratos
  end
end
