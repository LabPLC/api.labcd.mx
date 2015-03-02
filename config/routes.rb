Rails.application.routes.draw do
  resources :air_qualities, except: [:new, :edit]
  resources :semovi_taxis
end
