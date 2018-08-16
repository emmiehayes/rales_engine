Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do

      namespace :invoices do
        get '/find_all', to: 'search#index'
        get '/find', to: 'search#show'
      end

      resources :invoices, only: [:index, :show] do
        get '/customer', to: 'invoices/customer#show'
        get '/merchant', to: 'invoices/merchant#show'
        get '/transactions', to: 'invoices/transactions#index'
        get '/items', to: 'invoices/items#index'
        get '/invoice_items', to: 'invoices/invoice_items#index'
      end

      namespace :merchants do
        get '/find_all', to: 'search#index'
        get '/find', to: 'search#show'
        get '/most_revenue', to: 'most_revenue#index'
      end
      
      resources :merchants, only: [:index, :show] do
        get '/items', to: 'merchants/items#show'
        get '/favorite_customer', to: 'merchants/favorite_customer#show'
      end

      namespace :transactions do
        get '/find_all', to: 'search#index'
        get '/find', to: 'search#show'
      end

      resources :transactions, only: [:index, :show] do
        get '/invoice', to: 'transactions/invoice#show'
      end

      namespace :invoice_items do
        get '/find_all', to: 'search#index'
        get '/find', to: 'search#show'
      end

      resources :invoice_items, only: [:index, :show] do
        get '/invoice', to: 'invoice_items/invoice#show'
        get '/item', to: 'invoice_items/item#show'
      end

      namespace :items do
        get '/find_all', to: 'search#index'
        get '/find', to: 'search#show'
      end

      resources :items, only: [:index, :show] do
        get '/invoice_items', to: 'items/invoice_items#index'
        get '/merchant', to: 'items/merchant#show'
      end

      namespace :customers do
        get '/find_all', to: 'search#index'
        get '/find', to: 'search#show'
      end

      resources :customers, only: [:index, :show] do
        get '/invoices', to: 'customers/invoices#show'
        get '/transactions', to: 'customers/transactions#show'
      end

    end
  end
end
