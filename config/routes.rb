Rails.application.routes.draw do
  get 'show' => 'users#show'
  resources :users
  root 'users#index'
end
