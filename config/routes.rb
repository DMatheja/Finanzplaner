Rails.application.routes.draw do
  root 'pages#home'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  resources :users
  resources :categories
  resources :products
  resources :transactions
  resources :income
  resources :subscriptions
  resources :goals
  resources :groups
end
