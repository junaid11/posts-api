Rails.application.routes.draw do
  namespace :api do
    get '/ping', to: 'posts#status', as: 'ping'
    resources :posts, only: %w(index) 
  end
end
