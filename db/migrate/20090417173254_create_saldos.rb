class CreateSaldos < ActiveRecord::Migration
  def self.up
    create_table :saldos do |t|
      t.date :fecha
      t.text :datos

      t.timestamps
    end
  end

  def self.down
    drop_table :saldos
  end
end
