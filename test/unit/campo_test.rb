class CampoTest < Test::Unit::TestCase
  #fixtures :all
  
  context "Campo" do
    context "nulos" do
      setup do
        @campo = Campo.create(:nombre => nil, :codigo => nil, :area_id => nil, :departamento_id => nil)
      end

      should "error en nombre" do
        assert @campo.errors.on(:nombre)
      end

      should "error en codigo" do
        assert @campo.errors.on(:codigo)
      end

      should "error en area_id" do
        assert @campo.errors.on(:area_id)
      end

      should "error en departamento_id" do
        assert @campo.errors.on(:departamento_id)
      end

    end

    context "prueba de unicos" do
      setup do
        @campo = Campo.create(:nombre => "Campo Je", :codigo => "je", :area_id => 1, :departamento_id => 1)
        @campo2 = Campo.create(:nombre => "CAMPO JE", :codigo => "JE", :area_id => 1, :departamento_id => 1)
      end

      should "nombre y codigo deben ser mayusculas" do
        assert_equal "CAMPO JE", @campo.nombre
        assert_equal "JE", @campo.codigo
      end

      should "debe tener nombre y codigo único" do
        assert @campo2.errors.on(:nombre)
        assert @campo2.errors.on(:codigo)
      end

      should "tambien presenta codigo para to_s" do
        assert_equal "JE", @campo.to_s
      end
    end
  end
end
