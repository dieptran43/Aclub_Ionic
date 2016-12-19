require 'rails_helper'

module Api
  describe UserCouponsController, api: true, set_api_authorized_headers: true do
    let(:coupon) { create(:coupon, required_minimum_invitees: 0) }
    let(:response_body) { JSON.parse(response.body) }

    describe 'POST create' do
      let(:user_coupons_params) { { coupon_id: coupon_id } }

      before do
        post :create, user_coupon: user_coupons_params
      end

      context 'existing coupon' do
        let(:coupon_id) { coupon.id }

        it 'returns ok' do
          expect(response).to be_success
          expect(user.available_coupons).to match_array [coupon]
        end
      end

      context 'non existing coupon' do
        let(:coupon_id) { coupon.id + 1 }

        it 'returns not found' do
          expect(response.status).to eq 404
        end
      end

      context 'coupon has no more quantity left' do
        let(:coupon) { create(:coupon, required_minimum_invitees: 0, quantity: 0) }
        let(:coupon_id) { coupon.id }

        it 'should return no_more_quantity error' do
          expect(response.status).to eq 422
          expect(response_body["errors"]).to eq I18n.t('base.api.user_coupons.no_more_quantity')
        end
      end
    end

    describe 'PUT update' do
      let(:user_coupons_params) { { coupon_id: coupon_id } }

      before do
        user.available_coupons << coupon
        put :update, id: 1, user_coupon: user_coupons_params
      end

      context 'coupon is in coupon box of user' do
        let(:coupon_id) { coupon.id }

        it "returns ok and add one 'used' count to the coupon" do
          expect(response).to be_success
          expect(user.used_coupons).to match_array [coupon]
          expect(coupon.impressionist_count(message: Coupon::USED)).to eq 1
        end
      end

      context 'non existing coupon' do
        let(:coupon_id) { coupon.id + 1 }

        it 'returns not found' do
          expect(response.status).to eq 404
        end
      end
    end
  end
end
