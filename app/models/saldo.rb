class Saldo < ActiveRecord::Base
  validates_presence_of :fecha
  serialize :datos

  # Retorna un array con instancia de saldo Saldo.new(:param1 => ''....
  def self.importar(archivo)
    ext = File.extname(archivo.original_filename).downcase

    case ext
    when ext == ".xls" || ext == ".xlsx"
      importar_excel(archivo)
    when ".csv"
      importar_csv(archivo)
    end

  end

  # Realiza la importación de un archivo excel
  def self.importar_excel(archivo)
    temp = []
    (4..20).each do |i|
      temp.push({:depto => excel.cell(i, 'A'), :ge => excel.cell(i, 'S'),
          :do => excel.cell(i, 'T'), :gp => excel.cell(i, 'U'), :jf => excel.cell(i, 'V'),
          :kn => excel.cell(i, 'W'), :do_imp => excel.cell(i, 'X'), :glp => excel.cell(i, 'Y')
        })
    end
    return temp
  end

  # Importación de archivo CSV
  def self.importar_csv(archivo)
    temp = []
    data = ImportData.new(archivo).csv()
    (3..19).each{|i| temp.push({:planta => data[i][0], :ge => data[i][18], :do => data[i][19], :gp => data[i][20],
          :jf => data[i][21], :kn => data[i][22], :doi => data[i][23], :glp => data[i][24] }) }
    return temp
  end
end
