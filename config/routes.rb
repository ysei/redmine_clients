ActionController::Routing::Routes.draw do |map|
  map.resources :clients, :member => { :purchase => :put, :leave => :put } do |client|
    client.resources :representatives
  end
end
