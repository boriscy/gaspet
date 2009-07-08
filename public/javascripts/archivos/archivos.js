/*
 * Script que permite la edición y mantenimiento de los archivos que se
 * Suben al seridor
 */
Rails.Archivos = Ext.extend( Ext.Panel, {

    /**
     * Inicialización del componente para que pueda funcionar
     * correctamente el layout: 'border'
     */
    initComponent: function() {

        this.arbol = this.crearArbol();
        this.grid = this.crearGrid();

        Ext.apply(this, {
            items: [this.arbol, this.grid]
        });
        
        Rails.Archivos.superclass.initComponent.apply(this, arguments);
    },
    title: 'Archivos',
    layout: 'border',
    /**
     * Creación del arbol de categorías
     */
    crearArbol: function() {

        var raiz = new Ext.tree.AsyncTreeNode({
            id: 'raiz', singleClickExpand: false,
            text: 'Categorías', checked: false
        });

        var arbol = new Ext.tree.TreePanel({
            region: 'west',
            title: 'Categorías',
            loader: new Ext.tree.TreeLoader({
                url: '/categorias/lista',
                requestMethod:'GET',
                baseParams:{format:'json'}
            }),
            animCollapse: false,
            rootVisible: false,
            split: true,
            collapsible: true,
            root: raiz,
            width: 250
        });

        return arbol;
    },
    /**
     * Creación del Grid con el que se relaciona
     */
    crearGrid: function() {

        // ColumnModel
        var cm = new Ext.grid.ColumnModel([{
            dataIndex: 'id',
            header: 'Id', width: 30
        },{
            dataIndex: 'nombre',
            header: 'Nombre', width: 200
        },{
            dataIndex: 'fecha',
            header: 'Fecha', width: 60,
            renderer: Ext.util.Format.dateRenderer('d-m-Y')
        },{
            dataIndex: 'bool', header: 'Bool', width: 50
        },{
            dataIndex: 'lista', header: 'Lista', width: 50
        }]);
        cm.defaultSortable = true;

        // Store
        var ds = new Ext.data.JsonStore({
            url:'/archivos/index',
            totalProperty: 'total',
            root: 'data',
            fields: [{
                name:'id'
            },{
                name:'nombre'
            },{
                name:'fecha',
                type: 'date',
                dateFormat: 'd-m-Y H:i:s'
            },{
                name: 'bool'
            },{
                name: 'lista'
            }],
            sortInfo: {
                field: 'fecha',
                direction: 'ASC'
            },
            remoteSort: true,
            baseParams: {
                authenticity_token: AUTH_TOKEN
            }
        });

        // Filtros
        var filters = new Ext.grid.GridFilters({
            filters:[{
                type: 'numeric',
                dataIndex: 'id'
            },{
                type: 'string',
                dataIndex: 'nombre'
            },{
                type: 'date',
                dataIndex: 'fecha'//, dateFormat: 'Y-m-d', beforeText: 'Antes', afterText: 'Depues', onText: 'En'
            },{
                type: 'boolean', dataIndex: 'bool'
            },{
                type: 'list',
                dataIndex: 'lista',
                options: ['small', 'medium', 'large', 'extra large']
            }]
        });

        var grid = new Rails.Grid({
            id: 'example',
            title: 'Archivos',
            region: 'center',
            ds: ds,
            cm: cm,
            enableColLock: false,
            loadMask: true,
            plugins: filters,
            viewConfig: {
                forceFit: true
            },
            sm: new Ext.grid.RowSelectionModel({singleSelect: true}),
            autoExpandColumn: 'nombre',
            tbar: new Ext.Toolbar({
                items: [{
                    text : 'Subir Archivo',
                    iconCls : 'rails-add',
                    handler : this.subirArchivo,
                    scope : this
                }]
            }),
            bbar: new Ext.PagingToolbar({
                store: ds,
                pageSize: PAGE_SIZE,
                plugins: filters
            })
        });

        return grid;
    },
    /**
     *
     */
    quitarFiltros: function() {
        //
    },
    /**
     * Forma que presentada para poder subir archivos
     */
    subirArchivo: function() {
        var forma = new Rails.Form({
            url: '/archivos/subir',
            items: [{
                xtype: '', label:''
            }]
        });
        alert('Subir');
    }
});

temp = new Rails.Archivos({closable: true});
