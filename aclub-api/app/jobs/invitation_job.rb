class InvitationJob < ActiveJob::Base
  queue_as :default

  def perform(coupon_invitation_id)
    if coupon_invitation = CouponInvitation.find_by_id(coupon_invitation_id)
      inviter = coupon_invitation.inviter
      invitee = coupon_invitation.invitee
      coupon = coupon_invitation.coupon

      alert = "#{inviter.representative_name} mời bạn sử dụng coupon của nhà hàng #{coupon.restaurant_name}"
      data = {
        type: 'coupon_invitation',
        object_id: coupon_invitation_id,
        coupon_id: coupon.id
      }
      Api::NotificationService.new(invitee.devices, alert).push_notification(data)
      p "--Finished send invitation from #{inviter.representative_name} to #{invitee.representative_name}!--"
    else
      p "--record not found!--"
    end
  end
end
