Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :invoices do
        get '/find_all', to: 'search#index'
      end
      resources :invoices, only: [:index, :show]

      namespace :merchants do
        get '/find_all', to: 'search#index'
        get '/find', to: 'search#show'
      end

      resources :merchants, only: [:index, :show] do
        get '/items', to: 'merchants/items#show'
      end
    end
  end
end
