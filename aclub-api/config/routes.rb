Rails.application.routes.draw do
  namespace :api do
    resources :android do
      collection do
        get 'index'
        get 'show'
        #get 'used_coupons'
        get 'invitees'
        #get 'friends'
        get 'restaurant'
        get 'envs'
        post  :coupon_invitations_create
        post  :coupon_invitations_update
        post 'sessions_create'
        get :request_phone_verification_token
        get :test_send_noti
        get :test_send_noti1
        get :most_nearby
        get :best_price
        get :best_service
        get :best_bar
        get :coupon_comments_get
        post :coupon_comment_create
        get :venues_index
        get :venues_show
        get :popular_restaurants
        post :registrations
        get :users_show
        post :users_update
        get :restaurant_comments_get
        post :restaurant_comment_create
		get :get_listfollowing
        get :get_listfollower
        #get :coupons
        get :get_user_coupon ##nhan coupon(coupon_id, user_id)
		post :user_coupons_create
		post :user_coupons_update
		get :get_notification_coupon_invite
		get :get_all_coupon_invite
		get :get_restaurant_bycategory
		get 'check_face_login'
		post :registration_and_login_fb
		post :create_follow
		post :destroy_follow
		get :coupons_index
		get :get_listfollowing_search
		get :get_total_notification_coupon_invite
      end
      member do
        get :coupons
        get :used_coupons
        get :available_coupons
        get :friends
        #get :invitees               
      end
    end   
  end

  devise_for :admins, controllers: { sessions: 'sessions', registrations: 'registrations'}
  namespace :api do
    scope '/v1' do
      resource :sessions, only: [:create] do
        post :request_phone_verification_token
      end

      resource :third_party_accounts, only: :create

      resource :registrations, only: [:create]

      resources :coupons, only: [:index, :show] do
        resources :comments, only: [:index, :create]
        collection do
          get :hot_and_nearby
          get :most_nearby
          get :best_price
          get :best_service
          get :best_bar
        end

        resources :users, only: [] do
          member do
            get :invitees
          end
        end
      end

      resources :follows, only: [:create] do
        collection do
          delete :destroy
        end
      end

      resources :users, only: [:show, :update] do
        member do
          get :available_coupons
          get :used_coupons
          get :friends
          post :email_registration
          post :email_verification
          post :resend_email_verification
        end
      end

      resources :user_coupons , only: [:create, :update, :show] do
        member do
          get :get_user_coupon
        end
      end
      

      resources :coupon_invitations, only: [:create, :update]

      resource :interactivity_statuses, only: [:index] do
        post :index
      end

      resources :venues, only: [:index, :show] do
        collection do
          get :popular_restaurants
        end
      end

      resources :restaurants, only: [:index, :show] do
        resources :comments, only: [:index, :create]
      end

      resources :envs, only: [:index]

      resources :restaurant_categories do
        member do
          get :restaurants
        end
      end
    end
  end

  namespace :cms do
    resources :coupons
    resources :venues do
      get :photos
      get :reviews
    end
    resources :restaurants
    resources :users
    resources :advertising_events
    resources :partners
    resources :restaurant_categories
    resources :admins, controller: :restaurant_owners, path: :restaurant_owners
    resources :menus
  end
  
  namespace :owner do
    resources :facebook_fanpages
    resources :coupons do
      collection do
        get :code_form
        post :redeem_code
      end
    end
    resources :restaurants

    resources :third_party_accounts, only: [:index] do
      collection do
        get 'page_list'
        post 'sync_data_from_facebook_account'
      end
    end

    resources :advertising_events
    resources :restaurants do
      collection do
        get :connect_a_restaurant
        post :restaurant_reviews
      end
    end
    resources :menus
  end

  get '/auth/facebook'
  get 'auth/:provider/callback' => 'omniauth#omniauth_callback'
  get 'auth/failure' => 'omniauth#omniauth_fallback'
  
  # resources :advertising_events, only: [:show] do
  #   collection do
  #     post '/register_phone' => 'advertising_events#register_phone'
  #     post '/verify_phone' => 'advertising_events#verify_phone'
  #     post '/resend_phone_token' => 'advertising_events#resend_phone_token'
  #     get '/reward' => 'advertising_events#reward'
  #     get '/phone_registration_page' => 'advertising_events#phone_registration_page'
  #     get '/thank_you' => 'advertising_events#thank_you'
  #   end
  # end
  
  namespace :facebook do
    get '/voucher', to: 'vouchers#index'
    post '/voucher', to: 'vouchers#index'
    get '/voucher/index', to: 'vouchers#index'
    post '/voucher', to: 'vouchers#index'
    post '/voucher/registration', to: 'vouchers#registration'
    post '/voucher/sendsms', to: 'vouchers#send_sms'
    get '/startpage', to: 'vouchers#startpage'
    get '/voucher/restaurant-ad-event', to: 'vouchers#restaurant_advertising_event'
    post '/voucher/restaurant-ad-event', to: 'vouchers#restaurant_advertising_event'
    get '/menu', to: 'menu_tabs#index'
    post '/menu', to: 'menu_tabs#index'
  end

  root 'static_pages#index'
  get 'service-intro' => 'static_pages#service_intro'
  get 'app-intro' => 'static_pages#app_intro'
  get 'index' => 'static_pages#index'
  get 'voucher' => 'static_pages#voucher'
end
