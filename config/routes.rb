Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  devise_for :users, :controllers => {:registrations => "registrations"}
  # TODO: Shallow the routes for guesthouses, rooms and room_rates
  resources :guesthouses, only: %i[new create show edit update] do
    get 'search_by_city', on: :collection
    get 'search', on: :collection
    resources :rooms, only: %i[index new create show edit update] do
      resources :room_rates, only: %i[new create show edit update]
    end
  end
end
