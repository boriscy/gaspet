/**
 * Clase que presenta el mnú principal de la aplicación
 */
Rails.Menu = function(config) {

    config = config || {};
    Ext.apply(this, config);

    //Create raiz
    var raiz = new Ext.tree.AsyncTreeNode({
        text : 'Root',
        draggable : false,
        expanded : true,
        id: 'root',
        children : config.jsonTree || [],
        iconCls : 'rails-root'
    });

    Rails.Menu.superclass.constructor.call(this, {
        id: 'menu',
        title: 'Menú',
        width: 250,
        region: 'west',
        collapsible: true,
        split: true,
        enableDD: false,
        hideMode: 'mini',
        root: raiz
        /*menuItems : [{
            text : 'Crear',
            tooltip : 'Crear Página'
        },{
            text : 'Editar',
            tooltip : 'Editar Página'
        },{
            text : 'Borrar',
            tooltip : 'Borrar Página'
        }]*/
    });

    this.on('click', this.mostrar, this  );
}

Ext.extend(Rails.Menu, Ext.tree.TreePanel, {
    /**
     * Muestra el item seleccionado y adiciona el tab en el centro "center" del viewport principal
     * @param Ext.tree.TreeNode node
     * @param event e
     */
    mostrar: function(node, e) {

        if( node.childNodes.length > 0 ) {
            return false;
        }
        var t = Ext.getCmp('viewport').findById('tabs');
        if(tab = t.findById(node.id)) {
            t.setActiveTab(tab);
            return false;
        }

        // Llamada del script via Ajax
        new Ext.ux.JSLoader({
            url: node.attributes.vinculo,
            // Se completo correctamente la llamda
            onLoad: function(options) {
                
                Ext.apply(temp, {id: node.id});
                var tab = t.add(temp);
                t.setActiveTab(tab);
            },
            onError: function(options, e) {
                alert('Error loading script');
            }
        });
    }
});
Ext.reg('railsmenu', Rails.Menu);

