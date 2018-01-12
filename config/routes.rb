Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'leagues#index'
  resources :leagues do
    resources :seasons do
      resources :events
    end
  end
end
