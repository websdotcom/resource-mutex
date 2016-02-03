Rails.application.routes.draw do
  resources :resources, param: :name, only: [:create, :destroy] do
    resources :locks, param: :owner,  only: [:create, :destroy]
  end
end
