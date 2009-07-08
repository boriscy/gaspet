/**
* Rails.importFromFile
* @author   Boris Barroso
* @version  Version 0.7
* @date     2009-01-02
* Componente  en forma de boton que permite realizar la importación de datos de un Archivo y retorna
* el JSON despues de haber sido importado
* Ej:
* new Rails.importFromFile({
*       url: '/parte_diario/importar', // URL al cual se importa
*       parentCmp: this, // Componente parent en el cual se encuentra este elemento
*       importCallback: this.retorno, // Función definida en el parentCmp para hacer callback despues de haberse hecho la importación
*       text: 'Importar parte diario', // Texto que va en el botón
*       scope: this // Scope del boton
*     })
*/
Rails.importFromFile = function(config) {

  Ext.apply(this, config);
  
  Rails.importFromFile.superclass.constructor.call(this, {
    text: config.text || 'Importar',
    handler: this.showForm,
    importCallback: config.importCallback || this.importCallback,
    scope: this
  });
}

Ext.extend(Rails.importFromFile, Ext.Button, {

  parentCmp: {},
  fieldLabelText: 'Arhivo', // Texto del label del archivo
  labelWidth: 70, // ancho del Label de importación
  iconCls: 'rails-upload',
  importButtonText: 'Importar',
  /**
   * Funcion que se debe llamar despues de haberse realizado la importación
   */
  importCallback: function(){},
  /**
   * Url al cual se debe acceder para poder realizar la importación
   */
  url: '',
  /**
   * Funcion que realiza la importacion de los datos, presenta una ventana con un formulario
   */
  showForm: function() {
    
    var w = new Ext.Window({
      title: 'Importar Datos',
      width: 400, modal: true,
      items:[{
        xtype: 'form',
        fileUpload: true,
        // Url al cual se envia el archivo
        url: this.url,
        maskDisabled: false,
        labelWidth: this.labelWidth,
        bodyStyle: 'padding: 4px',
        items:[{
          xtype: 'hidden', name: 'authenticity_token', value: AUTH_TOKEN
        },{
          xtype:'textfield', fieldLabel: this.fieldLabelText, width: 300, inputType: 'file', name: 'file'
        }],
        buttons:[{
          text: this.importButtonText,
          handler: this.importData,
          scope: this
        }]
      }]
    });
    w.show();
    this.window = w;
    this.forma = w.items.itemAt(0);
  },
  /**
   * Funcion que permite la importación de los datos cuando se ingresa la forma
   * si se realiza la importación correctamente se hace una llamada a un callback
   * una función definida en otro objeto o contexto con los datos obtenidos de la importación
   */
  importData: function() {
    
    this.forma.getForm().submit({
      scope: this,
      success: function(a, b) {
        
        try {
          var res = Ext.decode(b.response.responseText);
        } catch (e) {
          b.failure();
          return false;
        }
        // Llamar a la función indicada despues de haberse importado los datos
        if(res.success) {
          this.window.close();
          this.importCallback.call(this.parentCmp, res.data);
          //this.importCallback.apply(this, [res.data]);
        }
        //this.forma.getComponent('archivo').reset('');
      },
      failure: function(a, b) {
        Ext.Msg.show({
          title:'Error',
          msg:'Existio un Error al importar el archivo.',
          buttons: Ext.MessageBox.OK,icon:Ext.MessageBox.ERROR
        });
      }
    });
  }
});