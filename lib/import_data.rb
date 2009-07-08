#Importa datos de diferentes fuentes como CSV Excel

class ImportData
  attr_accessor :path

  # copia el archivo que se ha realizado el upload en un archivo temporal
  def initialize(file)
    ext = File.extname(file.original_filename).downcase
    @path = "#{Rails.public_path}/temp_files/#{Time.now.to_f}#{ext}"
    File.open(@path, "wb") { |f| f.write(file.read) }
  end

  # Realiza la importación de archivos excel (.xls), excel 2007 (.xlsx) y OpenOffice (.ods)
  def excel()
    require 'roo'
    case ext
      when ".xls"
        file = Excel.new(@path)
      when ".xlsx"
        file = Excelx.new(@path)
      when ".ods"
        file = Openoffice.new(@path)
      else
        return false
    end
    # Modificar de acuerdo a los requeriemientos
    file.default_sheet = file.sheets.first

    File.delete(@path)
    return file
  end

  def csv()
    require 'fastercsv'
    file = FasterCSV.read(@path)
    File.delete(@path)
    return file
  end

  def delete()
    File.delete(@path)
  end
end