require 'gruff'
require 'fileutils'
include FileUtils

class GraphicsHidro
  attr_accessor :fecha, :tipo, :dim

#  def initialize(fecha, dim = 400)
#
#  end

  def realizar_grafico_gas()
    @tipo = "gas"
    data = ParteDiario.produccion_mensual_gas(@fecha)
    g = self.init_graph("Producción de Gas en #{I18n.l(@fecha, :format => "%B %Y")}")
    fecha_ini = @fecha.beginning_of_month
    fecha_fin = @fecha.end_of_month
    dias = {}
    contador = 0
    while fecha_ini < fecha_fin
      dias[contador] = fecha_ini.strftime("%d")
      contador += 1
      fecha_ini += 1.day
    end
    g.labels = dias
    g.data("Producción Bruta", data.collect{|d| d.try(:produccion).to_f})
    g.data("Entregado a Gasoducto", data.collect{|d| d.try(:entregado).to_f})
    g.write(Rails.public_path + "/informes/#{@tipo}-#{@fecha.to_date.to_s(:db)}.png")
  end

  def realizar_grafico_liquidos()
    @tipo = "liquidos"
    data = ParteDiario.produccion_mensual_liquidos(@fecha)
    g = self.init_graph("Produccion de Liquidos en #{I18n.l(@fecha, :format => "%B %Y")}")
    fecha_ini = @fecha.beginning_of_month
    fecha_fin = @fecha.end_of_month
    dias = {}
    contador = 0
    while fecha_ini < fecha_fin
      dias[contador] = fecha_ini.strftime("%d")
      contador += 1
      fecha_ini += 1.day
    end
    g.labels = dias
    g.data("Produccion Bruta", data.collect{|d| d.try(:produccion).to_f})
    g.data("Entregado a Gasoducto", data.collect{|d| d.try(:entregado).to_f})
    g.write(Rails.public_path + "/informes/#{@tipo}-#{@fecha.to_date.to_s(:db)}.png")
  end

  # Crea dos graficas de la fecha
  def grafico_total_por_fecha(params = {})
    if params[:data]
      data = params[:data]
    else
      fecha = params[:fecha]
      data = ParteDiario.total_por_fecha(fecha)
    end
    ret_tipo = params[:return]
    fecha_ini = data.first[:fecha]
    fecha_fin = data.last[:fecha]
    public = "/informes/#{fecha_fin.strftime("%Y/%m")}"
    if fecha_ini == fecha_ini.at_beginning_of_month && fecha_fin == fecha_ini.at_end_of_month
      tit = I18n.l fecha_ini, :format => "%B de %Y"
    else
      tit = "(30 días) hasta el #{I18n.l fecha_fin, :format => "%d de %B de %Y"}"
    end

    g = Gruff::Line.new(550)
    g.theme = THEME_REPORT
    g.marker_font_size = 14
    g.title_font_size = 20
    g.x_axis_label = "día"
    dias = {}
    data.each_index{|i| dias[i] = data[i][:fecha].strftime("%d")}
    g.labels = dias
    # Grafica de GAS
    if params[:tipo] == 'gas'
      g.title = "Producción de Gas #{tit}"
      g.y_axis_label = "Miles Pies cúbcos"
      img = "#{public}/gas-total-hasta-#{fecha_ini.strftime("%d-%m-%Y")}.png"
      g.data("GAS", data.map{|v| v.try(:entregado_gasoducto).to_f})
    #Grafica de liquidos
    else
      g.title = "Producción de Líquidos #{tit}"
      g.y_axis_label = "Barriles (BBL)"
      img = "#{public}/liquidos-total-hasta-#{fecha_ini.strftime("%d-%m-%Y")}.png"
      g.data("Petroleo", data.map{|v| v.try(:petroleo).to_f})
      g.data("Condensado", data.map{|v| v.try(:condensado).to_f})
      g.data("Gasolina", data.map{|v| v.try(:gasolina).to_f})
      g.data("Suma Líqudos", data.map{|v| v.try(:gasolina).to_f + v.try(:condensado).to_f + v.try(:petroleo).to_f})
    end
    
    makedirs(Rails.public_path + public)
    #g.normalize
    #g.minimum_value = 
    case ret_tipo
    when 'i'
      g.write(Rails.public_path + img)
      return "<img src=\"#{img}\" alt=\"Producción gas\" />"
    when 'b'
      g.to_blob("PNG")
    else
      g.write(Rails.public_path + img)
      return "<img src=\"#{img}\" alt=\"Producción gas\" />"
    end
    
  end

  # Retorna la gráfica de precios
  def grafico_precios(data = nil, params = {})
    if data.nil?
      data = Precio.fechas(params[:fecha_ini], params[:fecha_fin])
    else
      params[:fecha_fin] = data[data.size - 1].fecha
      params[:fecha_ini] = data.first.fecha
    end
    
    if verificar_mes_completo(params)
      tit = titulo_mes(params[:fecha_ini])
    else
      tit = titulo_rango_fechas(params)
    end

    g = Gruff::Line.new(550) 
    g.theme = THEME_REPORT
    g.marker_font_size = 14
    g.title_font_size = 20
    g.x_axis_label = "día"
    g.labels = labels_para_x(data)
    g.y_axis_label = "Valor en $us"

    public = crear_directorios(data.last.fecha)
    if params[:tipo] == 'wti'
      g.data("wti", data.map{|v| v.try(:wti).to_f})
      tit = "Precios internacionales\n Petroleo (wti) #{tit}"
      img = "#{public}/precios-wti-#{params[:fecha_fin].strftime("%d-%m-%Y")}.png"
    else
      g.data("henry_hub", data.map{|v| v.try(:henry_hub).to_f})
      tit = "Precios internacionales\n GAS (henry_hub) #{tit}"
      img = "#{public}/precios-henry-hub-#{params[:fecha_fin].strftime("%d-%m-%Y")}.png"
    end
    
    g.minimum_value = 0
    g.title = tit
    g.write(Rails.public_path + img)
    return "<img src=\"#{img}\" alt=\"Producción gas\" />"
  end

  def init_graph(title)
    g = Gruff::Line.new(@dim)
    g.title = title
    g.x_axis_label = "Dias"
    g.y_axis_label = "MM mcd"
    #
    g.marker_font_size = 14
    g.title_font_size = 25
  end

  protected

  def verificar_mes_completo(params={})
    if params[:fecha_ini] == params[:fecha_ini].at_beginning_of_month && params[:fecha_fin] == params[:fecha_ini].at_end_of_month
      true
    else
      false
    end
  end

  def titulo_rango_fechas(params={})
    format = params[:format] || "%d de %B de %Y"
    "de #{I18n.l params[:fecha_ini], :format => format} al #{I18n.l params[:fecha_fin], :format => format}"
  end

  # Prepara un título para gráficas mensuales
  def titulo_mes(fecha)
    I18n.l params[:fecha_ini], :format => "%B de %Y"
  end

  # Prepara los labels para el eje X
  def labels_para_x(data, params={})
    fecha = params[:fecha] || :fecha
    format = params[:format] || "%d"
    dias = {}
    data.each_index{|i| dias[i] = data[i][fecha].strftime(format)}
    dias
  end

  def crear_directorios(fecha)
    public = "/informes/#{fecha.strftime("%Y/%m")}"
    makedirs(Rails.public_path + public)
    return public
  end

end
