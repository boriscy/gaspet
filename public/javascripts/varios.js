/**
* Presenta un elemento el la posición que se le indica
* @param Event e Evento que genero la acción
* @param string sel Selector del tipo css
*/
function posElem(target, sel) {

  var elem = $(target);
  var pos = elem.position();
  var ew = elem.outerWidth();
  var eh = elem.outerHeight();
  var height = $(sel).outerHeight();
  var width = $(sel).outerWidth();
  var tX = pos.left;
  var tY = height + pos.top - eh + 2;
  var pX = window.innerWidth + window.scrollX;
  var pY = window.innerHeight + window.scrollY;

  // Posicionar abajo o arriba
  if(pX < (tX + width)) {
    tX = pos.left - ((3/2) * ew + 5);
  }
  if(pY < (tY + eh + 10)) {
    tY = pos.top - (height + 4);
  }
  $(sel).css({left: tX+'px', top: tY+'px'});
}

jQuery(document).ready(function(){
  (function($){
    $('.error').live("mouseover", function(e){
      var target = e.target || e.srcElement;
      $('#error-msg div.msg').html($(target).attr('error') );
      $('#error-msg').show();
      posElem(target, '#error-msg');
    }).live("mouseout", function(e){
      $('#error-msg').hide();
    });
  })(jQuery);
});

