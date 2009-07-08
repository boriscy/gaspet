# => 
class PartesDiariosController < ApplicationController

  # El indice muestra los el parte diario del día
  def index
    @fecha = params[:id]
    unless @fecha =~ /^\d\d-\d\d-\d{4}$/
      @fecha = Date.today.strftime("%Y-%m-%d")
    else
      d, m , y = params[:id].split("-")
      @fecha = "#{y}-#{m}-#{d}"
    end
    @datos = ParteDiario.parte_diario(@fecha)
    
    @cols = ParteDiario.cols()
    @cols.delete("id").delete("campo_id").delete("fecha")
  end

  def importar
    if defined? params[:archivo].original_filename && File.extname(params[:archivo].original_filename) == ".xls"
      res = ParteDiario.importar(params[:archivo], params[:fecha])
      
      if res[:errors].length > 0
        flash[:flash_error] = "ERROR<br/> <ul>#{res[:errors].map{|v| "<li>#{v}</li>"}.join("")}</ul>"
      else
        flash[:flash_notice] = "Se importo correctamente el Parte diario"
      end

      @partes_diarios = res[:imported]
      @original = res[:original]
      @cols = ParteDiario.cols()
      (0..2).each{|num| @cols.delete_at(0)}
      @campos = Campo.find(:all, :order => "nombre ASC")
      @fecha = params[:fecha]
      render :action => "new"
    else
      render :action => "index"
    end
  end

  # New
  def new
   
  end

  def create
    @a = false
    res = ParteDiario.crear(params[:parte_diario])
    @cols = ParteDiario.cols()
    unless res[:success]
      @partes_diarios = res[:data]
      @campos = Campo.find(:all, :order => "nombre ASC")
      (0..2).each{|num| @cols.delete_at(0)}
      @fecha = params[:parte_diario]['1'][:fecha]
      render :action => "new"
    else
      redirect_to "/partes_diarios/index"
    end
  end

  # Guardar datos
  def save
    res = ParteDiario.guardar(params)
    if res[:success]
      redirect_to "partes_diarios/index"
    else
      @campos = Campo.find(:all, :order => "nombre ASC")
      @cols = ParteDiario.cols
      @archivos = res
      @buscar = false # Variable que sirve para indicar hacer busquedas en el partial
      render :action => 'index'
    end
  end
  
  # Para poder hacer log Rails.logger.info "Mensaje"
  # Reportes, en caso de que la llamada sea Ajax se presenta un parcial
  def reportes
    # Verificar si se hizo un post
    if params[:fecha_ini]
      if fecha_valida(params[:fecha_ini]) && fecha_valida(params[:fecha_fin]) &&
          (Time.parse(params[:fecha_ini]).to_i <= Time.parse(params[:fecha_fin]).to_i)
        fecha_ini, fecha_fin = transformar_fecha_bd(params[:fecha_ini]), transformar_fecha_bd(params[:fecha_fin])
      else
        fecha = Time.now.strftime("%Y-%m-%d")
        fecha_ini, fecha_fin = fecha, fecha
      end
      reporte = ParteDiario.reporte(fecha_ini, fecha_fin, params[:operacion])
    end
    
    # Responder a cada tipo de recurso (XML, JSON, HTML)
    respond_to do |format|
      format.html {render(:partial => "reportes", :locals => {:fecha_ini => params[:fecha_ini], :reporte => reporte,
            :fecha_fin => params[:fecha_fin], :operacion => params[:operacion]}) if request.xhr? }
      format.js
      format.xml { render :xml => reporte }
    end
  end

  # Generación de la gráfica
  def grafico
    require "ruport/util"

    graph = Graph(%w[a b c d e])
    graph.series [1,2,3,4,5], "foo"
    graph.series [11,22,70,2,19], "bar"
    return graph
  end

  def graphics
    require 'gruff'
    g = Gruff::Line.new(500)

    g.title = "Ministerio de Hidrocarburos"

    g.data("Gas natural", [1, 2, 3, 4, 4, 3])
    g.data("gasolina premium", [4, 8, 7, 9, 8, 9])
    g.data("gasolina especial", [2, 3, 1, 5, 6, 8])
    g.data("kerosene", [9, 9, 10, 8, 7, 9])

    g.labels = {0 => '2003', 2 => '2004', 4 => '2005'}
    g.write(Rails.public_path + '/informes/cosas.png')
  end
end
