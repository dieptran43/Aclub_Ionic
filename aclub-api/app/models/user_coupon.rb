class UserCoupon < ActiveRecord::Base
  belongs_to :user
  belongs_to :coupon

  enum status: { available: 0, used: 1 }
  before_create :generate_token

  validates_uniqueness_of :coupon_id, scope: :user_id

  def self.find_by_userid_couponid(userid ,couponid)
    #code
     where("user_id = '#{userid}' AND coupon_id = '#{couponid}'").first
  end
  private
  def generate_token
    self.token = loop do
      random_token = SecureRandom.hex(3)
      break random_token unless self.class.exists?(token: random_token, coupon: coupon)
    end
  end
end
