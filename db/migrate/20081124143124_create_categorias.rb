class CreateCategorias < ActiveRecord::Migration
  def self.up
    create_table :categorias do |t|
      t.integer :parent_id
      t.string :nombre
      t.integer :lft
      t.integer :rgt

      t.timestamps
    end

    add_index :categorias, :parent_id
  end

  def self.down
    drop_table :categorias
  end
end
