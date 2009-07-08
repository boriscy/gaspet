# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format 
# (all these examples are active by default):
ActiveSupport::Inflector.inflections do |inflect|
  #inflect.plural(/^([a-z_]+)on$/i, '\1ones')
  # Para cambiar todas las palabras que terminan en consonante y aumentarles es al final
  inflect.plural(/^([a-z_]+)([^aeiou])$/i, '\1\2es')
  # inflect.singular /^(ox)en/i, '\1'
  inflect.irregular('volumen_asignado', 'volumenes_asignados')
  inflect.irregular('parte_diario', 'partes_diarios')
  inflect.irregular('user', 'users')
  inflect.irregular('session', 'sessions')
  inflect.irregular('zona_comercial', 'zonas_comerciales')
#   inflect.uncountable %w( fish sheep )
end
