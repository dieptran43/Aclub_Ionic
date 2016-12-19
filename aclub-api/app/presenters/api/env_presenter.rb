module Api
  class EnvPresenter < Presenter
    RESPONSE_LIMITATION = 8
    UNLIMITED_DISTANCE = 9999
    USERRECORD_LIMITATION = 30
    attr_accessor :active_users, :newest_users, :restaurant_categories, :hotest_coupons, :featured_coupons, :user_location

    def initialize(latitude, longitude, user_id)
     
     self.active_users =[]
     if !user_id.nil?
        @usr = User.find_by_id(user_id)
        self.active_users = @usr.user_followers.limit(USERRECORD_LIMITATION)
     end  
          
      self.user_location = [latitude, longitude]
      #self.active_users = User.most_active.limit(RESPONSE_LIMITATION)
      self.newest_users = User.newest.limit(USERRECORD_LIMITATION)
      self.restaurant_categories = RestaurantCategory.all
      self.hotest_coupons = Coupon.nearby(UNLIMITED_DISTANCE, user_location).available.order("distance").hotest.limit(RESPONSE_LIMITATION)
      self.featured_coupons = Coupon.nearby(UNLIMITED_DISTANCE, user_location).available.order("distance").featured.limit(RESPONSE_LIMITATION).order("distance")
    end

    def as_json(*)
      {
        active_users: ArrayPresenter.new(active_users, UserPresenter).as_json,
        newest_users: ArrayPresenter.new(newest_users, UserPresenter).as_json,
        restaurant_categories: ArrayPresenter.new(restaurant_categories, RestaurantCategoryPresenter).as_json,
        hotest_coupons: ArrayPresenter.new(hotest_coupons.includes(restaurant: [:foody_images]), CouponPresenter).as_json,
        featured_coupons: ArrayPresenter.new(featured_coupons.includes(restaurant: [:foody_images]), CouponPresenter).as_json
      }
    end
  end
end
