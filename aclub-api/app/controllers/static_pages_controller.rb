class StaticPagesController < ApplicationController
  layout 'static_pages'
  def service_intro
  end

  def app_intro
  end

  def index
    @coupons = Coupon.hotest.limit(8)
  end

  def voucher
    @coupons = Coupon.hotest.limit(15)
  end
end