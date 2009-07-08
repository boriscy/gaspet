class CategoriasController < ApplicationController
  
  # Presenta una lista de categorias
  def lista
    tree = TreeCreator.new({:id => :id, :text=>:nombre })
    categorias = tree.create_tree Categoria.find(:all)
    categorias = set_check(categorias)
    render :json => categorias
  end

  protected

  # Metodo que aumenta el parametro check a los nodos del arbol de forma recursiva
  def set_check(tree)
    tree.map do |v|
      v[:checked] = false
      if v[:children].length > 0
        set_check(v[:children])
      end
    end
    tree
  end
end
