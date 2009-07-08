class CreateAreas < ActiveRecord::Migration
  def self.up
    create_table :areas do |t|
      t.integer :contrato_id
      t.string :nombre
      t.string :codigo, :limit => 20

      t.timestamps
    end
    # add_index :areas, :contrato_id
  end

  def self.down
    drop_table :areas
  end
end
