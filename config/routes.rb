Rails.application.routes.draw do
  namespace :dawn_boot do
    resources :networkstatuses
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "configurators#start"
  #resources :configurator, :only => [:index]
  resources :configurators

end
