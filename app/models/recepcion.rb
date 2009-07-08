class Recepcion < ActiveRecord::Base
  belongs_to :producto
  belongs_to :zona_comercial
  named_scope :ultimos, :joins => {:zona_comercial => {:distrito => {}}, :producto => {}},
    :order => "zonas_comerciales.id, recepciones.producto_id ASC",
    :conditions => ["fecha = ?", self.maximum("fecha")]
  named_scope :lista, :joins => {:zona_comercial => {:distrito => {}}, :producto => {}},
    :order => "zonas_comerciales.id, recepciones.producto_id ASC"
  validates_uniqueness_of :fecha, :scope => [:zona_comercial_id, :producto_id]
  validates_presence_of :fecha, :zona_comercial_id, :producto_id

  
  # Realiza la imporatción de un archivo excel y retorna un array 
  # con objetos Recepcion para poder desplegar en un formulario
  # file es una referencia a un archivo que se ingreso por le método POST
  # en un formulario multipart
  def self.importar(file)
    excel = ImportExcel.new(file).file

    zonas = ZonaComercial.all()
    recepciones = []
    ge = Producto.find_by_abreviacion("GE")
    diesel = Producto.find_by_abreviacion("DO")
    campos = [:programado, :comercializado]

    (11..38).each do |i|
      dato = nil
      dato = excel.cell('B', i)
      zona = zonas.detect{|v| v.nombre.downcase == dato.squish.downcase }
      unless dato.squish.downcase == "subtotal" || dato.squish.downcase == "total" || /\*/ =~ dato
        rep = Recepcion.new(:zona_comercial_id => (zona.id unless zona.nil?), :producto_id => ge.id,
            :programado => excel.cell('G', i), :comercializado => excel.cell('H', i), :cumplimiento => excel.cell('I', i))
        rep.errors.add(:zona_comercial_id, "La zona #{dato} no existe") if zona.nil?
        recepciones.push(rep)

        rep = Recepcion.new(:zona_comercial_id => (zona.id unless zona.nil?), :producto_id => diesel.id,
            :programado => excel.cell('R', i), :comercializado => excel.cell('S', i), :cumplimiento => excel.cell('T', i))
        rep.errors.add(:zona_comercial_id, "La zona #{dato} no existe") if zona.nil?
        recepciones.push(rep)
      end
    end

    return recepciones
  end
end
