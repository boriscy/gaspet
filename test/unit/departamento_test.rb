class DepartamentoTest < Test::Unit::TestCase
  context "Departamento" do

    context "creacion" do
      setup do
        @depto = Departamento.create(:nombre => 'Sagrado', :abreviacion =>'SGD')
        @depto2 = Departamento.create(:nombre => 'Sagrado', :abreviacion => 'SGD')
      end

      should "mostrar errores de dupliacion de nombre y abreviacion" do
        assert @depto2.errors.on(:nombre)
        assert @depto2.errors.on(:abreviacion)
      end

    end

  end
end
