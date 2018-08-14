Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do 
        get '/find_all', to: 'search#index'
      end
    end
  end
end
