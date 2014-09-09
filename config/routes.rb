require 'sidekiq/web'

Rails.application.routes.draw do
  resources :jobs do
    collection do
      get :get_job
    end
  end

  devise_for :users

  mount Sidekiq::Web => '/sidekiq'
end
