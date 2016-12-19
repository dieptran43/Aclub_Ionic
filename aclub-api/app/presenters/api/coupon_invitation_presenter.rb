module Api
  class CouponInvitationPresenter < Presenter
    def as_json(*)
      {
        id: object.id,
        created_at: object.created_at,
        invitee: object.invitee.representative_name,
        invitee_id: object.invitee.id,
        coupon_id: object.coupon.id,
        coupon_code: object.coupon.code,
        coupon_image: object.coupon.image,
        coupon_short_description: object.coupon.short_description,
        coupon_description: object.coupon.description,
        status: object.status,        
        inviter_name: object.inviter.name,
        inviter_avatar: object.inviter.avatar,
        restaurant_name: object.coupon.restaurant.name,
        restaurant_address: object.coupon.restaurant.address
      }
    end
  end
end
