Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      
      namespace :merchants do
        get '/find_all', to: 'search#index'
        get '/find', to: 'search#show'
      end
      
      namespace :transactions do
        get '/find_all', to: 'search#index'
        get '/find', to: 'search#show'
      end

      namespace :items do
        get '/find_all', to: 'search#index'
        get '/find', to: 'search#show'
      end
      
      resources :transactions, only: [:index, :show] do
        get '/invoice', to: 'transactions/invoice#show'
      end

      resources :merchants, only: [:index, :show] do
        get '/items', to: 'merchants/items#show'
      end

      resources :invoices, only: [:index, :show]
      resources :items, only: [:index, :show]
    end
  end
end
