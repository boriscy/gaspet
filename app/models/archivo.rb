class Archivo < ActiveRecord::Base
  has_and_belongs_to_many :categorias
  belongs_to :zona

  def to_s
    nombre
  end
end
