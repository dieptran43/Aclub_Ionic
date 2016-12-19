require 'rails_helper'

RSpec.describe CouponNotificationJob do
  describe '#perform' do
    let(:restaurant) { create(:restaurant) }
    let(:coupon) { create(:coupon, restaurant: restaurant) }
    let(:alert) { "Nhà hàng #{restaurant.name} vừa đăng coupon mới" }
    let(:data) { { type: 'new_coupon', object_id: coupon.id } }
    let(:users) { create_list(:user, 3) }

    it 'should send notification about new coupon to all devices in the system' do
      users.each do |user|
        notification_service = double(Api::NotificationService) 
        expect(Api::NotificationService).to receive(:new).with(user.devices, alert).and_return(notification_service)
        expect(notification_service).to receive(:push_notification).with(data)
      end

      CouponNotificationJob.new.perform(coupon.id)
    end
  end
end