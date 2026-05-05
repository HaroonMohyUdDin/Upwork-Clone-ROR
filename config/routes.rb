Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  root "home#index"

  get "freelancer-dashboard", to: "freelancer_dashboard#index", as: :freelancer_dashboard
  get "freelancer-profile/edit", to: "freelancer_dashboard#edit_profile", as: :edit_freelancer_profile
  patch "freelancer-profile/update", to: "freelancer_dashboard#update_profile", as: :update_freelancer_profile
  get "client-dashboard", to: "client_dashboard#index", as: :client_dashboard

  resources :skills, only: [:create, :edit, :update, :destroy]

  resources :jobs do
    resources :proposals, only: [:create, :index] do
      member do
        patch :accept
        patch :reject
      end
    end

    resources :reviews, only: [:new, :create]
  end

  resources :proposals, only: [] do
    member do
      patch :accept
      patch :reject
    end
  end

    resources :proposals, only: [:index]

    resources :contracts, only: [:show, :update, :index]

  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end

  resources :reviews, only: [:create]
  resources :payments, only: [:new, :create, :index]
  resources :users, only: [:show, :edit, :update], constraints: { id: /\d+/ }

  get "up" => "rails/health#show", as: :rails_health_check
end
