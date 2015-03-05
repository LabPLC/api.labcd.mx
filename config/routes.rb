Rails.application.routes.draw do
  resources :bicycle_stations, only: [:index, :show]
  resources :air_qualities, except: [:new, :edit]
  resources :semovi_taxis
  resources :alerta_amber

  namespace :finanzas do
    resources :linea_captura
    resources :pagos, only: [] do
      get :consulta, on: :collection
    end
  end
 
end
