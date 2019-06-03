Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  root to: 'articles#index'
  resources :articles

  post "/upload_image" => "upload#upload_image", :as => :upload_image
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
