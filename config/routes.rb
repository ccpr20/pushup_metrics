Rails.application.routes.draw do

	get 'log', to: "pushups#new", as: 'log_pushup'
	get 'dashboard', to: "pushups#index", as: 'dashboard'
  resources :pushups
  root 'pages#home'

  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}
  devise_scope :user do
    get 'start', to: "registrations#start", as: 'start'
    get 'signup', to: "registrations#new", as: 'signup'
    get 'login', to: "sessions#new", as: 'login'
    get 'settings', to: "registrations#edit", as: 'settings'
    delete 'logout', to: "sessions#destroy", as: 'logout'
  end

end
