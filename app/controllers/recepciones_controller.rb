# Realiza la importación de datos de recepciones
class RecepcionesController < ApplicationController
  def index
    
  end

  def new

  end

  def show

  end

  # Transaccion que almacena todos los datos
  def create
    save = true
    @recepciones = []
    #@fecha = params[:recepcion].first()

    Recepcion.transaction do
      params[:recepcion].each do |k, recepcion|
        r = Recepcion.new(recepcion)
        unless r.save!
          raise ActiveRecord::Rollback, "Error de transacción Recepción!"
          save = false
          flash[:error] = "Existion un error no se pudo guardar los datos"
        end
        @recepciones.push(r)
      end
    end
    if save
      flash[:notice] = "Se guardaron los datos correctamente"
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def edit

  end

  def update
    
  end

  # Realiza la importación de un archivo Excel
  def import
    fecha = params[:recepcion][:fecha].gsub(/\A(\d\d)-(\d\d)-(\d{4})\Z/, "\\3-\\2-\\1")
    begin
      @fecha = Date.parse(fecha).at_beginning_of_month
      @recepciones = []
      if defined? params[:recepcion][:archivo].original_filename && File.extname(params[:recepcion][:archivo].original_filename) == ".xls"
        @recepciones = Recepcion.importar(params[:recepcion][:archivo])
      end
      render :action => 'new'
    rescue
      flash[:error] = "Debe ingresar una fecha válida"
      render :action => 'index'
    end
  end
end