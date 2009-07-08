class Distrito < ActiveRecord::Base
  has_many :zonas_comerciales, :class_name => "ZonaComercial"
  validates_presence_of :nombre
end
