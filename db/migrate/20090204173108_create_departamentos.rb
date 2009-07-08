class CreateDepartamentos < ActiveRecord::Migration
  def self.up
    create_table :departamentos do |t|
      t.string :nombre, :limit => 20
      t.string :abreviacion, :limit => 5
      t.timestamps
    end
  end

  def self.down
    drop_table :departamentos
  end
end
