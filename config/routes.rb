Rails.application.routes.draw do
  root "users#welcome"

  get "register" => "users#register"
  post "register" => "users#create"

  get "login" => "sessions#new"
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy"

  get "channel" => "channel#index"
  get "conversation/:username" => "channel#conversation", as: :pm

end
