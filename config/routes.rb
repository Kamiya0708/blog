Rails.application.routes.draw do
  resources :articles

  post "/upload_image" => "upload#upload_image", :as => :upload_image
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
