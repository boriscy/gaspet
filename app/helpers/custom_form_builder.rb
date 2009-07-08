# Usado para poder crear con formato distionto las formas
# Ejemplo
# ===
# <% form_for(@pagina, :builder => ErrorBuilder) do |f| %>
#   <%= f.error_messages %>
#   <%= f.text_field :titulo, :label => 'Título' %>
#   <%= f.text_field :slug, :label => 'Slug' %>
#   <%= f.text_area :contenido, :label => 'Contenido' %>
#   <%= f.check_box :publicar, :label => 'Públicar', :label_pos => 'r' %>
# <% end %>
#
# Produce
# <form action="/paginas" class="new_pagina" id="new_pagina" method="post"><div style="margin:0;padding:0"><input name="authenticity_token" type="hidden" value="BffRrtYERjfjIsjbpgfJxuwPFDRJGZzPcDiDJeFvNyE=" /></div>
#
#  <div class="input">
#    <label for="pagina_titulo">Título</label>
#    <input id="pagina_titulo" label="Título" name="pagina[titulo]" size="30" type="text" />
#  </div>
#  <div class="input">
#    <label for="pagina_slug">Slug</label>
#    <input id="pagina_slug" label="Slug" name="pagina[slug]" size="30" type="text" />
#  </div>
#  <div class="input">
#   <label for="pagina_contenido">Contenido</label>
#   <textarea cols="40" id="pagina_contenido" label="Contenido" name="pagina[contenido]" rows="20"></textarea>
#   </div>
#  <div class="input">
#    <input name="pagina[publicar]" type="hidden" value="0" />
#    <input id="pagina_publicar" label="Públicar" name="pagina[publicar]" type="checkbox" value="1" />
#    <label for="pagina_publicar">Públicar</label>
#  </div>
#  <div class="input">
#    <input name="commit" type="submit" value="Crear" />
#  </div>
# </form>
class CustomFormBuilder < ActionView::Helpers::FormBuilder
  helpers = field_helpers +
            %w{date_select datetime_select time_select} +
            %w{collection_select select country_select time_zone_select} -
            %w{hidden_field label fields_for} # Don't decorate these

  helpers.each do |name|
    define_method(name) do |field, *args|
      options = args.extract_options!
      # options = args.last.is_a?(Hash) ? args.pop : {}
      if options[:label]
        label = label(field, options[:label], :class => options[:label_class])
        options.delete(:label)
      else
        label = ""
      end

      # Obtener los errores
      errors = errors_in(object, field)
      unless errors == ""
        options[:error] = errors
      end
      # En caso de que no haya el default es izquierda, cuando sea igual a "r" se ira  a la derecha
      # options[:label_pos]
      if options[:label_pos] == 'r'
        text = super + label
        options.delete(:lpos)
      else
        text = label + super
      end
      @template.content_tag(:div, text, :class => 'input')  #wrap with a paragraph
    end
  end

  # Campo que permite crear un campo de texto con los parametros necesarios para que pueda funcionar
  # el selector de fecha de jQuery
  def date_field(field, *args)
    options = args.extract_options!
    if options[:value].nil? && object.send(field).nil?
      options[:value] = Date.today.strftime(I18n.t 'date.formats.default')
    elsif !object.send(field).nil? && options[:value].nil?
      options[:value] = object.send(field).strftime(I18n.t 'date.formats.default')
    end
    options[:class] = "fecha fechaon"
    text_field(field, options)
  end

  protected
  # Clase que permite presentar errores del modelo
  def errors_in(model, field)
    retString = ""
    if model.errors[field]
      if model.errors[field].class.to_s == "Array"
        retString = model.errors[field].join("<br/>")
      else
        retString = model.errors[field]
      end
    end
    retString
  end

end
