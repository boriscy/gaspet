class Zona < ActiveRecord::Base
  #acts_as_nested_set
  belongs_to :tipo_zona
  has_many :archivos
  has_and_belongs_to_many :campos

  def to_s
    nombre
  end
end
