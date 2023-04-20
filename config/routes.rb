Rails.application.routes.draw do
  resources :sessions, only: [:create, :destroy]
  post '/login', to: 'auth#login'
  post '/logout', to: 'auth#logout'
  resources :users, only: [:create, :update, :show, :destroy]
end
