/**
 * jQuery grider
 * Versión 0.7
 * @author: Boris Barroso Camberos
 * @email: boriscyber@gmail.com
 * @license MIT
 * http://www.opensource.org/licenses/mit-license.php
 */
(function($) {

    $.fn.extend({
        grider: function(config) {
            return this.each(function(){
                new $.Grider(this, config);
            });
        }
    });

  /**
  * Transforma un grid que contiene datos asi como elementos de formulario para permitri realizar calculos
  * de una forma simple, para poder utilizar se lo hace de la siguiente forma
  * <table id="grid">
  *   <tr>
  *     <th col="precio" summary="min">Precio</th>
  *     <th col="cantidad">Cantidad</th>
  *     <th formula="precio*cantidad" summary="sum">Subtotal</th>
  *   </tr>
  *   <tr>
  *     <td>Precio</td>
  *     <td>Cantidad</td>
  *     <td></td>
  *   </tr>
  * </table>
  *
  * Y despues se ejecuta $('#grid').grider({initCalc: false});
  *
  * @attr col: Define el nombre o identificador único para cada columna de la tabla
  *
  * @attr summary: Define un campo de suma o total que adiciona una fila al final de la tabla y
  * que puede realizar las operaciones "sum" (Suma), "avg" (Promedio), "max" (Máxmimo),
  * "min" (Mínimo) y "count" (Conteo)
  *
  * @attr formula: Calculala formula que se escribe con las columnas que se haya introducido, el resultado
  * es presentado en la columna donde ha sido definido
  *
  * Configuraciones de la variable config
  * @param boolean config['initCalc'] Define si se realizara los calculos de (formula) al iniciar
  *
  * @param boolean config['addRow'] Define si es que aparecera un icono para poder adicionar filas
  * @param string config['addRowText'] Texto que aparecera dentro del caption, debe tener la siguiente
  * forma <caption><a href="#">$Contenido</a></caption>donde $contenido puede ser cualquier cadena HTML que se presentará
  * @param boolean config['delRow'] Define si es que aparecera un vinculo para borrar la fila
  * @param string config['delRowText'] Texto que aparecerá para poder borrar fila, el texto siempre debe tener la clase (delete)
  * ej: <a href="#" class="delete">borrar</a>
  * @param boolean config['countRow'] Indica si es que se va a realizar el conteo de las filas, esto permite que una correcta numeración
  * cuando se añade o se borran filas
  * @param integer config['countRow'] Define en que columna se generara los numeros de cada fila
  * @param boolean config['countRowAdd'] Indica si es que se va adicionar una columna
  */
    $.Grider = function(table, config) {

        /**
         * Valores por defecto
         */
        var defaults = {
            initCalc: true,
            addRow: true,
            delRow: true,
            addRowText: '<caption><a href="#">Adicionar Fila</a></caption>',
            delRowText: '<td><a href="#" class="delete">borrar</a></td>',
            countRow: false,
            countRowRow: 0,
            countRowAdd: false
        };
        if(config) {
            for(var k in defaults) {
                config[k] = config[k] || defaults[k];
            }
        }else{
            config = defaults;
        }

        var cols = {};
        // Identifica si la fila de summary fue creada
        var summaryRow = false;
        var formulaSet = false; // Indica si es que se a adicionado una formula
        config = config || {};
        setGrider(table);

        /**
        * Prepara todos los datos a ser usados en la tabla
        * @param DOM t Tabla que se recive
        */
        function setGrider(t) {
            $(table).find('tr:first').addClass('noedit');
            for(var i = 0, l = t.rows[0].cells.length; i < l; i++) {
                setColumn(t.rows[0].cells[i], i);
            }
            // Necesario para poder realizar las formulas
            for(var i = 0, l = t.rows[0].cells.length; i < l; i++) {
                setFormula(t.rows[0].cells[i]);
                setSummary(t.rows[0].cells[i]);
            }
            setColType();
            // Calcular formulas la primera ves
            if(formulaSet && config.initCalc) {
                var rows = $(table).find('tr:not(.noedit)');
                rows.each(function(index, elem) {
                    for(var k in cols) {
                        if(cols[k].formula) {
                            calculateFormula(cols[k].formula, elem, k);
                        }
                    }
                });
            }
            for(var k in cols){
                if(cols[k].summary)
                    calculateSummary(cols[k]);
            };
            // Permitir adiconado de filas
            if(config['addRow']) {
                $(table).append(config['addRowText']);
                $(table).find("caption a").click(function() {
                    addRow();
                });
            }

            // Permitir borrar filas
            if(config['delRow']) {
                $(table).find('tr:not(.noedit)').each(function(index,elem){
                    $(elem).append(config['delRowText']);
                });
                $(table).find('a.delete').live("click", function(){
                    delRow(this);
                });
            }

            // Permite contar las filas
            if(config['countRow']) {
                if(config['countRowAdd']) {
                    $(table).find('tr.noedit:first').prepend('<th>Nº</th>');
                    $(table).find('tr:not(.noedit)').each(function(index, elem){
                        var ind = index+1;
                        $(elem).prepend('<td>'+ind+'</td>');
                    });
                }
            }
        }

        /**
        * Determina el tipo de elemento que contiene cada elemento para poder seleccionar
        */
        function setColType() {
            var row = $('#grid tr:not(.noedit):first')[0]; // Encuentra la primera fila que no tenga clase .noedit en su tr (fila)
            for(var k in cols) {
                var cell = $(row).find('td:eq(' + cols[k].pos + ')')[0];

                if(cell.firstChild && cell.firstChild.nodeType == 1) {

                    var type = cell.firstChild.nodeName.toLowerCase();
                    switch(type) {
                        case 'input':
                            cols[k]['type'] = 'input[type="'+ cell.firstChild.type +'"]';
                            break;
                        case 'select':
                            cols[k]['type'] = 'select';
                            break;
                        case 'textarea':
                            cols[k]['type'] = 'textarea';
                            break;
                        default:
                            cols[k]['type'] = 'input[type="text"]';
                            break;
                    }
                }else{
                    // sirve para poder utilizar el selector jQuery
                    cols[k]['type'] = '';
                }
            }
        }

        /**
         * Permite definir las columnas según su nombre
         * @param DOM cell Celda o TD que se esta revisando
         * @param integer pos Número de columna comenzando desde 0
         */
        function setColumn(cell, pos) {
            var col = $(cell).attr('col');
            if(col)
                cols[col] = {
                    pos: pos,
                    name: col
                };
        }

        /**
         * Permite que las columnas puedan realizar operaciones para hacer sumas, promedios, etc en la columna
         * @param DOM cell Celda
         */
        function setSummary(cell) {
            var summary = $(cell).attr('summary');
            var col = $(cell).attr('col');
            if(summary == 'sum' || summary == 'avg' || summary == 'max' || summary == 'min' || summary == 'count') {
                cols[col]['summary'] = summary;
            }

            // Adicionar la fila de summary
            if(!summaryRow) {
                var l = table.rows[0].cells.length;
                var html = '<tr class="summary noedit">';
                for(var i=0; i<l; i++) {
                    html+='<td>&nbsp;</td>';
                }
                html+='</tr>';
                jQuery(table).append(html);
                summaryRow = true;
            }
        }

        /**
        * Permite calcular los summary que son resumenes de total al final de la fila
        * @param object col
        */
        function calculateSummary(col) {
            //console.log("Calc Sum %o", col);//
            var summary = col.summary;
            var cells = $(table).find('tr:not(.noedit) td:eq(' + col.pos + ')');
            var res = 0, sum = 0, max = null, min = null;

            if(summary != 'count') {
                var val = 0;

                cells.each(function(index, elem) {
                    if(col.type == "") {
                        val = $(elem).html() * 1;
                    }else{
                        val = $(elem).find(col.type).val() * 1;
                    }

                    switch(summary) {
                        case 'sum':
                            sum+=val;
                            break;
                        case 'avg':
                            sum+=val;
                            break;
                        case 'max':
                            if(!max){
                                max = val;
                            } else if(max < val) {
                                max = val;
                            }
                            break;
                        case 'min':
                            if(!min){
                                min = val;
                            } else if(min > val) {
                                min = val;
                            }
                            break;
                    }
                });

                switch(summary) {
                    case 'sum': res = sum; break;
                    case 'avg': res = sum/cells.length; break;
                    case 'max': res = max; break;
                    case 'min': res = min; break;
                }
            }else{
                res = cells.length;
            }
            $(table).find('tr.summary td:eq(' + col.pos +')').html(res);
        }


        /**
         * Llama a la función o funciones que sean requiridas
         * @param Event e Evento que se generó
         */
        function fireCellEvent(e) {
            var target = e.target || e.srcElement;
            if(target.nodeType == 1) {
                calculate(e);
                target = $(target).parent('td')[0];
                var col = findColBy(target.cellIndex, 'pos');

                for(var k in cols) {
                    try{
                        var reg = '\\b'+ col.name +'\\b';
                        reg = new RegExp(reg);
                        if(reg.test(cols[k].formula) && cols[k].summary) {
                            calculateSummary(cols[k]);
                        }
                        if(col.summary)
                            calculateSummary(cols[k]);
                    }catch(e){}
                }

            }else{
                col = jQuery(target).parents('td').eq(0)[0].cellIndex;
            }
        }

        /**
         * Permite crear las funciones para cada una de las celdas
         * @param DOM cell Celda o TD del cual se exrae la formula
         */
        function setFormula(cell) {
      
            formulaSet = true;
            var formula = $(cell).attr('formula');
            var col = $(cell).attr('col');
            if(formula) {
                cols[col]['formula'] = formula;
        
                // Regitrar elementos que causan que se ejecute el calculo (Adición de eventos)
                for(var k in cols) {
                    reg = "\\b" + k + "\\b";
                    var reg = new RegExp(reg);
          
                    if( reg.test(formula))
                        setEvent(k);
                }
            }
        }

        /**
        * Prepara los evento que son adicionados a los elementos dentro del grid
        * @param string col Nombre de la columna
        */
        function setEvent(col) {
            if(!cols[col].event) {
                var type = 'input[type="text"]';
                if(config.col && config.col.type) {
                    type = config.col.type;
                }
                
                var exp = 'tr td:eq(' + cols[col]['pos'] + ') ' + type;
                //$(table).find(exp).change( function(e){ debug('cambio')});///
                $(table).find(exp).live("change", function(e) {
                    debug(exp+' '+$(table).find(exp).length);//////
                    fireCellEvent(e);
                    cols[col].event = true;
                });
            }
        }

        /**
        * Calcula la formula o formulas que se puedan haber generado en el evento enviado
        * @param Event e Evento que inicio el calculo
        */
        function calculate(e) {

            var target = e.target || e.srcElement;
            var row = $(target).parents('tr').eq(0);
            var col = $(target).parents('td').eq(0)[0].cellIndex;
            var i = 0;
            col = findColBy(col, 'pos').name;
      
            for(var k in cols) {
                reg = "\\b" + col  + "\\b";
                var reg = new RegExp(reg);
                if(cols[k].formula && reg.test(cols[k].formula)) {
                    calculateFormula(cols[k].formula, row, k);
                }
            }
        }

        /**
         * Calcula la formula que se la hay enviado en la fila
         * @param String formula Formula a ser evaluada
         * @param DOM row Fila den la cual se ejecuta la formula
         * @param string col Nombre de la columna a calcular
         */
        function calculateFormula(formula, row, col) {

            var pat = formula.match(/\b[a-z_]+\b/g);
            var formu = formula;

            // Solución para IE
            for(var k in pat) {
                if(!/^\d+$/.test(k)) {
                    delete(pat[k]);
                }
            }
      
            for(var k in pat) {
                var exp = 'td:eq(' + cols[pat[k]].pos + ') ' + cols[pat[k]].type;
                var val = parseFloat( $(row).find(exp).val() ) || 0;
                var reg = new RegExp('\\b' + pat[k] + '\\b')
                formu = formu.replace(reg, val);
            }

            var res = eval(formu);
            // Posicionando la respuesta correspondiente
            var cell = $(row).find('td:eq(' + cols[col].pos + ')');
            if(cols[col].type == "") {
                $(cell).html(res);
            }else{
                $(cell).find(type).html(res);
            }
        }

        /**
         * Encuentra un valor o valores
         * @param string bus Parametro de busqueda
         * @param string prop Proiedad de la columna a buscar
         * @return object Retorna la parte delobjeto de la columna
         */
        function findColBy(bus, prop) {
            for(var k in cols) {
                if(bus == cols[k][prop]) {
                    return cols[k];
                }
            }
        }

        /**
         * Función que adiciona una nueva fila basada en el primera fila que permite edición
         */
        function addRow() {
            var tr = $(table).find('tr:not(.noedit):first').clone();
            $(tr).find("td").each(function(index, elem) {
                if($(elem).find("input, select, textarea").length > 0) {
                    $(elem).find("input, select, textarea").val('');
                }else{
                    $(elem).html('&nbsp;');
                }
            });
            if(config['countRow']) {
                var fila = parseInt($(table).find('tr:not(.noedit):last td:eq('+ config['countRowRow'] +')').html()) + 1;
                $(tr).find('td:eq('+ config['countRowRow'] +')').html(fila);
            }
            $(table).find('tr:not(.noedit):last').after(tr);
        }

        /**
         * Permite borrar una fila
         */
        function delRow(elem) {
            $(elem).parents('tr').remove();
            if(config['countRow']) {
                rowNumber();
            }
        }

        /**
         * Numera las filas cuando se borran
         */
        function rowNumber() {
            $(table).find('tr:not(.noedit) td:eq('+config['countRowRow']+')').each(function(index, elem) {
                var ind = index + 1;
                $(elem).html(ind);
            });
        }
        
        return {
            cols: cols,
            summaryRow: summaryRow,
            table: table,
            formulaSet: formulaSet,
            calculateFormula: calculateFormula,
            setGrider: setGrider,
            setColumn: setColumn,
            calculate: calculate,
            fireCellEvent: fireCellEvent,
            setColType: setColType,
            findColBy: findColBy,
            addRow: addRow,
            delRow: delRow,
            rowNumber: rowNumber
        }
    }

    $.Grider.events = function() {
        return 'nuevo';
    }

})(jQuery);