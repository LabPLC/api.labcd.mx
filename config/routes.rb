Rails.application.routes.draw do
  resources :bicycle_stations, only: [:index, :show]
  resources :vehicles, except: [:new, :edit]
  resources :air_qualities, except: [:new, :edit]
  resources :semovi_taxis
  namespace :finanzas do
    resources :linea_captura
    resources :pagos, only: [] do
      get :consulta, on: :collection
    end
  end
    resources :testamentos, only: [:index, :show]
  resources :corralones, only: [:index, :show]
end
