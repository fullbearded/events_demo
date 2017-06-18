Rails.application.routes.draw do
  scope module: 'session' do
    get 'login', action: 'new'
    post 'login', action: 'create'
    get 'logout', action: 'destroy'
  end

  resources :launchpad, only: [:index]

  resources :teams, only: [:create], param: :uid do
    resources :events, only: [:index]
    resources :projects, only: [:index, :show], param: :uid
    resources :users, only: [:index], param: :uid
  end

  resources :projects, only: [], param: :uid do
    resources :todos, only: [:show], param: :uid
    resources :todolist, only: [:show], param: :uid
  end

  root 'events#index'
end
