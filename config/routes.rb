Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      get '/', to: 'api#index'
      get 'login_or_register_user', to: 'user#login_or_register_user'
      get 'login_with_token', to: 'user#login_with_token'
      get 'search_for_friends', to: 'user#search_for_friends'
      post 'update_phone_number', to: 'user#update_phone_number'
      post 'add_friend', to: 'user#add_friend'
      get 'download_user', to: 'user#download_user'

      get 'friend_list', to: 'user#friend_list'
      get 'request_list', to: 'user#request_list'
      get 'pending_list', to: 'user#pending_list'

      post 'make_post', to: 'post#make_post'
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
