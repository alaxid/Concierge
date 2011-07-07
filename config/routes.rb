Concierge::Application.routes.draw do

  resources :favorites

  resources :votes

  resources :users
  resources :sessions

  #Concierge Defaults
  root :to => "HomePage#index"
  match "index" => "HomePage#index"
  match "posterbackground" => "HomePage#poster"
  match "search" => "Search#search", :defaults => { :format => :xml}
  match "searchrecord/:service/:method/:id" =>"ServiceForward#recordrequest", :as => "searchrecord", :defaults => { :format => :xml}

  #Service forward
  match "services/:service/search" => "Search#servicesearch", :defaults => { :format => :xml}
  match "services/:service/index" => "ServiceForward#homepagerequest", :defaults => { :format => :xml}
  match "services/:service/:method" => "ServiceForward#listrequest", :defaults => { :format => :xml}
  match "services/:service/:method/:id" => "ServiceForward#recordrequest", :defaults => { :format => :xml}
  match "directrecord/:service/:id" => "ServiceForward#recordrequest", :defaults => { :format => :xml}

  #Concierge admin
  match "admin" => "BackOffice#new"
  match "admin/create" => "BackOffice#create"
  match "admin/newservice" => "BackOffice#newservice"
  match "admin/createservice" => "BackOffice#createservice"
  match "admin/uploadfile" => "BackOffice#uploadFile"
  match "admin/listservices" => "BackOffice#listservices"
  match "admin/destroyservice" => "BackOffice#destroyservice"
  match "admin/destroyuser" => "BackOffice#destroyuser"
  match "admin/destroyfavourite" => "BackOffice#destroyfavourite"

  #user actions

  match "login" => "sessions#new"
  match "logout" => "sessions#destroy"
  match "signin" => "users#new"
  match "activation" => "users#activate"
  match "history" => "Users#history", :defaults => { :format => :xml}
  match "favourites" => "Users#favourites", :defaults => { :format => :xml}
  match "options" => "Users#options"
  match "editfavourites" => "Users#editfavourites", :defaults => { :format => :xml}
  match "manageaccount" => "Users#manageaccount"
  match "update" => "Users#update"
  match "sendresource" => "Users#sendresource", :defaults => { :format => :xml}
  match "rateservice" => "Users#rateservice", :defaults => { :format => :xml}
  match "addfavourite" => "Users#addfavourite", :defaults => { :format => :xml}
  match "destroyfavorite" => "Users#destroyfavourite", :defaults => { :format => :xml}

#  match "services/:service/:id" => "Record#record"
#  match "record" => "Record#record", :defaults => { :format => :xml}



  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
