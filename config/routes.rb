Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  devise_for :users, :controllers => {:registrations => "registrations"}
  devise_scope :user do
    get 'additional_info/:id', to: 'registrations#additional_info', as: 'new_additional_info'
    post 'save_additional_info/:id', to: 'registrations#save_additional_info', as: 'save_additional_info'
  end

  # TODO: Shallow the routes for guesthouses, rooms and room_rates
  resources :guesthouses, only: %i[new create show edit update] do
    resources :reviews, only: %i[index]
    resources :rooms, only: %i[index new create show edit update] do
    end
  end

  resources :rooms, only: %i[] do
    post 'availability', to: 'bookings#availability'
    post 'final_confirmation', to: 'bookings#final_confirmation'
    get 'final_confirmation', to: 'bookings#final_confirmation'
    resources :room_rates, only: %i[new create show edit update]
    resources :bookings, only: %i[new create] do
      collection do
        get :confirm
      end
    end
  end

  resources :bookings, only: %i[index show] do
    collection do
      get :guesthouse_owner
      get :active
    end
    member do
      patch :cancel
      patch :cancel_by_guesthouse_owner
      patch :check_in
      get :check_out
      patch :check_out
    end
    resources :reviews, only: %i[new create]
  end

  resources :searches, only: %i[index] do
    collection do
      get :guesthouses_by_city
      get :guesthouses_general
      get :guesthouses_advanced
    end
  end

  resources :reviews, only: %i[update] do
    get 'guesthouse_owner', to: 'reviews#guesthouse_owner', on: :collection
    get :respond, on: :member
  end

  namespace :api do
    namespace :v1 do
      resources :guesthouses, only: %i[index show] do
        resources :rooms, only: %i[index]
      end
    end
  end
end
