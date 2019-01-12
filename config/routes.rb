Rails.application.routes.draw do

  root 'pages#home'
  get '/admin', controller: "pages", action: "admin"
  get '/admin/credits', controller: "pages", action: "credits"

  devise_for :users, :skip => [:registrations], controllers: {
    session: 'users/sessions'
  }

  namespace :admin do
    resources :venues do
      member do
        get :statistics
        get :subscriptions
      end
      resources :promotions, only: [:new, :create]
      resources :accounts
      resources :games, shallow: true do
        member do
          get :play
          get :check_score
          get :tiebreaker
          get :winner
        end
        resources :teams do
          member do
            get :answer
            patch :answered
          end
        end
      end
    end
  end
end
