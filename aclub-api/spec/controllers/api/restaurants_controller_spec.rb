require 'rails_helper'

module Api
  describe RestaurantsController, api: true, set_api_headers: true do
    let(:restaurants) { create_list(:restaurant, 4) }
    let(:json_response) { JSON.parse(response.body) }

    describe 'GET index' do
      let(:params) { { "page" => "1" } }
      let(:restaurant_ids) { json_response.map{ |r| r['id']} }
      before do
        allow(Restaurant).to receive(:get_index).with(params).and_return(restaurants)
      end

      it 'returns all available coupons' do
        get :index, params

        expect(response).to be_success
        expect(restaurant_ids).to match_array restaurants.map(&:id)
      end
    end

    describe 'GET show' do
      let(:restaurant) { create(:restaurant) }

      it 'should return detail of the restaurant and count 1 more impressive record for this restaurant' do
        get :show, { id: restaurant.id }

        expect(response).to be_success
        expect(json_response["id"]).to eq restaurant.id
      end
    end
  end
end