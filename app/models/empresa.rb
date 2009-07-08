class Empresa < ActiveRecord::Base
  acts_as_reportable
  has_many :contratos

  def to_s
    nombre
  end
end
