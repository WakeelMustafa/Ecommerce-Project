Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'users/registrations' }
  root to: "myproducts#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resource :users do
end
  resources:products
  resources:myproducts
end
