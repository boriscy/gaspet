class AdminController < ApplicationController

  def index
    tree = TreeCreator.new({:id => :id, :text => :nombre, :iconCls => :icono, :vinculo => :vinculo})
    @menu = tree.create_tree(Menu.find(:all))
  end

  def admin
    tree = TreeCreator.new({:id => :id, :text=>:nombre, :iconCls => :icono, :vinculo => :vinculo})
    @menus = tree.create_tree Menu.menus
  end

  # Acccion para poder probar los scripts
  def test
    
  end

  # Función para poder generar plantilla general de cada modelo
  def generate

    model = params[:model].classify.constantize.columns  #eval "#{params[:model]}.columns"
    editor = (defined? params[:editor]) ? true : false
    
    @filters = []
    @cm = []
    @store = []
    @combo_stores = []
    @record = []
    @model = params[:model]
    @editor = editor

    model.each do |v|
      # Filtros
      if v.name != 'created_at' && v.name != 'updated_at'
        if v.name != 'id'
          @filters.push(filter(v) )
          # Modelos
          if v.name =~ /.*_id$/ && editor
            model_name = v.name.gsub(/_id$/, '')
            @combo_stores.push({:name => model_name, :def => combo_store(model_name) })
          end

          @cm.push(column_model(v, editor) )
          if editor
            @record.push( data_record(v) )
          end
        end
        @store.push( store(v) )
      end
    end
    
    render :layout => false
  end

  protected
  # Generación de ColumnModel
  # @param Object val Parametro que se recibe de ej: (Modelo.columns[0])
  # @param Boolean editor Indica si va a tener editor el Grid
  # @return Hash
  def column_model(val, editor = false)
    ret = {}
    
    if val.name =~ /.*_id$/
      col = val.name.gsub(/_id/, '')
      ret = {:dataIndex => val.name, :header => col.humanize, :width => 150}
      if editor
        ret[:editor] = {:xtype => 'combo', :typeAhead => true, :triggerAction => 'all', 
          :lazyRender => true, :displayField => 'nombre', :valueField => 'id', :mode => 'local',
          :store => "#{col}_store", :renderer => "function(value){ return Ext.ux.comboBoxRenderer(#{col}_combo, value); }" }
      end
    else
      case true
        when val.type == :integer || val.type == :decimal
          ret = {:dataIndex => val.name, :header => val.name.humanize, :width => 75}
        when val.type == :string
          ret = {:dataIndex => val.name, :header => val.name.humanize, :width => 150}
        when val.type == :date || val.type == :datetime
          ret = {:dataIndex => val.name, :header => val.name.humanize, :width => 75}
        when val.type == :boolean
          if !edit
            ret = {:dataIndex => val.name, :header => val.name.humanize, :width => 30}
          end
      end
      if editor
        ret[:editor] = editor_field(val)
      end
    end
    
    ret
  end

  # Generación de Editor
  # @param Object val que se recibe de ej: (Modelo.columns[0])
  # @return Hash
  def editor_field(val)
    ret = {}
    case true
      when val.type == :integer || val.type == :decimal
        ret = {:xtype => 'numberfield', :allowBlank => false}
      when val.type == :string
        ret = {:xtype => 'textfield', :allowBlank => false}
      when val.type == :date || val.type == :datetime
        ret = {:xtype => 'datefield', :allowBlank => false}
      when val.type == :boolean
        ret = {:xtype => 'checkcolumn', :header => val.name.humanize, :dataIndex => val.name, :width => 55}
    end
    ret
  end

  #
  #
  def data_record(val)
    ret = {}
    case true
      when val.type == :integer
        ret = {:name => val.name, :type => 'integer'}
      when val.type == :decimal
        ret = {:name => val.name, :type => 'decimal'}
      when val.type == :string
        ret = {:name => val.name, :type => 'string'}
      when val.type == :date || val.type == :datetime
        ret = {:name => val.name, :type => 'date'}
      when val.type == :boolean
        ret = {:name => val.name, :type => 'bool'}
    end
    ret
  end

  # Generación de Store para el combo
  # @param Object val que se recibe de ej: (Modelo.columns[0])
  # @return Hash
  def combo_store(val)
    {:fields => ['id', 'nombre'], :data => "<%= combo_data #{val.camelize}.find :all %>"}
  end
  # Generación de Filtro
  # @param Object val que se recibe de ej: (Modelo.columns[0])
  # @return Hash
  def filter(val)
    ret = {}

    if val.name =~ /.*_id$/
      ret = {:dataIndex => val.name, :type => 'string'}
    else
      case true
        when val.type == :integer || val.type == :decimal
          ret = {:dataIndex => val.name, :type => 'numeric'}
        when val.type == :string
          ret = {:dataIndex => val.name, :type => 'string'}
        when val.type == :date || val.type == :datetime
          ret = {:dataIndex => val.name, :type => 'date'}
        when val.type == :boolean
          ret = {:dataIndex => val.name, :type => 'boolean'}
      end
    end
    ret
  end

  # Generación de Store
  # @param Object val que se recibe de ej: (Modelo.columns[0])
  # @return Hash
  def store(val)
    ret = {:name => val.name}
  end

end