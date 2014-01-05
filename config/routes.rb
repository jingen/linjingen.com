Linjingen::Application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations", :omniauth_callbacks => "omniauth_callbacks"}
  devise_scope :user do
    post "send_message" => "users#send_message"
  end
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'
  get 'aboutus'   => "welcome#about_us"
  match 'avatar', to: 'users#avatar', via: [:get, :post]

  get "doc_library"          => "documents#index"
  get "public_docs"          => "documents#public_docs"
  get "user_docs"            => "documents#user_docs"
  post "add_doc"             => "documents#create"
  post "update_doc"          => "documents#update"
  post "delete_doc"          => "documents#destroy"
  post "crocodoc_webhook"    => "documents#webhook"
  get "documents/:croc_uuid" => "documents#crocodoc_session"
  get "doc_search/:email"    => "documents#search"

  get "video_library"       => "videos#index"
  get "public_videos"       => "videos#public_videos"
  get "user_videos"         => "videos#user_videos"
  post "process_video_link" => "videos#process_link"
  post "add_video"          => "videos#create"
  post "update_video"       => "videos#update"
  post "delete_video"       => "videos#destroy"
  get "video_search/:email" => "videos#search"

  get "spell_checker" => "words#index"
  post "word_check"   => "words#check"

  get "image_resizer" => "images#index"
  post "image_resize" => "images#create"
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
