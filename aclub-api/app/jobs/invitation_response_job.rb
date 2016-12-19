class InvitationResponseJob < ActiveJob::Base
  queue_as :default

  def perform(coupon_invitation_id)
    if coupon_invitation = CouponInvitation.find_by_id(coupon_invitation_id)
      inviter = coupon_invitation.inviter
      invitee = coupon_invitation.invitee
      coupon = coupon_invitation.coupon

      if coupon.available?
        number_of_accepted_invitees = inviter.number_of_accepted_invitees(coupon)
        action = coupon_invitation.accepted? ? "chấp nhận" : "từ chối"
        alert = "#{invitee.representative_name} đã #{action} lời mời dùng coupon của nhà hàng #{coupon.restaurant_name}."
        alert += " Bạn đã đủ điều kiện sử dụng coupon này." if number_of_accepted_invitees >= coupon.required_minimum_invitees

        data = {
          type: 'coupon_invitation_response',
          object_id: coupon_invitation_id,
          coupon_id: coupon.id,
          inviter_id: inviter.id,
          invitee_id: invitee.id
        }
        Api::NotificationService.new(inviter.devices, alert).push_notification(data)
        p "--Finished sending coupon invitation response notification to #{inviter.representative_name}!--"
        p "--Alert Mesage: #{alert}--"
      else
        p "coupon##{coupon.id} đã hết hạn sử dụng"
      end
    else
      p "--record not found!--"
    end
  end
end
