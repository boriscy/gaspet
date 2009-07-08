class ReportsesController < ApplicationController
  # GET /reportses
  # GET /reportses.xml
  skip_before_filter :login_required
  caches_page :index

  def index
    @report = Reports.last

    respond_to do |format|
      format.html
      format.xml  { render :xml => @report }
    end
  end

  def expire
    expire_page :controller => "reportses", :action => "index"
    render :inline => "Cache borrado"
  end
  
#
#  def partes_diarios
#    @fecha =Time.mktime(2008, 1, 1, 1, 1, 1, 1)
#    graph = GraphicsHidro.new(@fecha, '600x300')
#    graph.realizar_grafico_gas()
#    graph.realizar_grafico_liquidos()
#
#    @informes = ParteDiario.reporte_diario(@fecha)
#  end

  # Producion diario
  def produccion_diaria()
    render :partial => 'produccion', :locals => {:p => ParteDiario.parte_diario(params[:id])}
  end

  # Gráfica de produccion diaria que admite recibir parametros
  def produccion_graficas()
    render :partial => 'graficas_produccion', :locals => {:data => ParteDiario.total_por_fecha(params[:fecha_ini], params[:fecha_fin])}
  end

  def precios()
    params[:tipo] = :henry_hub if params[:tipo].nil?
    if params[:fecha].nil?
      data = Precio.ultimos
    else
      fecha = Date.parse(params[:fecha])
      data = Precio.all(:conditions => ["fecha BETWEEN ? AND ?", fecha.at_beginning_of_month, fecha.at_end_of_month])
    end
    
    render :partial =>'precios', :locals => {:data => data, :tipo => params[:tipo]}
  end

  def recepciones()
    if params[:fecha]
      render :partial => 'recepciones', :object => Recepcion.lista.all(:conditions => ["fecha = ?", params[:fecha]])
    else
      render :partial => 'recepciones', :object => Recepcion.ultimos
    end
  end
end
