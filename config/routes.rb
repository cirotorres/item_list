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

  # CARRINHO
  get    "cart",             to: "carts#show"
  post   "cart/add_item",    to: "carts#add_item"
  delete "cart/remove_item", to: "carts#remove_item"
  post   "cart/finalize",    to: "carts#finalize"

  get    "/orders",          to: "orders#index"

  # FAVORITOS
  post   "/favorites/add_item",       to: "favorites#add_fav"
  delete "/favorites/:item_id",       to: "favorites#remove_fav"
  get    "/favorites",                to: "favorites#show"

  resources :items do
    delete "images/:image_id", to: "items#purge_image", as: :purge_item_image
  end
end
