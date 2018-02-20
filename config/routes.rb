Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :products
  resource :cart, only: [:show, :destroy] do
    collection do
      post :add, path:'add/:id'
    end
  end
end
