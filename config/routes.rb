Rails.application.routes.draw do
  root to: "myproducts#index"

  devise_for :users, :controllers => { registrations: 'users/registrations' }

  resource :user
  resources :products
  resources :myproducts

  resources :products do
    resources :comments
    resources :line_items, only: [:create]
  end

  resources :line_items, only: [:destroy, :update]
   resources :carts do
    collection do
      get 'export_csv'
      get 'export_pdf'
    end
  end

  get 'carts/show', to: 'carts#show'
  get 'carts/cancel', to: 'carts#cancel'
  get 'carts/success', to: 'carts#success'
  post '/carts/apply_coupon', to: 'carts#apply_coupon'
  post '/line_items/checkout'
  post '/myproducts/remove_cart_item', to: 'myproducts#remove_cart_item',as: "myproducts_remove_cart_item"

end
