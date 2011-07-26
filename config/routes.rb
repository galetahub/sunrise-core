Rails.application.routes.draw do
  # Administration System
  namespace :manage do
    root :to => "structures#index"
    
	  resources :users do
	    member do
        post :activate, :suspend, :unsuspend, :unlock
      end
	  end
		
		resources :structures do
		  get :move, :on => :member
		  
		  resource :page
		end
		
		resources :assets, :only => [:create, :destroy] do
      post :sort, :on => :collection
    end
		
    resources :settings
  end
end
