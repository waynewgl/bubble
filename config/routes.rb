Meets::Application.routes.draw do
  apipie

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
  root :to => 'user#index'


  match 'user/checkUpdate' => 'user#checkUpdate'
  match 'user/register' => 'user#register'
  match 'user/findMyTrip' => 'user#findMyTrip'
  match 'user/userLogin' => 'user#userLogin'
  match 'user/userLogout' => 'user#userLogout'
  match 'user/upload_avatar_ios' => 'user#upload_avatar_ios'
  match 'user/recordLocation' => 'user#recordLocation'
  match 'user/reportUser' => 'user#reportUser'
  match 'user/blackList' => 'user#blackList'
  match 'user/usersLocationMet' => 'user#usersLocationMet'
  match 'user/historyOfUsersMeet' => 'user#historyOfUsersMeet'
  match 'user/recordUserLocation' => 'user#recordUserLocation'
  match 'user/addUsersMeetLocation' => 'user#addUsersMeetLocation'
  match 'user/updateUserDetail' => 'user#updateUserDetail'
  match 'user/changePassword' => 'user#changePassword'
  match 'user/userMeetStrangers' => 'user#userMeetStrangers'
  match 'user/getLatestLocation' => 'user#getLatestLocation'

  match 'user/encryptAndDecryptCodeOperaionTest' => 'user#encryptAndDecryptCodeOperaionTest'

  match 'user/userFeedback' => 'user#userFeedback'

  match 'user/pushTest_development' => 'user#pushTest_development'
  match 'user/pushTest_production' => 'user#pushTest_production'

  match 'user/getUserBlackList' => 'user#getUserBlackList'
  match 'user/removeSpecificBlackList' => 'user#removeSpecificBlackList'

  match 'user/restorePassword' => 'user#restorePassword'
  match 'user/getReportReasons' => 'user#getReportReasons'

  match 'event/createEvent' => 'event#createEvent'
  match 'event/deleteEvent' => 'event#deleteEvent'
  match 'event/report_event' => 'event#report_event'
  match 'event/loadSpecificEvent' => 'event#loadSpecificEvent'

  match 'event/getUserEventWithDetail' => 'event#getUserEventWithDetail'

  match 'event/uploadEventImage' => 'event#uploadEventImage'
  match 'event/deleteEventImage' => 'event#deleteEventImage'
  match 'event/saveTimeCapsule' => 'event#saveTimeCapsule'
  match 'event/getUsersEvents' => 'event#getUsersEvents'
  match 'event/searchTimeCapsule' => 'event#searchTimeCapsule'
  match 'event/searchSpecificTimeCapsule' => 'event#searchSpecificTimeCapsule'
  match 'event/userHasViewedEvent' => 'event#userHasViewedEvent'



  match 'comment/createComment' => 'comment#createComment'
  match 'comment/deleteComment' => 'comment#deleteComment'
  match 'comment/listComments' => 'comment#listComments'
  match 'comment/listCommentsCount' => 'comment#listCommentsCount'

  match 'category/listCategory' => 'category#listCategory'
  match 'category/addCategory' => 'event#addCategory'


  match 'help/index' => 'help#index'


  match 'admin/index' => 'admin#index'
  match 'admin/adminSetting' => 'admin#adminSetting'
  match 'admin/getAllUsers' => 'admin#getAllUsers'
  match 'admin/deleteUser' => 'admin#deleteUser'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
