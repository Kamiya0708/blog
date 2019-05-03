Rails.application.routes.draw do
  resources :articles

  post "/upload_image" => "upload#upload_image", :as => :upload_image
  post "/delete_image" => "upload#delete_image", :as => :delete_image
  get "/download_file/:name" => "upload#access_file", :as => :upload_access_file, :name => /.*/
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
