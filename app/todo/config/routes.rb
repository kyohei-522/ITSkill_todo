Rails.application.routes.draw do
  root to: "tasks#index"
  get 'auth/:provider/callback', to: 'login#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'login#destroy', as: 'signout'

  resources :login, only: [:create, :destroy]
  resources :tasks do
    post "check"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
