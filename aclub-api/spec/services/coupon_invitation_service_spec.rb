require 'rails_helper'

module Api
  RSpec.describe CouponInvitationService do
    describe '#create' do
      let!(:user) { create(:user) }
      let!(:user_1) { create(:user, phone: '84989471289') }
      let!(:user_2) { create(:user, phone: '84989471281') }
      let!(:user_3) { create(:user, phone: '84989471282') }
      let!(:user_4) { create(:user, phone: '84989471283') }
      let(:coupon) { create(:coupon) }
      let(:coupon_invitation_params) { {
        coupon_id: coupon_id,
        invitee_ids: [user_1.id, user_2.id, user_4.id]
      } }
      subject { described_class.new(coupon_invitation_params, user) }

      context 'successfully' do
        let(:coupon_id) { coupon.id }

        it 'creates coupon invitations' do
          expect(subject.create).to be_truthy
          expect(user.invitees(coupon_id)).to match_array [user_1, user_2, user_4]
        end
      end

      context 'unsuccessfully' do
        let(:coupon_id) { -1 }

        it 'returns false' do
          expect(subject.create).to be_falsey
        end
      end
    end
  end
end
