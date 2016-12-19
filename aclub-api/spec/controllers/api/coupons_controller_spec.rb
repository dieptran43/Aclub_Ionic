require 'rails_helper'

module Api
  describe CouponsController, api: true, set_api_authorized_headers: true do
    let(:coupon) { create(:coupon) }

    describe 'GET index' do
      let(:coupon_ids) { json_response.map { |coupon| coupon['id'] } }

      before do
        expect(Coupon).to receive(:available).and_return([coupon])
      end

      it 'returns all available coupons' do
        get :index

        expect(response).to be_success
        expect(coupon_ids).to eq [coupon.id]
      end
    end

    describe 'GET show' do
      context 'existing coupon' do
        it 'returns coupon with given id' do
          get :show, id: coupon.id

          expect(response).to be_success
          expect(json_response['id']).to eq coupon.id
        end
      end

      context 'non existing coupon' do
        let(:errors) { { 'errors' => I18n.t("base.api.not_found") } }

        it 'returns error not found' do
          get :show, id: coupon.id + 1

          expect(response.status).to eq 404
          expect(json_response).to eq errors
        end
      end
    end

    describe "GET hot_nearby_coupons" do
      context 'latitude and longitude params are present' do
        let(:longitude) { coupon.restaurant.lon }
        let(:latitude) { coupon.restaurant.lat }

        it "return list of hot and nearby coupons" do
          allow_any_instance_of(User).to receive_message_chain(:available_coupons, :available, :hot_and_nearby).and_return([coupon])
          get :hot_and_nearby, longitude: longitude, latitude: latitude

          expect(response).to be_success
          expect(json_response[0]['id']).to eq coupon.id
        end
      end

      context 'latitude and longitude params are not present' do
        let(:longitude) { nil }
        let(:latitude) { nil }

        it "return list of hot and nearby coupons" do
          get :hot_and_nearby, longitude: longitude, latitude: latitude

          expect(response.status).to eq 422
        end
      end
    end
  end
end
