class CreateReportses < ActiveRecord::Migration
  def self.up
    create_table :reportses do |t|
      t.date :fecha
      t.text :noticias
      t.text :produccion
      t.text :precios
      t.text :recepciones
      t.text :saldos

      t.timestamps
    end
  end

  def self.down
    drop_table :reportses
  end
end
