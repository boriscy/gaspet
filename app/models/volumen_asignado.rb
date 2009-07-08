class VolumenAsignado < ActiveRecord::Base
  has_many :asignaciones, :dependent => :destroy
  validates_presence_of :volumen_total, :fecha
  validates_numericality_of :volumen_total, :greater_than => 0
end
