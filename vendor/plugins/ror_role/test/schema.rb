ActiveRecord::Schema.define(:version => 0) do
  # Tabla que almacena todos los grupos
  create_table :groups, :force => true do |t|
    t.string :name

    t.timestamps
  end

  # Tabla que almacena los privilegios por controlador y acción
  # en el campo actions es donde se almacena todas las acciones a las cuales
  # el usuario tiene permiso
  create_table :roles, :force => true do |t|
    t.integer :group_id
    t.string :controller
    t.string :actions

    t.timestamp
  end
end

