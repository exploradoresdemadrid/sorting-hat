require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :events do
    resources :executions, only: [:show, :create]
  end
  root to: 'events#index'
end
