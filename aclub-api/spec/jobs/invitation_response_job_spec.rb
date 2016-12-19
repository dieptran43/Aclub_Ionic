require 'rails_helper'

RSpec.describe InvitationResponseJob do
  describe '#perform' do
    let(:inviter) { create(:user) }
    let(:invitee) { create(:user) }
    let(:coupon_invitation)  { create(:coupon_invitation, inviter_id: inviter.id, invitee_id: invitee.id, status: status) }
    let(:coupon) { coupon_invitation.coupon }
    let(:data) {{
      type: 'coupon_invitation_response',
      object_id: coupon_invitation.id,
      coupon_id: coupon.id,
      inviter_id: inviter.id,
      invitee_id: invitee.id
    }}
    let(:notification_service) { double(Api::NotificationService) }

    context 'invitee accepted invitation' do
      let(:status) { 'accepted' }
      let(:alert) { "#{invitee.representative_name} đã chấp nhận lời mời dùng coupon của nhà hàng #{coupon.restaurant.name} (code: #{coupon.code})." }

      it 'should send notification about accepted response on coupon invitation to all devices of inviter' do
        expect(Api::NotificationService).to receive(:new).with(invitee.devices, alert).and_return(notification_service)
        expect(notification_service).to receive(:push_notification).with(data)

        InvitationResponseJob.new.perform(coupon_invitation.id)
      end
    end

    context 'inviter denied invitation' do
      let(:status) { 'denied' }
      let(:alert) { "#{invitee.representative_name} đã từ chối lời mời dùng coupon của nhà hàng #{coupon.restaurant.name} (code: #{coupon.code})." }

      it 'should send notification about denied response on coupon invitation to all devices of inviter' do
        expect(Api::NotificationService).to receive(:new).with(invitee.devices, alert).and_return(notification_service)
        expect(notification_service).to receive(:push_notification).with(data)

        InvitationResponseJob.new.perform(coupon_invitation.id)
      end
    end
  end
end