Rails.application.routes.draw do
  resource :session, only: [:new, :create, :destroy]
  resources :registrations, only: [:new, :create]
  resources :articles do
    member do
      post :report
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "articles#index"
end