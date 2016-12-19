require 'rails_helper'

module Api
  RSpec.describe EnvPresenter do
    let!(:users) { create_list(:user, EnvPresenter::RESPONSE_LIMITATION) }
    let!(:coupons) { create_list(:coupon, EnvPresenter::RESPONSE_LIMITATION) }
    let!(:restaurant_categories) { create_list(:restaurant_category, EnvPresenter::RESPONSE_LIMITATION) }
    let(:latitude) { coupons.first.restaurant.lat }
    let(:longitude) { coupons.first.restaurant.lon }
    let(:subject) { EnvPresenter.new(latitude, longitude) }

    describe '#initialize' do
      it 'should get all object needed for home page' do
        expect(subject.active_users.pluck(:id)).to match_array users.map(&:id)
        expect(subject.newest_users.pluck(:id)).to match_array users.map(&:id)
        expect(subject.restaurant_categories.pluck(:id)).to match_array restaurant_categories.map(&:id)
        expect(subject.hotest_coupons.pluck(:id)).to match_array coupons.map(&:id)
        expect(subject.featured_coupons.pluck(:id)).to match_array coupons.map(&:id)
      end
    end

    describe '#as_json' do
      let(:json_data) { subject.as_json }

      it 'should return json format for coupons, users and restaurants array' do
        expect(json_data.has_key?(:active_users)).to eq true
        expect(json_data.has_key?(:newest_users)).to eq true
        expect(json_data.has_key?(:restaurant_categories)).to eq true
        expect(json_data.has_key?(:hotest_coupons)).to eq true
        expect(json_data.has_key?(:featured_coupons)).to eq true
      end
    end
  end
end