require 'houston'

module Api  
class Api::AndroidController < ActionController::Base
  #before_action :android_authenticate
  DEFAULT_DISTANCE = 99999
  NEARBY_DISTANCE = 5
  
  def index
    @usr = User.find_by_id(9)
    render json: @usr
  end

  def show
    @usr = User.find_by_id(9)
    render json: @usr
  end
  
  def used_coupons
      @usr = User.find_by_id(params[:id])
      render json: ArrayPresenter.new(@usr.used_user_coupons.page(params[:page]), UserCouponPresenter)      
  end
  
   def available_coupons #hien thi list coupon chua su dung cua nguoi dung
      @usr = User.find_by_id(params[:id])
      render json: ArrayPresenter.new(@usr.available_user_coupons.page(params[:page]), UserCouponPresenter)
   end
  
  def test_send_noti
    certificate = File.read("D:/Aclub/shared/apns_cert.pem")
    passphrase = "123456"
    connection = Houston::Connection.new(Houston::APPLE_DEVELOPMENT_GATEWAY_URI, certificate, passphrase)
    connection.open
    token = "9a0010f5c8fa895dd0fa08e8604dc74e6d784e8464230c150cf0890a5dd471c9"
    notification = Houston::Notification.new(device: token)
    notification.alert = "Hello, Kiên ! fdsa asdf asd fasdf asdf asd"
    #notification.alert = "f asdf asdf asdf asdf "
    notification.badge = 0
    notification.sound = 'chime.aiff'
    #notification.category = 'NEW_MESSAGE_CATEGORY'
    #notification.custom_data = "55"
    connection.write(notification.message)    
    connection.close
    render json: {status: "ok", notification: notification}
  end
  
  def test_send_noti1
    @APN = Houston::Client.development
    @APN.certificate = File.read(Rails.application.secrets.apns_certificate)
    @APN.passphrase = Rails.application.secrets.apns_passphrase
    token = "9a0010f5c8fa895dd0fa08e8604dc74e6d784e8464230c150cf0890a5dd471c9"
    notification = Houston::Notification.new(device: token)
    notification.alert = "f asdf asdf asdf asdf "
    notification.badge = 1
    notification.sound = 'sosumi.aiff'
    notification.custom_data = "55"
    @APN.push(notification)
  end
  
  def coupons
    #render json: ArrayPresenter.new(Coupon.includes(restaurant: [:restaurant_category]).available.page(params[:page]), CouponPresenter)
    coupon = Coupon.find_by(id: params[:id])
    if coupon.present?
      impressionist(coupon, message: Coupon::VIEW)
      render json: CouponPresenter.new(coupon)
    else
      render_errors(I18n.t("base.api.not_found"), :not_found)
    end
  end
  
  def coupons_index
    render json: ArrayPresenter.new(Coupon.includes(restaurant: [:restaurant_category]).available.page(params[:page]), CouponPresenter)
  end
  
  # start : coupon detail comments
  def coupon_comments_get
    commentable_id = params[:coupon_id]
    @commentable = "Coupon".constantize.find_by(id: commentable_id)
    render json:  ArrayPresenter.new(@commentable.comments.includes(:commenter).page(params[:page]), CommentPresenter)
  end

  def coupon_comment_create
    current_user = User.find_by_id(params[:user_id])
    commentable_id = params["#{comment_params[:commentable_type].downcase}_id"]
    @commentable = comment_params[:commentable_type].constantize.find_by(id: commentable_id)
    comment = current_user.comment(@commentable, comment_params[:content], comment_params[:rate])
    if comment.valid?
      render json: CommentPresenter.new(comment)
    else
      render json: ModelErrorsPresenter.new(comment)
    end
  end
  # end : coupon detail comments
  
  def restaurant
      @restaurant = Restaurant.find_by_id(params[:id])      
      render json: RestaurantPresenter.new(@restaurant)
  end
  ##Get list restaurant theo category
  def get_restaurant_bycategory    
      @restaurant = Restaurant.restaurant_catgory(params[:id] ,params[:latitude], params[:longitude],params[:page])
      render json: ArrayPresenter.new(@restaurant , RestaurantPresenter)
      #render json: @restaurant
  end
  
  # start : restaurant_comments_get comments
  def restaurant_comments_get
    commentable_id = params[:restaurant_id]
    @commentable = "Restaurant".constantize.find_by(id: commentable_id)
    render json:  ArrayPresenter.new(@commentable.comments.includes(:commenter).page(params[:page]), CommentPresenter)
  end

  def restaurant_comment_create
    current_user = User.find_by_id(params[:user_id])
    commentable_id = params["#{comment_params[:commentable_type].downcase}_id"]
    @commentable = comment_params[:commentable_type].constantize.find_by(id: commentable_id)
    comment = current_user.comment(@commentable, comment_params[:content], comment_params[:rate])
    if comment.valid?
      render json: CommentPresenter.new(comment)
    else
      render json: ModelErrorsPresenter.new(comment)
    end
  end
  # end : coupon detail comments
  
  def invitees
    @coupon = Coupon.find_by_id(params[:coupon_id])
    @usr = User.find_by_id(params[:user_id])
    pending_invitees = ArrayPresenter.new(@usr.pending_invitees(@coupon), UserPresenter)
    accepted_invitees = ArrayPresenter.new(@usr.accepted_invitees(@coupon), UserPresenter)
    denied_invitees = ArrayPresenter.new(@usr.denied_invitees(@coupon), UserPresenter)
    render json: { pending_invitees: pending_invitees, accepted_invitees: accepted_invitees, denied_invitees: denied_invitees }
    
  end
  
  
  
  def friends    
    if @usr = User.find_by_id(params[:id])
      @arr1 = ArrayPresenter.new(@usr.following_users, UserAndroidPresenter)
      @arr2 = ArrayPresenter.new(@usr.user_followers, UserAndroidPresenter)
      render json: { followings: @arr1 , followers: @arr2}
      #render json: { followings: @usr.following_user , followers: @usr.user_followers}  
    else
      render_errors(I18n.t("base.api.not_found"), :not_found)
    end
  end
  
  def envs
    render json: EnvPresenter.new(params[:latitude], params[:longitude], params[:user_id])
  end
  
  def most_nearby #cat =(1,2,3,5)
    most_nearby_coupons = Coupon.available.most_nearby_cat(params[:latitude], params[:longitude]).page(params[:page]).sort_by(&:distance)
    render json: ArrayPresenter.new(most_nearby_coupons, CouponPresenter)
  end

  def best_price  #cat =(54)
    best_price_coupons = Coupon.available.most_nearby(params[:latitude], params[:longitude]).best_price.page(params[:page]).sort_by(&:distance)
    render json: ArrayPresenter.new(best_price_coupons, CouponPresenter)
  end

  def best_service #cat =(12)
    best_service_coupons = Coupon.available.most_nearby(params[:latitude], params[:longitude]).best_service.page(params[:page]).sort_by(&:distance)
    render json: ArrayPresenter.new(best_service_coupons, CouponPresenter)
  end

  def best_bar #cat =(4,43)
    best_bar_coupons = Coupon.available.most_nearby(params[:latitude], params[:longitude]).best_bar.page(params[:page]).sort_by(&:distance)
    render json: ArrayPresenter.new(best_bar_coupons, CouponPresenter)
  end
  
  #Coupon invitations start
  def coupon_invitations_create
    @current_user = User.find_by_id(params[:user_id])
    #if has_params?([:coupon_id], :coupon_invitation)
      #coupon_invitation_service = coupon_invitation_create_new(coupon_invitation_params, @current_user)
      #render json: coupon_invitation_service     
    #end
    if has_params?([:coupon_id], :coupon_invitation)
      coupon_invitation_service = CouponInvitationService.new(coupon_invitation_params, @current_user)
      if coupon_invitation_service.create
        render json: coupon_invitation_service.response_data
      else
        render_errors(coupon_invitation_service.errors, :unprocessable_entity)
      end
    end
  end
  
  def coupon_invitations_update
    @current_user = User.find_by_id(params[:user_id])
    #coupon_invitation_service = coupon_invitation_update_edit(invitation_response_params, @current_user)
    #render json: coupon_invitation_service
    coupon_invitation_service = CouponInvitationService.new(invitation_response_params, @current_user)
    if coupon_invitation_service.update
      render json: coupon_invitation_service.response_data
    else
      render_errors(coupon_invitation_service.errors, :unprocessable_entity)
    end
  end
  #Coupon invitations ends
  
  # session
  def sessions_create
    @normalized_phone = phone_normalize(signin_params[:username])
    if @normalized_phone.include? "@"
      @user = User.find_by_email(signin_params[:username])
      if !@user.valid_password?(signin_params[:password])
        render json: I18n.t("controller.users.invalid_password")
      else
        render json:  AuthorizedUserPresenter.new(@user)
      end      
    else      
      @user = User.find_by_phone(@normalized_phone)
      if !@user.valid_password?(signin_params[:password])
        render json: I18n.t("controller.users.invalid_password")
      else
        render json:  AuthorizedUserPresenter.new(@user)
      end
    end
    #@res = params[:user]
    #render json: @res
  end
  #Check facebook login
  def check_face_login
      #@user = User.find_by_email(params[:email], params[:facebook_token])
      @user = User.find_by_fb(params[:email], params[:facebook_token])
      @n = User.find_by_fb(params[:email], params[:facebook_token]).count
      if @user.nil?
          render json: null
      elsif  @n  > 1 
           render json: null
      elsif  @n == 1
          unless params[:email].nil? && params[:facebook_token].nil?
              @user[0].facebook_token = params[:facebook_token]
              @user[0].update_columns(facebook_token: params[:facebook_token])
              render json: @user[0]
          end          
      end
     # render json: #{lst: @user , n: @n}
  end

  def request_phone_verification_token
    if normalized_phone = Api::PhoneParser.normalize(signin_params[:phone]) #phone
      if user = User.find_by_phone(normalized_phone)
        #user.generate_phone_verification_token
        #user.save
        #user.send_verification_code
        head :ok
      else
        render_errors(I18n.t("controller.sessions.not_found"), :not_found)
      end
    else
      @email = signin_params[:phone]
      if user = User.find_by_email(@email)
        #user.generate_phone_verification_token
        #user.save
        #user.send_verification_code
        head :ok
      else
        render_errors(I18n.t("controller.sessions.not_found"), :not_found)
      end
    end
  end
  #
  
  # start : venues
  # Accepted params
  # required query: 'venue_name',
  # optional :latitude, :longitude, :radius (in metter)
  def venues_index
    venues = Venue.search_and_update(venue_search_params)    
    render json: ArrayPresenter.new(venues, VenuePresenter)
  end

  def venues_show
    @venue = Venue.find_by(id: params[:id])
    impressionist(@venue, Venue::VIEW)    
    render json: VenueDetailsService.new(@venue).get_details
  end

  #Accepted params
  # optional :latitude, :longitude, :radius (in metter)
  def popular_restaurants
    venues = Venue.popular_restaurants(venue_search_params)
    render json: ArrayPresenter.new(venues, VenuePresenter)
  end
  
  # end : venues
  
  
  # start : registrations
  def registrations
    registration_service = RegistrationService.new(signup_params)
    if registration_service.create
      render json: registration_service.response_data
    else
      render json: registration_service.errors, status: :unprocessable_entity
    end
  end
  
  def registration_and_login_fb
    registration_service = RegistrationService.new(signup_params)
    if !params[:facebook_token].nil? 
      if registration_service.create        
        @user = registration_service.response_data_fb
        #@user = User.find_by_id(@cur_user.id)
        @user.facebook_token = params[:facebook_token]
        @user.update_columns(facebook_token: params[:facebook_token])
        render json: @user
      else
        render json: registration_service.errors, status: :unprocessable_entity
      end
    else
      render json: registration_service.errors, status: :unprocessable_entity
    end
  end
  # end : registrations
  
  # start : users
  def users_show
    current_user = User.find_by_id(params[:user_id])
    render json: AuthorizedUserPresenter.new(current_user)
  end

  def users_update
    if has_params?([:user])
      current_user = User.find_by_id(params[:user_id])
      update_service = UserService.new(current_user, user_params)

      if update_service.update
        render json: update_service.response_data
      else
        render json: update_service.errors, status: :unprocessable_entity
      end
    end
  end
  #getlistfollowing
  def get_listfollowing
     @usr = User.find_by_id(params[:user_id])
     @arr = ArrayPresenter.new(@usr.following_users.page(params[:page]), UserAndroidPresenter)
     render json: { followings: @arr }
  end
  #~~~
   #getlistfollowing for thao moi ban be
  def get_listfollowing_search
     @usr = User.find_by_id(params[:user_id])
     if params[:query].nil?
        @arr = ArrayPresenter.new(@usr.following_users.page(params[:page]), UserAndroidPresenter)
     elsif
       @list = @usr.following_users.where('lower(name) LIKE ? OR lower(email) LIKE ?', "%#{params[:query].downcase }%", "%#{params[:query].downcase }%")
      @arr = ArrayPresenter.new(@list.page(params[:page]), UserAndroidPresenter)
     end
     render json: { followings: @arr }
  end
  
  #getlistfollower
  def get_listfollower
     @usr = User.find_by_id(params[:user_id])
     @arr = ArrayPresenter.new(@usr.user_followers.page(params[:page]), UserAndroidPresenter)
     #follower_users = User.where(id: user.follows.where(follower: existing_users).pluck(:follower_id))
     render json: {followers: @arr}
  end
  # end : users
  
  
  # start : user_coupons
  def get_user_coupon
     render json: UserCoupon.find_by_userid_couponid(params[:user_id], params[:coupon_id])
  end
  
  def user_coupons_create
    @coupon = Coupon.find_by_id(params[:coupon_id])
    @current_user = User.find_by_id(params[:user_id])
    if @coupon.has_more_quantity?
      if @current_user.can_receive_coupon?(@coupon)
        @current_user.user_coupons.find_or_create_by(coupon_id: params[:coupon_id])
        head :ok
      else
        render_errors(I18n.t('base.api.user_coupons.not_enough_accepted_invitation'), :unprocessable_entity)
      end
    else
      render_errors(I18n.t('base.api.user_coupons.no_more_quantity'), :unprocessable_entity)
    end
  end

  def user_coupons_update
    @current_user = User.find_by_id(params[:user_id])
    @coupon = Coupon.find_by_id(params[:coupon_id])
    if user_coupon = @current_user.user_coupons.find_by(coupon_id: @coupon.id)
      user_coupon.used!
      impressionist(user_coupon.coupon, Coupon::USED)
      head :ok
    else
      render_errors(I18n.t('base.api.user_coupons.not_found'), :not_found)
    end
  end
  
  # end : user_coupons
  
  # start : Notification
  def get_notification_coupon_invite    
   @arr = CouponInvitation.get_notification_coupon_invite(params[:user_id])
    render json: ArrayPresenter.new(@arr , CouponInvitationPresenter)
  end
  
  def get_total_notification_coupon_invite    
   @arr = CouponInvitation.get_notification_coupon_invite(params[:user_id])
    render json: {Total: @arr.count}
  end
  
  def get_all_coupon_invite
    #code
    @usr = User.find_by_id(params[:user_id])
    @ci = @usr.coupon_invitation_inviters
    render json: @ci
  end
  # end : Notification
  
  # start : user follow loi moi ket ban
  def create_follow
    @usr = User.find_by_id(params[:user_id])
    @followable = follow_params[:followable_type].constantize.find_by_id(follow_params[:followable_id])
    if @followable.present?
        @usr.follow(@followable)
        head :ok    
    else
        render_errors(I18n.t("base.api.not_found"), :not_found)
    end
  end
  
  def destroy_follow
    @usr = User.find_by_id(params[:user_id])
    @followable = follow_params[:followable_type].constantize.find_by_id(follow_params[:followable_id])
    if @followable.present?
      @usr.stop_following(@followable)
      head :ok
    else
      render_errors(I18n.t("base.api.not_found"), :not_found)
    end
  end
  
  # end : end user follow loi moi ket ban
  
  private


  def follow_params
    params[:follow].permit(:followable_id, :followable_type)
  end   
   
  def user_params
    params[:user].permit(:name, :phone, :email, :avatar, :password)
  end
  
  def signup_params
    params[:user].permit(:phone, :email, :password, :device_token, :user_agent)
  end
  
  def venue_search_params
    params.permit(:query, :latitude, :longitude, :radius, :page)
  end
  
  def comment_params
    params[:comment].permit(:commentable_type, :content, :rate)
  end
  
  def android_authenticate
    unless ( params[:android_token] == "123456789")
      render json: {status: 0, sErr: "Error token"}
    end
  end
  
  def coupon_invitation_params
    params[:coupon_invitation].permit(:coupon_id, :inviter_id, invitee_ids: [])
  end

  def invitation_response_params
    params.permit(:id, :answer)
  end
  
  
  #
  def render_errors(message, status)
    render json: { errors: message }, status: status
  end

  def has_params?(required_params, root=nil)
    root_params = root ? params[root] : params
    missing_params = if root_params
                       required_params.select { |param| root_params[param].blank? }
                     else
                       required_params
                     end
    if missing_params.present?
      errors_message = "Missing parameters: #{root}[#{missing_params.join(", ")}]"
      render_errors(errors_message, :unprocessable_entity)
      false
    else
      true
    end
  end

  #for sesion
  #
  def phone_normalize(phone)
    new_phone = phone.gsub('-', '').gsub('+', '').gsub(' ', '')
    if new_phone.match /\A0(9|1)[0-9]{8,9}\z/
      new_phone = "84#{new_phone[1..-1]}"
    end
    new_phone
  end

    

  def signin_params
    params[:user]
  end 
  #
end
end
