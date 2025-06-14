Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  post "/login", to: "auth#login"
  post "/register", to: "user#create"
  patch "/me", to: "user#update_me"
  get "/me", to: "user#me"
  resources :items do
    delete "images/:image_id", to: "items#purge_image", as: :purge_item_image
  end
end
