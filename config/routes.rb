Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  root "home#index"

  # CLIENT DASHBOARD - NO NAMESPACE
  get "/client-dashboard", to: "client_dashboard#index", as: :client_dashboard
  get "/client-job-proposals/:job_id", to: "client_dashboard#job_proposals", as: :client_job_proposals
  get "/client-contracts", to: "client_dashboard#contracts", as: :client_contracts
  get "/client-payments", to: "client_dashboard#payments", as: :client_payments
  get "/client-freelancers", to: "client_dashboard#freelancers", as: :client_freelancers

  # JOBS - COMBINED (NO DUPLICATES)
  resources :jobs do
    member do
      patch :close
    end
    resources :proposals, only: [:create, :index] do
      member do
        patch :accept
        patch :reject
        post :message_freelancer
      end
    end
    resources :reviews, only: [:new, :create]
  end

  # CONTRACTS
  resources :contracts, only: [:index, :show] do
    member do
      patch :complete
      patch :cancel
    end
  end

  # REVIEWS
  resources :reviews, only: [:new, :create] do
    collection do
      get :my_reviews
    end
  end

  # FREELANCER DASHBOARD
  get "freelancer-dashboard", to: "freelancer_dashboard#index", as: :freelancer_dashboard
  get "freelancer-profile/edit", to: "freelancer_dashboard#edit_profile", as: :edit_freelancer_profile
  patch "freelancer-profile/update", to: "freelancer_dashboard#update_profile", as: :update_freelancer_profile

  # OTHER RESOURCES
  resources :skills, only: [:create, :edit, :update, :destroy]
  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end
  resources :payments, only: [:new, :create, :index]
  resources :users, only: [:show, :edit, :update], constraints: { id: /\d+/ }

  get "up" => "rails/health#show", as: :rails_health_check
end