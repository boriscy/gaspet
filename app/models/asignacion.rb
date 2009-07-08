class Asignacion < ActiveRecord::Base
  acts_as_reportable
  belongs_to :volumen_asignado
  # Validaciones
  validates_presence_of :campo_id, :volumen_asignado_id
  validates_numericality_of :porcentaje, :greater_than => 0, :less_than_or_equal_to => 1
  validates_numericality_of :volumen, :less_than => 100
  validates_numericality_of :volumen_ypfb, :greater_than_or_equal_to => 0, :less_than => 10
  validates_numericality_of :saldo_mes
  
  # Fila máxima y fila minima para realizar la importación de datos de hojas Excel YPFB
  @@minrow = 7
  @@maxrow = 83
  # Hoja por defecto para realizar la importación de hojas excel YPFB
  @@defsheet = 0

  def prueba()
    # array.detect{|v| val =~ /#{v[:nombre]}/}
  end

  # Realiza un query que enlaza varias tablas
  def self.listado()
    Campo.find(:all, :include => [:area =>[:contrato => [:empresa]]] , :order => "contratos.codigo, areas.nombre, campos.nombre ASC")
  end

  # Realiza el query a listado y prepara un array que puede ser usado para presentar una tabla
  # @return array
  def self.listado_array()
    ret = []
    lista = self.listado()
    #Volumen.asignado
    lista.each do |v|
      ret.push({:operador => v.area.contrato.empresa.nombre,:area => v.area.nombre, :contrato => v.area.contrato.codigo, 
          :campo => v.nombre, :campo_id => v.id, :codigo => v.codigo, :porcentaje => 0, :volumen => 0, :volumen_ypfb => 0, :saldo_mes => 0})
    end
    ret
  end

  # Transaccion que almacen los datos del cliente tanto del Maestro como del detalle
  # @param Hash params Parametros pasados desde el controlador, el cual pasa el POST realizado
  def self.guardar_datos(params)
    res = {:success => true, :asignacion => {:errors => [] }, :volumen_asignado => {:errors =>{} } }
    
    VolumenAsignado.transaction do |vol| 
      s = VolumenAsignado.new(:fecha => params[:fecha], :volumen_total => params[:volumen_total])
      campos = [:campo_id, :volumen, :volumen_ypfb, :porcentaje, :saldo_mes]

      begin
        s.save!
      rescue
        res[:success] = false
        s.errors.each{|k, error| res[:volumen_asignado][:errors][k] = error}
      end
      if res[:success]
        params[:asignacion].each do |k, asig|
          nuevo = {:volumen_asignado_id => s.id}
          campos.each{|v| nuevo[v] = asig[v]}
#          s2 = self.new(:volumen_asignado_id => s.id, :campo_id => asig[:campo_id], :volumen => asig[:volumen],
#          :volumen_ypfb => asig[:volumen_ypfb], :porcentaje => asig[:porcentaje], :saldo_mes => 0) # Mejorar la parte del saldo
          s2 = self.new(nuevo)
          begin
            s2.save!
          rescue
            #res[:asignacion][:errors][asig[:campo_id]] = {}
            #s2.errors.each { |k, error| res[:asignacion][:errors][asig[:campo_id]][k] = error }
            #hash = {:campo_id => asig[:campo_id]}
            errors = {}
            s2.errors.each { |k, error| errors[k] = error }
            errors[:campo_id] = asig[:campo_id]
            #s2.errors.each { |k, error| hash[k] = error }
            res[:asignacion][:errors].push(errors);
            #res[:asignacion][:errors][asig[:campo_id]] = s2.errors
            res[:success] = false
          end
        end
      end
        
      # En caso de error hacer rollback
      raise ActiveRecord::Rollback, "Error de transacción Asignacion, VolumenAsignado!" unless res[:success]
      res[:errors] = VolumenAsignado.errors
    end
    res
  end

  # Permite realizar la importacion de datos, primero guarda el archivo subido por el servidor y luego
  # luego
  # @param string file Archivo el cual se subira al servidor y del cual se leen los datos
  # @return Excel retorna el un puntero  que permite leer los datos del archivo al cual se quiere importar los datos
  def self.import_sheet(file, defsheet = @@defsheet)
    require 'roo'
    filename = file.original_filename
    ext = File.extname(filename).downcase

    path = "public/temp_files/#{Time.now.to_f}#{ext}"
    File.open(path, "wb") { |f| f.write(file.read) }
    # Verificacion de la extencion del archivo
    case ext
      when ".xls"
        imp = Excel.new(path)
      when ".xlsx"
        imp = Excelx.new(path)
      when ".ods"
        imp = Openoffice.new(path)
      else
        return false
    end
    # Modificar de acuerdo a los requeriemientos
    imp.default_sheet = imp.sheets[defsheet]
    File.delete(path);
    return imp
  end

  # Realiza la importación de datos del mercado interno
  # @param string file Archivo el cual se subira al servidor y del cual se leen los datos
  def self.importar_ypfb_merc_int(file)
    imp = import_sheet(file)
    ret= []
    # No retorno nada el archivo es invalido
    if imp == false
      return ret
    end
    
    @@minrow.upto(@@maxrow) do |i|
      ret.push({:campo => imp.cell(i,'D'), :volumen_ypfb => imp.cell(i,'E') } ) if !imp.cell(i, 'E').nil? && imp.cell(i, 'E') > 0
    end
    ret
  end

  def prueba *args
    #args.each{|k,v| puts "#{k}: #{v}:::::"}
    puts args.length
  end
#  def self.jeje
#    return 'jeje'
#  end
#  def self.je(val)
#    puts jeje()+val
#  end
end
