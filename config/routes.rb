Rails.application.routes.draw do
  apipie
  resources :events do
    member do
      post 'join'
      delete 'leave'
    end
  end
end
