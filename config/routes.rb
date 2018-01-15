Rails.application.routes.draw do
  resources :seasons
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'leagues#index'
  resources :leagues, only: [:index, :show] do
    resources :seasons, only: [:index, :show] do
      resources :events, only: [:index, :show]
    end
  end
end
