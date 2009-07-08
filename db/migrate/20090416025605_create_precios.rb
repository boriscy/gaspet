class CreatePrecios < ActiveRecord::Migration
  def self.up
    create_table :precios do |t|
      t.date :fecha
      t.decimal :henry_hub, :precision => 8, :scale => 2
      t.decimal :wti, :precision => 8, :scale => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :precios
  end
end
