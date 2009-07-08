class AsignacionesController < ApplicationController

  # Presentación de datos del ultimo mes
  def index
    @asignaciones = Asignacion.listado_array
    # listado_to_array(@asignaciones)
    respond_to do |format|
      format.js
    end
  end

  def importar
    @res = {:success => true}
    @res[:data] = Asignacion.importar_ypfb_merc_int(params[:file])
    render :layout => false
  end

  def guardar
    render :json => Asignacion.guardar_datos(params)
  end

end