class PreciosController < ApplicationController
  # GET /precios
  # GET /precios.xml
  def index
    page = params[:page].try(:to_i) || 1
    @precios = Precio.paginate(:page => page, :order => "fecha DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @precios }
    end
  end

  # GET /precios/1
  # GET /precios/1.xml
  def show
    @precio = Precio.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @precio }
    end
  end

  # GET /precios/new
  # GET /precios/new.xml
  def new
    @precio = Precio.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @precio }
    end
  end

  # GET /precios/1/edit
  def edit
    @precio = Precio.find(params[:id])
  end

  # POST /precios
  # POST /precios.xml
  def create
    @precio = Precio.new(params[:precio])

    respond_to do |format|
      if @precio.save
        flash[:notice] = 'Precio was successfully created.'
        format.html { redirect_to(@precio) }
        format.xml  { render :xml => @precio, :status => :created, :location => @precio }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @precio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /precios/1
  # PUT /precios/1.xml
  def update
    @precio = Precio.find(params[:id])

    respond_to do |format|
      if @precio.update_attributes(params[:precio])
        flash[:notice] = 'Precio was successfully updated.'
        format.html { redirect_to(@precio) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @precio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /precios/1
  # DELETE /precios/1.xml
  def destroy
    @precio = Precio.find(params[:id])
    @precio.destroy

    respond_to do |format|
      format.html { redirect_to(precios_url) }
      format.xml  { head :ok }
    end
  end
end
