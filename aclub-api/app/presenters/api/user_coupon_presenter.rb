module Api
  class UserCouponPresenter < Presenter
    def as_json(*)
      result = CouponPresenter.new(object.coupon).as_json
      result[:code] = object.token
      result
    end
  end
end
