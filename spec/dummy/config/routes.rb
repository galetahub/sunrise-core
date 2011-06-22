Dummy::Application.routes.draw do
  root :to => "welcome#index"

  resources :pages, :only => [:show]

  devise_for :users
end
