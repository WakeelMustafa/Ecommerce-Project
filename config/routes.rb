Rails.application.routes.draw do
  get 'carts/show'
  devise_for :users, :controllers => { registrations: 'users/registrations' }
  root to: "myproducts#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resource :users do
  end
  resources:products
  resources:myproducts

  resources :products do
    resources :comments
    resources :line_items, only: [:create]
  end
  resources :line_items, only: [:destroy, :update]
end
