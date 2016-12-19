require 'rails_helper'

RSpec.describe UserCoupon, type: :model do
  describe 'relationships' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:coupon) }
  end

  describe 'default attributes' do
    let(:user_coupon) { create(:user_coupon) }

    it 'is available after creating' do
      expect(user_coupon).to be_available
    end
  end
end
