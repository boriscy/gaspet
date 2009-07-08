/*
 * @created Mindplay extjs.com/forum
 *
 *
 Example:
 Ext.onReady(function(){
  new Ext.ux.JSLoader({
    url: '/scripts/my_script.js',
    onLoad: function(options) { alert('Script Loaded'); },
    onError: function(options, e) { alert('Error loading script'); }
  });
});
 * and open the template in the editor.
 */


 Ext.ux.JSLoader = function(options) {

  Ext.ux.JSLoader.scripts[++Ext.ux.JSLoader.index] = {
    url: options.url,
    success: true,
    options: options,
    onLoad: options.onLoad || Ext.emptyFn,
    onError: options.onError || Ext.ux.JSLoader.stdError
  };

  Ext.Ajax.request({
    url: options.url,
    scriptIndex: Ext.ux.JSLoader.index,
    success: function(response, options) {
      var script = 'Ext.ux.JSLoader.scripts[' + options.scriptIndex + ']';
      window.setTimeout('try { ' + response.responseText + ' } catch(e) { '+script+'.success = false; '+script+'.onError('+script+'.options, e); }; if ('+script+'.success) '+script+'.onLoad('+script+'.options);', 0);
    },
    failure: function(response, options) {
      var script = Ext.ux.JSLoader.scripts[options.scriptIndex];
      script.success = false;
      script.onError(script.options, response.status);
    }
  });

}

Ext.ux.JSLoader.index = 0;
Ext.ux.JSLoader.scripts = [];

Ext.ux.JSLoader.stdError = function(options, e) {
  window.alert('Error loading script:\n\n' + options.url + '\n\n(status: ' + e + ')');
}