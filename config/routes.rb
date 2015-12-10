Rails.application.routes.draw do
  post   "login"       => "sessions#create"
  delete "logout"      => "sessions#destroy"

  get  "products"      => "products#index"

  get  "register"      => "register#index"
  post "register"      => "register#create"

  get "customer"       => "customer#index"

  get "external_links" => "external_links#index"

  root to: "index#index"
end
