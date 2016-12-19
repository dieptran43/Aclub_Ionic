module Api
  class AuthorizedUserPresenter < Presenter
    def as_json(*)
      {
        id: object.id,
        name: object.name,
        email: object.email,
        phone: object.phone,
        avatar: object.avatar_urls,
        token: object.authentication_token.token,
        available_coupons: ArrayPresenter.new(object.available_user_coupons, UserCouponPresenter),
        used_coupons: ArrayPresenter.new(object.used_user_coupons, UserCouponPresenter),
        unverified_email: object.unverified_email,
        email_verification_token: object.email_verification_token
      }
    end
  end
end
