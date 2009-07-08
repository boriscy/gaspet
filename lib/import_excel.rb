require 'roo'
# Clase que permite la importación de archivos Excel, Excel 2007 y OpenOffice
class ImportExcel
  attr_accessor :file

  def initialize(file)
    filename = file.original_filename
    ext = File.extname(filename).downcase

    path = "public/temp_files/#{Time.now.to_f}#{ext}"
    File.open(path, "wb") { |f| f.write(file.read) }
    # Verificacion de la extencion del archivo
    case ext
      when ".xls"
        @file = Excel.new(path)
      when ".xlsx"
        @file = Excelx.new(path)
      when ".ods"
        @file = Openoffice.new(path)
      else
        return false
    end
    # Modificar de acuerdo a los requeriemientos
    @file.default_sheet = @file.sheets.first
    File.delete(path)
  end

end