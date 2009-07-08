class Campo < ActiveRecord::Base
  acts_as_reportable :except => [:created_at, :updated_at]
  has_and_belongs_to_many :zonas
  belongs_to :area
  belongs_to :departamento
  validates_presence_of :nombre, :area_id, :codigo, :departamento_id
  validates_uniqueness_of :codigo
  validates_uniqueness_of :nombre
  validates_associated :area
  validates_associated :departamento

  before_save :mayuscula

  # Para salvar => Campo.first.zonas => Zona.find(1)
  # Para actualiza => Campo.first.update_attributes :zona_ids => [1,2]
  # Para salvar:
  # @campo = Campo.first
  # @zonas = Zona.find(1,2,3)
  # @campo.zonas << @zonas
  def to_s
    codigo
  end

  def mayuscula
    codigo.upcase!
    nombre.upcase!
  end
end
