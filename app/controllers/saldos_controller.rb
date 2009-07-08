# Clase extrmadamente cochina para salvar el rato
class SaldosController < ApplicationController

  skip_before_filter :login_required, :only => :show
  # GET /saldos
  # GET /saldos.xml
  def index
    @saldos = Saldo.all(:order => "fecha DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @saldos }
    end
  end

  # GET /saldos/1
  # GET /saldos/1.xml
  def show
    @saldo = Saldo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @saldo }
    end
  end

  # GET /saldos/new
  # GET /saldos/new.xml
  def new
    @saldo = Saldo.new
    @data = []
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @saldo }
    end
  end

  # GET /saldos/1/edit
  def edit
    @saldo = Saldo.find(params[:id])
  end

  # POST /saldos
  def create
    @saldo = Saldo.new(:fecha => params[:saldo][:fecha], :datos => Saldo.importar(params[:saldo][:datos]))
    if @saldo.save
      redirect_to @saldo
    else
      render :action => "new"
    end
    
    
#    @saldo = Saldo.new(params[:saldo])
#
#    respond_to do |format|
#      if @saldo.save
#        flash[:notice] = 'Saldo was successfully created.'
#        format.html { redirect_to(@saldo) }
#        format.xml  { render :xml => @saldo, :status => :created, :location => @saldo }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @saldo.errors, :status => :unprocessable_entity }
#      end
#    end
  end

  # PUT /saldos/1
  # PUT /saldos/1.xml
  def update
    @saldo = Saldo.find(params[:id])

    respond_to do |format|
      if @saldo.update_attributes(params[:saldo])
        flash[:notice] = 'Saldo was successfully updated.'
        format.html { redirect_to(@saldo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @saldo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /saldos/1
  # DELETE /saldos/1.xml
  def destroy
    @saldo = Saldo.find(params[:id])
    @saldo.destroy

    respond_to do |format|
      format.html { redirect_to(saldos_url) }
      format.xml  { head :ok }
    end
  end

end
