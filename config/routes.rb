Rails.application.routes.draw do
  root 'home#index'

  resources :chief_editors
  resources :writers
  resources :users
  resources :organizations

  resources :sessions, only: [:new, :create, :destroy]

  get 'sign-up', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
