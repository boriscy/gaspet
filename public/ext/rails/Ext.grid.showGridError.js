/**
* Ext.grid.showGridError
* @author   Boris Barroso
* @version  Version 0.7
* @date     2008-12-23
* Plugin que permite presentar los errores en un GridEditable
* Es necesario configurar el id al cual se hara busqueda
*/
Ext.grid.showGridError = function(config) {
  Ext.apply(this, config);
}

Ext.extend(Ext.grid.showGridError, Ext.util.Observable, {
  id: 'id', // ID por defecto
  type: 'int',// tipo de dato del id tipos (int, string)
  tips: [], // Array  que contiene los tips
  params: [],
  init: function(grid) {
    this.grid = grid;
    this.view = grid.getView();
    this.store = grid.getStore();
    this.cm = grid.getColumnModel();

    if(!this.grid['errors']) {
      this.grid['errors'] = {};
    }
    // Registrar ciertos eventos que hacen que se modifique la presentación del grid
    grid.store.on('datachanged', function(){ this.setErrors(); }, this);
    grid.colModel.on('columnmoved', function(){ this.setErrors(); }, this);
    //grid.view.on('refresh', function(){ this.setErrors(); }, this);
  },
  /**
   * Presenta el error de cada uno de los Elementos
   * @param array params Array con la lista de errores
   * @return void
   */
  setErrors: function(params){

    this.params = params || this.params;

    for(var i = 0, l = params.length; i< l ; i++) {

      var fila = this.store.findBy(function(item) {
        return item.data[this.id] == params[i][this.id];
      }, this);

      var errors = params[i];
      delete(errors[this.id]);

      for(var k in errors) {

        var col = this.searchColumn(k);

        if (col >= 0) {
          var elem = this.view.getCell(fila, col).firstChild;

          // Registro del tip y adicion al array tips
          this.tips.push(elem);
          Ext.get(elem).addClass('x-form-invalid');
          Ext.QuickTips.register({target: elem, text: errors[k], cls: 'x-form-invalid-tip'});
        }
      }
    }
  },
  /**
  * Busca la columna en la que se encuentra un campo
  * @param string field Campo que se busca
  * @return integer
  */
  searchColumn: function(field) {
    var cm = this.grid.getColumnModel();
    for(var i = 0, l = cm.config.length; i< l; i++) {
      if(cm.config[i].dataIndex == field) {
        return i;
      }
    }
    return -1;
  },
  /**
   * Quita todos los tips del array cuando se modifica el DOM
   * @return void
   */
  removeTips: function() {
    for(var i, l = this.tips.length; i< l ; i++) {
      Ext.QuickTips.unregister(this.tips[i]);
    }
  }
});


