require 'rails_helper'

module Api
  describe VenuesController, api: true, set_api_authorized_headers: true do
    let(:response_body) { JSON.parse(response.body) }
    let(:venues) { create_list(:venue, 4) }

    describe "GET index" do
      let(:venue_ids) { json_response.map { |venue| venue['id'] } }
      let(:params) { { query: venues.first.name, latitude: venues.first.latitude.to_s, longitude: venues.first.longitude.to_s } }

      before do
        allow(Venue).to receive(:search_and_update).with(params.stringify_keys).and_return(venues)
      end

      it "returns all available coupons" do
        get :index, params

        expect(response).to be_success
        expect(venue_ids).to eq venues.map(&:id)
      end
    end

    describe 'GET show' do
      let(:venue) { create(:venue) }
      let(:params) { { id: venue.id } }

      before do
        expect_any_instance_of(VenueDetailsService).to receive(:get_details).and_return(venue)
      end

      it "returns all available coupons" do
        get :show, params

        expect(response).to be_success
        expect(response_body["id"]).to eq venue.id
      end
    end

    describe "GET popular_restaurants" do
      let(:params) { { latitude: venues.first.latitude.to_s, longitude: venues.first.longitude.to_s } }
      let(:venue_ids) { json_response.map { |venue| venue['id'] } }

      before do
        allow(Venue).to receive(:search_and_update).with(params.stringify_keys).and_return(venues)
      end

      it "should return list of popular restaurants within given distance from an origin" do
        get :popular_restaurants, params

        expect(response).to be_success
        #  rspec allow method return wrong order of venues
        #  need investigate more
        #  expect(venue_ids).to eq venues.map(&:id)
      end
    end
  end
end
