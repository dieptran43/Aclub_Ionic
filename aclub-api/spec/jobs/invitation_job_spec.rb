require 'rails_helper'

RSpec.describe InvitationJob do
  describe '#perform' do
      let(:inviter) { create(:user) }
      let(:invitee) { create(:user) }
      let(:coupon_invitation)  { create(:coupon_invitation, inviter_id: inviter.id, invitee_id: invitee.id) }
      let(:coupon) { coupon_invitation.coupon }
      let(:alert) { "#{inviter.representative_name} mời bạn sử dụng coupon của nhà hàng #{coupon.restaurant.try(:name)}" }
      let(:data) {{
        type: 'coupon_invitation',
        object_id: coupon_invitation.id,
        coupon_id: coupon.id
      }}
      let(:notification_service) { double(Api::NotificationService) }

    it 'should send notification about new coupon invitation to all devices of invitee' do
      expect(Api::NotificationService).to receive(:new).with(invitee.devices, alert).and_return(notification_service)
      expect(notification_service).to receive(:push_notification).with(data)

      InvitationJob.new.perform(coupon_invitation.id)
    end
  end
end