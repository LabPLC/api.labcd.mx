Rails.application.routes.draw do
  resources :bicycle_stations, only: [:index, :show] do
    get :status, on: :member
  end
  resources :air_qualities, except: [:new, :edit]
  resources :semovi_taxis
end
