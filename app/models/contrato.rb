class Contrato < ActiveRecord::Base
  acts_as_reportable
  has_many :areas
  has_and_belongs_to_many :areas
  belongs_to :empresa

  def to_s
    codigo
  end
end
