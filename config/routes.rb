Rails.application.routes.draw do
  # Administration System
  namespace :manage do
    root :to => "structures#index"
    
	  resources :users do
	    member do
        post :activate, :suspend, :register, :delete, :unsuspend
      end
	  end
		
		resources :structures do
		  get :move, :on => :member
		  
		  resource :page
		  resources :posts
		end
		
		resources :assets, :only => [:create, :destroy] do
      post :sort, :on => :collection
    end
		
    resources :settings
  end
end
