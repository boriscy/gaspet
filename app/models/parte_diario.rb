class ParteDiario < ActiveRecord::Base
  belongs_to :campo
  validates_presence_of :campo_id, :fecha
  validates_uniqueness_of :campo_id, :scope => :fecha
  acts_as_reportable :except => [:id, :created_at, :updated_at]
  # named_scope :ultimo_parte_diario, :select => "MAX(fecha) as fecha"


  # Realiza la busqueda por fecha y retorna un array si no hay ningun registro retorna un array con todos los campos (Campo.all)
  # @param date fecha
  # @return array
  def self.buscar_por_fecha(fecha)
    ret = []
    lista = []
    ParteDiario.columns.each{|v| lista.push(v.name.to_sym) unless v.name == "fecha" || v.name == "updated_at" || v.name == "created_at"}
    tmp = {}

    pd = ParteDiario.find(:all, :conditions => ["fecha = ?", fecha], :include => [:campo], :order => 'campos.nombre ASC')

    if pd.length > 0
      pd.each do |v|
        tmp = {:campo => v.campo.nombre}
        lista.each{|col| tmp[col] = v.send(col)}
        ret.push(tmp)
      end
    else
      campos = Campo.find(:all)
      campos.each do |v|
        tmp = {:campo => v.nombre, :campo_id => v.id}
        lista.each do |col|
          tmp[col] = 0.0 unless col == :campo_id
        end
        ret.push(tmp)
      end
    end
      
    ret
  end


  # Importa los datos de un archivo de Excel, Excel 2007 o OpneOffice
  # nombre del archivo a importar
  def self.importar(file, fecha)
    archivo = Asignacion.import_sheet(file, 0)
    ret = {:imported => [], :original => [], :errors => []}
    cols = cols()
    cols.delete("fecha")
    cols.delete("campo_id")
    cols.delete("id")

    # fecha = archivo.cell(4, 'A').gsub(/\//, '-')
    campos = Campo.find(:all)
    fecha2 = fecha.gsub(/\A^(\d\d)-(\d\d)-(\d{4})$\Z/, '\3-\2-\1')
    partes = find :all, :conditions => ["fecha=?", fecha2]

    if partes.size <= 0
      9.upto(90) do |fila|
        if !archivo.cell(fila,'B').nil? && archivo.cell(fila,'C').class.to_s == 'Float' && !archivo.cell(fila,'B') != 'PLANTA'
          unless archivo.cell(fila,'B') == ''
            i = 0
            campo = campos.detect{|v| v.nombre == archivo.cell(fila, 'B').squish || v.sinonimo == archivo.cell(fila, 'B').squish}
            tmp = {:campo_id => (campo.id unless campo.nil?), :fecha => fecha}
            # Hoja original
            tmpOrig = [true, archivo.cell(fila, "A"), archivo.cell(fila, "B")]
            ("C".."U").each do |rango|
              tmp[cols[i]] = archivo.cell(fila, rango).to_f.round(2)
              tmpOrig.push(archivo.cell(fila, rango))
              i+=1
            end
            parte = self.new(tmp)
            if parte.campo_id.nil?
              parte.errors.add(:campo_id, "El campo #{archivo.cell(fila, 'B')} no existe")
              ret[:errors].push("El campo #{archivo.cell(fila, 'B')} no existe")
            end
            ret[:imported].push(parte)
            ret[:original].push(tmpOrig)
          end
        else
          tmpOrig = [false]
          ("A".."U").each do |rango|
            tmpOrig.push(archivo.cell(fila, rango))
          end
          ret[:original].push(tmpOrig)
        end
      end
    else
      ret[:errors].push("El parte diario de fecha #{fecha} ya existe en la Base de Datos")
    end

    ret
  end

  def self.cols
    cols = [] # Columnas de la tabla
    ParteDiario.columns.each{|v| cols.push(v.name)  unless v.name == 'created_at' || v.name == 'updated_at'}
    cols
  end

  def self.crear(params)
    cols = cols()
    res = {:success => true, :data => []}
    self.transaction do |tran|
      # Almacenamiento de las transacciones
      params.each do |k, parte|
        parte_diario = self.new(parte)
        begin
          parte_diario.save!
        rescue
          res[:success] = nil
        end
        res[:data].push(parte_diario)
      end
      # En caso de error
      raise ActiveRecord::Rollback, "Error de transacción ParteDiario!" unless res[:success]
    end
    res
  end

  # Genera el reporte a partir de la fecha incial, fecha final, operación
  #
  def self.reporte(fecha_ini, fecha_fin, op)
    case(op)
    when "SUM"
      op = "SUM"
    when "AVG"
      op = "AVG"
    else
      op = "SUM"
    end
    columns = []
    cols.each{|v| columns.push(v) unless (v == 'id' || v == 'campo_id' || v == 'fecha')}
    j = columns.map{|v| "#{v=='densidad_api' ? 'AVG': op}(pd.#{v}) AS #{v}"}.join(", ")
    query = "SELECT v.empresa AS empresa, v.campo AS campo, #{j}  FROM
    partes_diarios pd JOIN view_campos_detalles v ON (pd.campo_id = v.campo_id)
    WHERE pd.fecha BETWEEN ? AND ? GROUP BY pd.campo_id ORDER BY v.campo"
    #report_table_by_sql(query, :only => [:empresa, :campo])
    columns = ["empresa","campo"].concat(columns)
    t = report_table_by_sql([query, fecha_ini, fecha_fin])
    # En caso de que no haya devuelto 0 registros
    if t.length > 0
      t.reorder(columns)
      t.rename_columns(columns, columns.map(&:humanize))
    end
    t
  end

  # Guarda los datos mediante una transación
  def self.guardar(params)
    cols = cols()
    res = {:errors => [], :success => true}
    self.transaction do |parte|

      params.each do |k, val|
        temp = {:id => val['id'].to_i}
        cols.each{|v| temp[v] = val[v] }
        temp[:fecha] = params[:fecha]

        if temp[:id] > 0
          pd = self.update_attributes(temp)
        else
          pd = self.new(temp)
        end

        begin
          pd.save!
        rescue
          errors = {}
          pd.errors.each { |key, error|
            errors[key] = error
          }
          res[:errors].push(errors)
          res[:success] = false
        end
      end
      
      raise ActiveRecord::Rollback, "Error de transacción ParteDiario!" unless res[:success]
    end
    res
  end

  # Define la consulta SQL y la logica para la presentacion de
  # de los reportes diarios, por defecto la fecha es la actual.
  #
  def self.reporte_diario(fecha = Date.today)
    sql = ["SELECT fecha, produccion_liquidos AS produccion
          FROM partes_diarios
          WHERE fecha = ?", fecha.to_date]

    self.find_by_sql(sql)
  end


  # Realiza la consulta para extraer la produccion total, entrega
  # totales por mes de gas
  # @param fecha date la fecha del mes deseado
  def self.produccion_mensual_gas(fecha)
    sql = ["SELECT partes_diarios.fecha,
       SUM(partes_diarios.produccion_gas) AS produccion,
       SUM(partes_diarios.entregado_gasoducto) AS entregado
       FROM partes_diarios
       WHERE partes_diarios.fecha BETWEEN ? AND ?
       GROUP BY partes_diarios.fecha", fecha.beginning_of_month.to_date, fecha.end_of_month.to_date]
    self.find_by_sql(sql)
  end


  # Realiza la consulta para extraer la produccion total, entrega
  # totales por mes de liquidos
  # @param fecha date la fecha del mes deseado
  def self.produccion_mensual_liquidos(fecha)
    sql = ["SELECT partes_diarios.fecha,
       SUM(partes_diarios.produccion_liquidos) AS produccion,
       SUM(partes_diarios.petroleo_entregado) AS entregado
       FROM partes_diarios
       WHERE partes_diarios.fecha BETWEEN ? AND ?
       GROUP BY partes_diarios.fecha", fecha.beginning_of_month.to_date, fecha.end_of_month.to_date]
    self.find_by_sql(sql)
  end

  # Retorna el parte Diario de la fecha indicada, en caso de que ho haya la fecha selecciona la ultima fecha
  def self.parte_diario(fecha = nil)
    fecha = ParteDiario.first(:select => "MAX(fecha) as fecha").fecha if fecha.nil?
    ParteDiario.all(:conditions => ["fecha = ?", fecha], :include => :campo, :order => "campos.nombre ASC")
  end
  # p = ParteDiario.all(:select => "partes_diarios.*, vcd.*, vcd.campo as campo_n", :conditions => ["fecha = ?", "2009-04-02"],
  #  :joins => "JOIN view_campos_detalles vcd ON partes_diarios.campo_id = vcd.campo_id", :order => "vcd.empresa ASC")


  # Retorna un array con los totales por fecha de distintos productos
  def self.total_por_fecha(fecha_ini = nil, fecha_fin = nil)
    if fecha_ini.nil? && fecha_fin.nil?
      fecha_fin = ParteDiario.maximum(:fecha)
      fecha_ini = fecha_fin - 30.days
    elsif fecha_fin.nil?
      fecha_fin = fecha_ini - 30.days
    end
    
    sql = "SELECT fecha, SUM(petroleo) AS petroleo, SUM(condensado) AS condensado, SUM(gasolina) AS gasolina,
    SUM(entregado_gasoducto) as entregado_gasoducto, SUM(gasolina + petroleo + condensado) as liquidos
    FROM partes_diarios WHERE fecha BETWEEN ? AND ? GROUP BY fecha ORDER BY fecha ASC"
    
    ParteDiario.find_by_sql([sql, fecha_ini, fecha_fin])
  end
    
end
