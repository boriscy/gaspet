class ZonaComercial < ActiveRecord::Base
  belongs_to :distrito
  has_many :productos, :through => :recepciones
  validates_presence_of :distrito_id, :nombre

  def to_param
    nombre
  end
end
