require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe 'relationships' do
    it { is_expected.to belong_to(:restaurant) }
  end

  describe 'scope #available' do
    let(:coupon_1) { create(:coupon, end_date: 1.months.from_now) }
    let(:coupon_2) { create(:coupon, end_date: 1.days.ago) }
    let(:coupon_3) { create(:coupon, end_date: 1.months.ago) }
    let(:coupon_4) { create(:coupon, end_date: 1.days.from_now) }

    it 'returns all coupons that havent expired yet' do
      expect(Coupon.available).to match_array [coupon_1, coupon_4]
    end
  end

  describe '.hot_and_nearby' do
    let(:restaurant1) { create(:restaurant, lon: 105, lat: 27) }
    let(:restaurant2) { create(:restaurant, lon: -73, lat: 40) }
    let(:restaurant3) { create(:restaurant, lon: 105, lat: 27) }
    let!(:coupon1) { create(:coupon, restaurant: restaurant1) }
    let!(:coupon2) { create(:coupon, restaurant: restaurant2) }
    let!(:coupon3) { create(:coupon, restaurant: restaurant3) }

    before do
      coupon3.update_attributes(impressions_count: 3)
      coupon3.update_attributes(impressions_count: 2)
    end

    it 'should return hostest coupon within a distance from an origin ordered by ranking number' do
      expect(Coupon.hot_and_nearby(27, 105).pluck(:id)).to eq [coupon3.id, coupon1.id]
    end
  end

  describe 'scope .hostest' do
    let!(:coupon1) { create(:coupon) }
    let!(:coupon2) { create(:coupon) }
    let!(:coupon3) { create(:coupon) }

    before do
      coupon3.update_attributes(impressions_count: 3)
      coupon2.update_attributes(impressions_count: 2)
    end

    it 'should return hotest coupons' do
      expect(Coupon.hotest.map(&:id)).to eq [coupon3.id, coupon2.id, coupon1.id]
    end
  end

  describe 'scope .featured' do
    let!(:coupon1) { create(:coupon) }
    let!(:coupon2) { create(:coupon, priority: 1) }
    let!(:coupon3) { create(:coupon, priority: 2) }

    it 'should return featured coupons' do
      expect(Coupon.featured.map(&:id)).to eq [coupon3.id, coupon2.id, coupon1.id]
    end
  end

  describe '#has_more_quantity?' do
    context 'there still coupon for user to take' do
      let(:coupon) { create(:coupon, quantity: 2 ) }
      let!(:user_coupon) { create(:user_coupon, coupon: coupon)}

      it 'should return true' do
        expect(coupon.has_more_quantity?).to be_truthy
      end
    end

    context 'there is no more coupon for user to take' do
      let(:coupon_1) { create(:coupon, quantity: 0 ) }
      let(:coupon_2) { create(:coupon, quantity: nil ) }
      let(:coupon) { create(:coupon, quantity: 2 ) }
      let!(:user_coupons) { create_list(:user_coupon, 3, coupon: coupon)}

      it 'should retun true' do
        expect(coupon_1.has_more_quantity?).to be_falsy
        expect(coupon_2.has_more_quantity?).to be_falsy
        expect(coupon.has_more_quantity?).to be_falsy
      end
    end
  end
end
