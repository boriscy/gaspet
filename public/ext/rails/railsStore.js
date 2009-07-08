/**
 * This class creates a store to handle many of the actions for saving and storing data
 * for grid editors
 */
Rails.store = function(config) {
  Ext.apply(this, config);

  Rails.store.superclass.constructor.call(this);
}
Ext.extend(Rails.store, Ext.data.Store, {

  /**
   *@cfg Default model to apply the config
   */
  model: '',
  /**
  *Saves the info for a grid
  */
  saveGridData: function(config) {
    // Obtain the modifies records
    var data = this.getModifiedRecords();
    if(data.length <= 0) {
      return false;
    }
    // Obtain the modified data
    var params = this.formatGridParams(data);
    // Ajax Request
    Ext.Ajax.request({
      params: params,
      url: this.url || config.url,

      sucsess: function(resp, opt) {
        try {
          var r = Ext.decode(resp.data);
          if(!r.success) {
            opt.failure();
          }
        }catch(e) { opt.failure(); }
        
        this.commitChanges();
      },

      failure: function(resp, opt) {
        this.rejectChanges();
        Ext.MessageBox.show({
          title: 'Error',
          msg: this.saveError || 'Existio un error al guardar los datos',
          buttons: Ext.MessageBox.OK,
          icon: Ext.MessageBox.ERROR
        });
      }
    });
  },
  /**
   * Returns a Formated object to use with Ajax Request for saving data
   * @param object Object with data to format
   * @return object Formated object for Ajax Submit
   */
  formatGridParams: function(data) {
    var data = data || this.getModifiedRecords();
    var params = {};
    Ext.each(data, function(item, i) {
      for(var k in item.modified){
        var name = this.model + "[" + i + "]" + "[" + k + "]";
        // In case that is a datetime give it format
        if(typeof(item.data[k]) == 'object') {
          params[name] = item.data[k].format("Y-m-d H:i:s");
        }else {
          params[name] = item.data[k];
        }
      }
    }, data);
  }
});