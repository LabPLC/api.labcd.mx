Rails.application.routes.draw do
  resources :bicycle_stations, only: [:index, :show]
  resources :air_qualities, except: [:new, :edit]
  resources :semovi_taxis
    resources :alerta_amber
end
