class Coupon < ActiveRecord::Base
  include Commentable

  VIEW = 'view'
  USED = 'used'
  VIEW_WEIGHT = 0.1
  USED_WEIGHT = 0.9
  NEARBY_DISTANCE = 5
  DEFAULT_DISTANCE = 99999

  commentable
  is_impressionable counter_cache: true

  belongs_to :restaurant
  acts_as_mappable through: :restaurant

  has_many :user_coupons, dependent: :destroy
  has_many :user_vouchers, dependent: :destroy
  has_many :coupon_invitations, dependent: :destroy
  scope :available, -> { where('coupons.end_date > ?', Date.current) }
  
  delegate :urls, to: :image, prefix: true
  mount_uploader :image, ImageUploader

  before_create :generate_coupon_code
  after_create :push_notification_to_users
  
  #after_find :get_coupon_code_token

  scope :hotest, -> {
    order('coupons.impressions_count DESC')
  }

  scope :featured, -> {
    available.order('coupons.priority DESC')
  }

  scope :best_service, -> {
    available.where( 'restaurants.restaurant_category_id in (12)').order('coupons.number_of_free_volka DESC')
  }

  scope :best_price, -> {
    available.where( 'restaurants.restaurant_category_id in (54)').order("REGEXP_REPLACE(cash_discount, '[^0-9]+', '', 'g')::integer DESC").order("REGEXP_REPLACE(bill_discount, '[^0-9]+', '', 'g')::integer DESC").order('coupons.food_discount')
  }

  scope :best_bar, -> {
    available.where( 'restaurants.restaurant_category_id in (4, 43)').order('coupons.number_of_free_volka DESC')
  }
  
  def self.hot_and_nearby(latitude, longitude)
    joins(:restaurant).within(NEARBY_DISTANCE, origin: [latitude, longitude]).hotest
  end

  def self.nearby(distance, origin)
    joins(:restaurant).within(distance, origin: origin)
  end

  def self.most_nearby(latitude, longitude)
    joins(:restaurant).within(DEFAULT_DISTANCE, origin: [latitude, longitude])
  end
  
  def self.most_nearby_cat(latitude, longitude)
    joins(:restaurant).within(DEFAULT_DISTANCE, origin: [latitude, longitude]).where( 'restaurants.restaurant_category_id in (1,2,3,5)')
  end

  def available?
    end_date > Date.current
  end

  def has_more_quantity?
    quantity.to_i > UserCoupon.where(coupon_id: id).count
  end

  def restaurant_name
    restaurant.try(:name)
  end

  private
  def generate_coupon_code
    self.code = loop do
      random_token = SecureRandom.hex(3)
      break random_token unless self.class.exists?(code: random_token, restaurant: restaurant)
    end
  end

  def push_notification_to_users
    CouponNotificationJob.perform_later(id)
  end
end
