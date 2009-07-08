# Métodos adicionados como helpers para la aplicación
module ApplicationHelper
  def combo_data(data, name = 'nombre', json = true)
    ret = []
    data.each{|v| ret.push([v.id, v.send(name)])}
    if json
      ret.to_json
    else
      ret
    end
  end

  # Outputs the corresponding flash message if any are set
  def flash_messages
    messages = ""
    flash.each do |key, msg|
      messages << content_tag(:div, link_to_function(image_tag("icons/cross.png"), "$('#flash').hide()", :class => "close", :title => t("Cerrar mensaje")) + msg , :class => key, :id => 'flash')
    end
    flash.discard
    messages
  end

  # Alias para number_to_curency, los valores por defecto se definen el los locales
  def ntc(val, args={} )
    number_to_currency val, args
  end

  # Clase que permite presentar errores del modelo
  def errors_in(object, field, attr = {:error => 'error'})
    ret = {}
    if object.errors[field]
      if object.errors[field].class.to_s == "Array"
        temp = object.errors[field].join("<br/>")
      else
        temp = object.errors[field]
      end
      ret[attr[:error]] = temp
    end
    ret
  end

  def method_missing(method, *args)
    if method.to_s =~ /\A^input_(text|hidden|radio|checkbox)\Z/
      type = method.to_s.gsub(/\A^input_(text|hidden|radio|checkbox)$\Z/, '\1')
      if args[2]
        args[2][:type] = type
      else
        args[2] = {:type => type}
      end
      input(args[0], args[1], args[2])
    end
  end

  def input(object, field, attr = {:type => 'text'})
    errors_in(object, field).each{|k, v| attr[k] = v}

    if object.type.to_s == "String"
      name = object.type.to_s
    else
      name = object.class.to_s.downcase
    end
    case(attr[:type])
    when 'text'
      attr[:value] = object[field]
      text_field(name, field, attr)
    when 'radio'
      radio_button(name, field, attr[:value] ,  attr)
    when 'checkbox'
      attr[:checked] = attr[:value]
      attr.delete(:value)
      check_box(name, field, attr)
    end
  end
end
