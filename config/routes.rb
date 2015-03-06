Rails.application.routes.draw do

  root to: 'welcome#index'

  namespace :v1 do

    root to: 'base#version'

    namespace :movilidad do
      resources :bicycle_stations, path: 'estaciones-ecobici', only: [:index, :show]
      resources :vehicles, path: 'vehiculos', only: [:index, :show]
      resources :semovi_taxis, path: 'taxis', only: [:index, :show]
    end

    namespace :aire do
      resources :air_qualities, path: 'calidad-actual', only: [:index]
    end

    namespace :finanzas do
      resources :linea_captura, only: [:index, :show]
      resources :pagos, only: [] do
        get :consulta, on: :collection
      end
    end

    namespace :servicios do
      resources :testamentos, only: [:index, :show]
    end

    namespace :seguridad do
      resources :corralones, only: [:index, :show]
    end

  end

end
