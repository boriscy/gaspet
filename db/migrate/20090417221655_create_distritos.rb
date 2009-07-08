class CreateDistritos < ActiveRecord::Migration
  def self.up
    create_table :distritos do |t|
      t.string :nombre

      t.timestamps
    end
  end

  def self.down
    drop_table :distritos
  end
end
