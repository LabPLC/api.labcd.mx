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
<<<<<<< HEAD
    resources :testamentos, only: [:index, :show]
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
=======
  resources :testamentos, only: [:index, :show]
>>>>>>> 5edb4777af2558d28a7245b24f4dc6bddb7430bc

  resources :corralones, only: [:index, :show]
end
