class Departamento < ActiveRecord::Base
  has_many :campos
  acts_as_reportable :except => [:created_at, :updated_at]
  validates_presence_of :nombre, :abreviacion
  validates_uniqueness_of :nombre
  validates_uniqueness_of :abreviacion
end
