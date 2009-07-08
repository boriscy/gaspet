class ArchivosCategorias < ActiveRecord::Migration
 def self.up
    create_table :archivos_categorias, :id => false do |t|
      t.integer :archivo_id
      t.integer :categoria_id
    end

    add_index :archivos_categorias, :archivo_id
    add_index :archivos_categorias, :categoria_id
  end

  def self.down
    drop_table :archivos_categorias
  end
end
