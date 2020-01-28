Rails.application.routes.draw do
	root 'pages#home'
	get 'choose', to: "pages#choose", as: 'choose_team'

  get 'dashboard', to: "dashboard#private", as: 'dashboard'
	get 'team', to: "dashboard#team", as: 'team_dashboard'
	get 'teams', to: "dashboard#all_teams", as: 'teams'
	get 'oops', to: "dashboard#sorry", as: 'undefined_team'

	match 'twilio/process_sms' => 'twilio#process_sms', via: [:get, :post]
  resources :reminders

	get 'log', to: "pushups#new", as: 'log_pushup'
	get 'history', to: "pushups#history", as: 'history'
  resources :pushups

  resources :leaderboard
 
  resources :owner do
    delete '/push_up', to: 'owner#delete_pushups', as: 'push_up'
  end

  devise_for :users, controllers: {registrations: "registrations", sessions: "sessions"}
  devise_scope :user do
    get 'start', to: "registrations#start", as: 'start'
    get 'signup', to: "registrations#new", as: 'signup'
    get 'login', to: "sessions#new", as: 'login'
    get 'settings', to: "registrations#edit", as: 'settings'
    delete 'logout', to: "sessions#destroy", as: 'logout'
  end

end
