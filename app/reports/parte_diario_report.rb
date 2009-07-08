#class BookReport < Ruport::Controller
#CREATE VIEW view_campos_detalles AS  SELECT e.nombre AS empresa, a.nombre AS area,
#c.nombre AS campo, c.codigo, c.id as campo_id
#FROM campos c
#JOIN areas a ON ( a.id = c.area_id )
#JOIN contratos con ON ( con.id = a.contrato_id )
#JOIN empresas e ON ( e.id = con.empresa_id )
class ParteDiarioReport < Ruport::Controller
  def setup
    ParteDiario.report_table(:all, :only => [:fecha],
      :conditions => ["fecha>= ? AND fecha<= ?", '2009-01-01', '2009-01-28'],
      :include => [:campo])#, :group => [:campo_id], :sum => [:])
  end

  def reportes
    case(params[:operation])
      when "SUM"
        op = "SUM"
      when  "AVG"
        op = "AVG"
      else
        op = "SUM"
    end

    rep_cols = []
    
    rep_cols = cols(op, params[:campos]).join(", ")
    sql = "SELECT #{rep_cols}
    from partes_diarios pd
    join view_campos_detalles v on (v.campo_id = pd.campo_id)
    group by pd.campo_id"
    pd = ParteDiario.report_table_by_sql(sql)

  end

  # Crea la sintaxis para poder realizar el SQL
  # @param String op
  # @return Array
  def cols(op, only = [])
    ret = []
    ParteDiario.cols.each do |col|
      ret.push("#{op}(#{col}) AS #{col}") if only.find{|val| col == val}
    end
    ret
  end

end