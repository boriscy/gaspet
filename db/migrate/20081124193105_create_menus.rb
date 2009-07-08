class CreateMenus < ActiveRecord::Migration
  def self.up
    create_table :menus do |t|
      t.integer :parent_id
      t.string :nombre
      t.integer :lft
      t.integer :rgt
      t.string :vinculo
      t.string :icono

      t.timestamps
    end
  end

  def self.down
    drop_table :menus
  end
end
