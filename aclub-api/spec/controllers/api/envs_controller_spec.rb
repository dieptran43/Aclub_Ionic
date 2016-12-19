require 'rails_helper'

module Api
  describe EnvsController, api: true do
    describe 'GET index', set_api_headers: true do
      let(:expect_response) { { "expected" => "expected" } }
      let(:response_body) { JSON.parse(response.body)}
      let(:restaurant) { create(:restaurant) }
      let(:params) { { latitude: restaurant.lat, longitude: restaurant.lon } }

      it 'should return all environment data needed for home page on app' do
        allow(EnvPresenter).to receive(:new).and_return(expect_response)

        get :index, params
        expect(response.status).to eq 200
        expect(response_body).to eq expect_response
      end
    end
  end
end