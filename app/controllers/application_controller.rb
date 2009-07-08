class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  #  include RoleRequirementSystem
  helper :all # include all helpers, all the time
  protect_from_forgery # :secret => '6911ce44010c12fa957996d70af558ad'

  filter_parameter_logging :password, :password_confirmation
  before_filter :login_required

  # Permite presentar en un layout AJAX automaticamente
  layout lambda{|controller| controller.request.xhr? ? "ajax" : "application"}
  
  protected

  # Permite la importacion de archivos csv
  # @param file Archivo CSV
  # return array
  def import_csv(csv_file)
    ret = []
    name = csv_file.original_filename

    if File.extname(name) == '.csv'
      require 'csv'
      path = "public/temp_csv/#{name}"
      File.open(path, "wb") { |f| f.write(csv_file.read) }

      CSV::Reader.parse(File.open(path, 'rb')) do |row|
        cur_row = []
        row.each{|cell| cur_row.push(cell)}
        ret.push(cur_row)
      end
      # Borrado del archivo importado
      File.delete(path)
    end

    ret
  end

  # Transforma una fecha del formato
  def transformar_fecha_bd(fecha)
    fecha.gsub(/^(\d\d)-(\d\d)-(\d{4})/, '\3-\2-\1')
  end

  # Retorna un Array con los nombres de los meses
  def meses
    I18n.l 'date.month.names'
  end

  # Prueba si la fecha ingresada es valida
  # @param string fecha
  # @return boolean
  def fecha_valida(fecha)
    begin
      Date.parse(fecha)
      return true
    rescue
      return false
    end
  end
end