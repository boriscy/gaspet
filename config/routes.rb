ActionController::Routing::Routes.draw do |map|
  map.resources :saldos

  map.resources :precios

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users

  map.resource :session

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "reportses", :action => "index"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
