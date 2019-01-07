Rails.application.routes.draw do
  
  get 'venues/index'
  get 'venues/show'
  get 'venues/new'
  get 'venues/create'
  get 'venues/edit'
  get 'venues/update'
  get 'venues/destroy'
  get 'teams/index'
  get 'teams/show'
  get 'teams/new'
  get 'teams/create'
  get 'teams/edit'
  get 'teams/update'
  get 'teams/destroy'
  get 'games/index'
  get 'games/show'
  get 'games/new'
  get 'games/create'
  get 'games/edit'
  get 'games/update'
  get 'games/destroy'
  get 'accounts/index'
  get 'accounts/show'
  get 'accounts/new'
  get 'accounts/create'
  get 'accounts/edit'
  get 'accounts/update'
  get 'accounts/destroy'
  root 'pages#home'
  get '/admin', controller: "pages", action: "admin"

  devise_for :users, :skip => [:registrations], controllers: {
    session: 'users/sessions'
  }

  namespace :admin do
    resources :venues do
      member do
        get :statistics
      end
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
