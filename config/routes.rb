require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq' if Rails.env.development?
  resources :events do
    resources :executions, only: :show
  end
  root to: 'events#index'
end
