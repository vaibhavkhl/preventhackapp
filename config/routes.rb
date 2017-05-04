Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'prevent_hack#new'
  resources :prevent_hack, only: [:new, :create]
end
