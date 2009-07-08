class Producto < ActiveRecord::Base
  has_many :zonas_comerciales, :through => :recepciones

  validates_presence_of :nombre, :abreviacion
  validates_uniqueness_of :abreviacion

end
