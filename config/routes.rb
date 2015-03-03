Rails.application.routes.draw do
  resources :bicycle_stations_statuses, except: [:new, :edit]
  resources :bicycle_stations, only: [:index, :show]
  resources :air_qualities, except: [:new, :edit]
  resources :semovi_taxis
end
