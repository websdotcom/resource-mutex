Rails.application.routes.draw do
  resources :resources, param: :name, only: [:create] do
    resource :locks, only: [:create, :destroy]
  end
end
