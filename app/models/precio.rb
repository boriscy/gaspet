class Precio < ActiveRecord::Base
  validates_presence_of :fecha, :wti, :henry_hub
  validates_uniqueness_of :fecha
  named_scope :ultimos, :order => "fecha ASC", :offset => (self.count - 30), :limit => 30
  named_scope :fechas, lambda{|fecha_ini, fecha_fin|
      {:conditons => ["fecha BETWEEN ? AND ?", fecha_ini, fecha_fin]}
  }
  

  # Para poder darle una fecha por defecto cuando se crea
#  def initialize(params={:fecha => Date.today.strftime(DATE_FORMAT)})
#    super params
#  end

  def self.per_page
    20
  end

#  def self.importar_csv
#    #require 'fileutils'
#    #include FileUtils
#    meses = I18n.t 'date.abbr_month_names'
#    f = File.new("/home/boris/Precios.csv", "r")
#    dia, mes, anio = 0, 0 ,0
#    f.each do |v|
#
#      begin
#        temp = v.split(",")
#        fec, wti, henry_hub = temp[0].gsub(/"/, "").split(" "), temp[2].to_f, temp[3].to_f
#
#        dia, mes = fec[0], fec[2]
#
#        (1..12).each{|cont| mes = cont if mes =~ /#{meses[cont]}/i }
#
#        if mes.to_i > 4
#          anio = 2008
#        else
#          anio = 2009
#        end
#        fecha = "#{anio}-#{"%02d" % mes}-#{"%02d" % dia}"
#        precio = self.new(:fecha => fecha, :wti => wti, :henry_hub => henry_hub)
#        unless precio.save
#          puts "#{anio}-#{"%02d" % mes}-#{"%02d" % dia} #{wti} #{henry_hub}"
#        end
#      rescue
#      end
#    end
#  end
end
