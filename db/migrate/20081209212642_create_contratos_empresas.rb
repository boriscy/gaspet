class CreateContratosEmpresas < ActiveRecord::Migration
  def self.up
    create_table :contratos_empresas, :id => false do |t|
      t.integer :contrato_id
      t.integer :empresa_id
    end
    add_index :contratos_empresas, :contrato_id
    add_index :contratos_empresas, :empresa_id
  end

  def self.down
    drop_table :contratos_empresas
  end
end
