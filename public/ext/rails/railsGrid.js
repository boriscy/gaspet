/* 
 * Implementación del Grid con Filtros
 */
Rails.Grid = function(config) {

    if(!config.tbar && this.addMenuItems) {
        config['tbar'] = new Ext.Toolbar({});
    }
    Ext.apply(this, config);
    Rails.Grid.superclass.constructor.call(this);

}

Ext.extend(Rails.Grid, Ext.grid.GridPanel, {
    /**
     * @param boolean
     */
    addMenuItems: true,
    /**
     * Funcion que se ejecuta despues de renderizar
     */
    afterRender: function() {
        Rails.Grid.superclass.afterRender.call(this);
        if(this.addMenuItems) {
            this.createExtraMenuItems();
        }
    },
    /**
     * Crea botones de menú extra
     * @param object config
     * @return Array
     */
    createExtraMenuItems: function() {

        tbar = this.getTopToolbar();
        tbar.add({
            text: 'Quitar Filtros',
            iconCls: 'rails-cancel',
            handler: this.removeFilters,
            scope: this
        });
    },
    /**
     * Funcion que elmina los filtros que han sido aplicados en el Grid
     */
    removeFilters: function(){
        var filters = this.filters.filters.items
        Ext.each(filters, function(item) {
            item.setActive(false);
        }, this);
    }
});

