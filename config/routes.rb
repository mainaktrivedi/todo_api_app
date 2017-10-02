Rails.application.routes.draw do
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope '/api/v1' do
    resources :tasks
    resources :tags, only: [:index, :create, :update, :destroy] do
    	member do
    		get :test_member
    	end
    	collection do
    		get :test_collection
    	end
    end
    
    get :test_individual, to: "something#show", as: :something_else

    post :authenticate, to: 'authentication#authenticate'
    
  end 
  
end
