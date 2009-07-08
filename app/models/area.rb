class Area < ActiveRecord::Base
  acts_as_reportable
  belongs_to :contrato
  has_and_belongs_to_many :contratos
  has_many :campos

  def to_s
    nombre
  end
end
