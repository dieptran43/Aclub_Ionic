class CouponNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(coupon_id)
    if coupon = Coupon.find_by_id(coupon_id)
      alert = "Nhà hàng #{coupon.restaurant_name} vừa đăng coupon mới"
      data = { type: 'new_coupon', object_id: coupon_id }

      User.includes(:devices).find_each do |user|
        Api::NotificationService.new(user.devices, alert).push_notification(data)
      end
      p "--Finished sending Notification to #{User.count} users!--"
    else
      p "--record not found!--"
    end
  end
end
