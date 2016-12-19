require 'rails_helper'

RSpec.describe Venue, type: :model do
  describe 'relationships' do
  end

  describe '.search_and_update' do
    before do
      create_list(:venue, 4)
    end
    let(:venues) { Venue.all }

    context 'lat and long params are passed' do
      let(:params) { { query: venues.first.name, latitude: venues.first.latitude.to_s, longitude: venues.first.longitude.to_s } }

      before do
        # allow(VenueDetailsService).to receive(:crawl_venues).and_return(venues)
        venues.each { |venue| allow(Venue).to receive(:find_or_create_within).with(venue).and_return(venue) }
        allow(Venue).to receive(:internal_database_venue).and_return(venues)
      end

      it 'should create records if nothing exist within given radius and return with our own record' do
        expect(Venue.search_and_update(params)).to match_array venues
      end
    end

    context 'lat and long params are not passed' do
      let(:params) { { query: "ABC" } }

      before do
        allow(Venue).to receive(:index_by_name).with(params[:query]).and_return(Venue.where(id: venues.map(&:id)))
      end

      it 'should return all record searched by name' do
        expect(Venue.search_and_update(params)).to match_array venues
      end
    end
  end

  describe '.find_or_create_within' do
    let!(:venue) { create(:venue) }

    context 'there are already recorded venues' do
      let(:google_place_venue) { OpenStruct.new({ name: venue.name, lat: venue.latitude, lng: venue.longitude, photos: [] }) }

      it 'should return the recorded venue' do
        expect(Venue.find_or_create_within(google_place_venue)).to eq venue
      end
    end

    context 'there is no recorded venue' do
      let(:google_place_venue) { OpenStruct.new({ name: Faker::Internet.name, lat: venue.latitude, lng: venue.longitude, photos: [] }) }

      it 'should create new one' do
        expect{ Venue.find_or_create_within(google_place_venue) }.to change{ Venue.count }.by(1)
        expect(Venue.last.name).to eq google_place_venue.name
      end
    end
  end

  describe'.popular_restaurants' do
    let(:origin_venue) { create(:venue) }
    let(:star_bucks) { create(:venue, :star_bucks)}
    let(:vuvuzela) { create(:venue, :vuvuzela)}
    let(:highland) { create(:venue, :highland)}

    context 'request popular_restaurants within latitude and longtitude' do
      let(:params) {{
        latitude: origin_venue.latitude,
        longitude: origin_venue.longitude,
        radius: 0
      }}

      it 'should return all restaurant nearby order by has most views first' do
        expect(Venue.popular_restaurants(params).pluck(:id)).to eq Array(origin_venue.id)
      end
    end

    context 'request popular_restaurants without passing an location origin' do
      let(:params) {{
        latitude: origin_venue.latitude,
        longitude: origin_venue.longitude,
        radius: 9999999
      }}

      before do
        (0..1).each { |i| ActiveRecord::Base.connection.execute("INSERT INTO impressions (message, impressionable_id, impressionable_type) VALUES ('view', '#{origin_venue.id}', 'Venue');") }
        (0..2).each { |i| ActiveRecord::Base.connection.execute("INSERT INTO impressions (message, impressionable_id, impressionable_type) VALUES ('view', '#{star_bucks.id}', 'Venue');") }
        (0..3).each { |i| ActiveRecord::Base.connection.execute("INSERT INTO impressions (message, impressionable_id, impressionable_type) VALUES ('view', '#{vuvuzela.id}', 'Venue');") }
        (0..4).each { |i| ActiveRecord::Base.connection.execute("INSERT INTO impressions (message, impressionable_id, impressionable_type) VALUES ('view', '#{highland.id}', 'Venue');") }
      end

      it 'should return all popular restaurants order by has most views first' do
        expect(Venue.popular_restaurants(params).pluck(:id)).to eq [highland, vuvuzela, star_bucks, origin_venue].map(&:id)
      end
    end
  end

  describe "scope .highest_rating" do
    let(:venue_1) { create(:venue) }
    let(:venue_2) { create(:venue) }
    let(:venue_3) { create(:venue) }
    let(:expect_result) { [[venue_1.id, 4.0], [venue_2.id, 2.0], [venue_3.id, 0.0]] }
    before do
      (1..3).each do |i| create(:review, venue: venue_1, rating: i * 2) end
      (1..3).each do |i| create(:review, venue: venue_2, rating: i) end
      (1..3).each do |i| create(:review, venue: venue_3, rating: 0) end
    end

    it 'should return highest_rating venues' do
      expect(Venue.highest_rating.map { |v| [v.id, v.average_rating.to_f] }).to eq expect_result
    end
  end
end
