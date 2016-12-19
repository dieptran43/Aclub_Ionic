class UserVoucher < ActiveRecord::Base
  belongs_to :user
  belongs_to :coupon

  before_create :generate_voucher_code

  private
  def generate_voucher_code
    #make a random number, if it is a multiple of 9 than this is a lucky user - 1 is lucky, 0 is unlucky
    self.status = (Random.rand(1...100) % 9 == 0) ? 1 : 0
    self.code = loop do
      random_token = SecureRandom.hex(3)
      break random_token unless self.class.exists?(code: random_token)
    end
  end
end
