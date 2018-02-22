Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :products do
    member do
      post :checkout
    end
  end
  resource :cart, only: [:show, :destroy] do
    collection do
      post :add, path:'add/:id'
      delete :remove , path: 'remove/:id'
    end
  end
end
