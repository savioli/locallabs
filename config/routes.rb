Rails.application.routes.draw do
  root 'home#index'

  resources :chief_editors
  resources :writers
  resources :users
  resources :organizations

  resources :sessions, only: [:new, :create, :destroy]

  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  
  get ':id', to: 'home#index', constraints: { id: /\d+/ }

  get 'stories/new', to: 'stories#new'
  post 'stories/create', to: 'stories#create'
  
  get 'stories/:id/edit', to: 'stories#edit', constraints: { id: /\d+/ }
  post 'stories/:id/update', to: 'stories#update', constraints: { id: /\d+/ }
  post 'stories/:id/status', to: 'stories#status', constraints: { id: /\d+/ }
  post 'stories/:id/comment', to: 'stories#comment', constraints: { id: /\d+/ }

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
