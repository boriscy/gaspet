require 'csv'
class PruebasController < ApplicationController
  # GET /pruebas
  # GET /pruebas.xml
  def index
    @pruebas = Prueba.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pruebas }
    end
  end

  # Prueba para generargrafica
#  def grafico(format)
#    graph = Graph(%w[a b c d e])
#    graph.series [1,2,3,4,5], "foo"
#    graph.series [11,22,70,2,19], "bar"
#    return graph
#  end


  def listado
    #@lista = Asignacion.listado_array
    @lista = Campo.find(:all, :include => [:area => [:contrato => [:empresa]]], :conditions => {:codigo => ""}) #
  end

  # GET /pruebas/1
  # GET /pruebas/1.xml
  def show
    @prueba = Prueba.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @prueba }
      format.js #  { render :xml => @prueba, render :layout => false }
    end
    
  end

  # GET /pruebas/new
  # GET /pruebas/new.xml
  def new
    @prueba = Prueba.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @prueba }
    end
  end

  # GET /pruebas/1/edit
  def edit
    @prueba = Prueba.find(params[:id])
  end

  # POST /pruebas
  # POST /pruebas.xml
  def create
    @prueba = Prueba.new(params[:prueba])

    respond_to do |format|
      if @prueba.save
        flash[:notice] = 'Prueba was successfully created.'
        format.html { redirect_to(@prueba) }
        format.xml  { render :xml => @prueba, :status => :created, :location => @prueba }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @prueba.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pruebas/1
  # PUT /pruebas/1.xml
  def update
    @prueba = Prueba.find(params[:id])

    respond_to do |format|
      if @prueba.update_attributes(params[:prueba])
        flash[:notice] = 'Prueba was successfully updated.'
        format.html { redirect_to(@prueba) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @prueba.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pruebas/1
  # DELETE /pruebas/1.xml
  def destroy
    @prueba = Prueba.find(params[:id])
    @prueba.destroy

    respond_to do |format|
      format.html { redirect_to(pruebas_url) }
      format.xml  { head :ok }
    end
  end

  def import
    # @empresas = Empresa.find :all
    # @contratos = Contrato.find :all
    # @areas = Area.find :all
    # @campos = []
    
    #CSV::Reader.parse(File.open('/home/boris/Escritorio/contratos.csv', 'rb')) do |row|
      #r = importar(@contratos, row[0])
#      if r.to_s != ''
#        id = @empresas.detect{|v| v[:nombre] == row[3]}
#        @contratos.push({:nombre => row[0], :codigo => row[0], :empresa_id => id[:id]})
#        # Creación
#        # Contrato.create(:codigo => row[0], :empresa_id => id[:id])
#      end
      
#      r = importar(@areas, row[1])
#      if r.to_s != ''
#        id = @contratos.detect{|bus| bus.codigo == row[0]}.id
#        if ! @areas.detect{|bus| bus[:contrato_id] == row[1]}
#          @areas.push({:nombre => row[1], :contrato_id => id })
#          Area.create({:nombre => row[1], :contrato_id => id })
#        end
#
#      end
      
#      r = importar(@campos, row[2])
#      if r.to_s != ''
#        id = @areas.detect{|bus| bus.nombre == row[1]}.id
#        if ! @campos.detect{|bus| bus[:nombre] == row[2]}
#          @campos.push({:nombre => row[2], :area_id => id })
#          c = Campo.new({:nombre => row[2], :area_id => id })
#          c.save
#        end
#
#      end

    #end
    @contratos = Contrato.find :all, :include => [:empresa]
    @empresas = Empresa.find :all

    render :layout => false
  end

  def excel
    require 'roo'
    excel = Excel.new('/home/boris/Escritorio/importar.xls')
    excel.default_sheet = excel.sheets[0]
    @data  = []
    9.upto(90) do |fila|
      if !excel.cell(fila,'B').nil? && excel.cell(fila,'C').class.to_s == 'Float' && !excel.cell(fila,'B') != 'PLANTA'
        if excel.cell(fila,'B') != ''
          @data.push({:campo => excel.cell(fila,'B'), :produccion => excel.cell(fila,'C'),
            :petroleo => excel.cell(fila,'D'), :condensado => excel.cell(fila,'E'),
            :den_api => excel.cell(fila,'F').to_f.round_with_precision(2) })
        end

      end
    end
    render :layout => false
  end

  protected
  def importar(arr, val)
    val unless arr.detect{|v| v[:nombre]== val }
  end

  
end
