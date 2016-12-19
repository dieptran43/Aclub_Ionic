require 'rails_helper'

module Api
  RSpec.describe VenuePresenter do
    let(:venue) { create(:venue) }
    let(:subject) { JSON.parse(VenuePresenter.new(venue).to_json) }
    let(:expected_result) { 
      HashWithIndifferentAccess.new({
        id: venue.id,
        name: venue.name,
        description: venue.description,
        longitude: venue.longitude,
        latitude: venue.latitude,
        full_address: venue.full_address,
        categories: [], #temporarily removed from the system
        website: venue.website,
        formatted_phone_number: venue.formatted_phone_number,
        opening_hours: venue.formatted_opening_hours,
        images: venue.image_urls,
        average_rating: venue.try(:average_rating)
      })
    }

    describe '#as_json' do
      it 'should build json presenter for venue' do
        expect(subject).to eq expected_result
      end
    end
  end
end
