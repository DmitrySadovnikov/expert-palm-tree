Rails.application.routes.draw do
  get 'hc', to: 'application#hc'

  namespace :api do
    namespace :v1 do
      resources :stocks, only: %i[index create update destroy]
    end
  end
end
