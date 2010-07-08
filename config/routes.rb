ActionController::Routing::Routes.draw do |map|
  map.resources :clients,
  :collection => { :csv_import => :post },
  :member => { :purchase => :put, :leave => :put } do |client|
    client.resources :representatives
  end
end
