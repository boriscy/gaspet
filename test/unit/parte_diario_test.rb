class ParteDiarioTest < Test::Unit::TestCase
  context "ParteDiario" do

    setup do
      @parte = ParteDiario.create(:fecha => "fe")
    end

    should "buscar por fecha" do
      #p = ParteDiario.buscar_por_fecha("2009-01-02")
      p2 = ParteDiario.find_by_fecha("2009-01-02")
      assert_equal 2, p2.size
    end

    # Esta prueba se debe realizar en un functional Test, es necesario crear un rake
#    should "importar hoja excel" do
#      pd = ParteDiario.importar("#{RAILS_ROOT}/public/import/parte_diario_01-01-2009.xls", '01-01-2009')
#      assert_equal pd.length, 52
#    end

    #Para que pueda funcionar correctamente debe poderse crear la Vista, usando algun rake task
#    should "mostrar reporte suma y promedio" do
#      p = ParteDiario.reporte('2009-01-01', '2009-02-02', 'SUM')
#      assert_equal p.length, 2
#    end
  end
end
