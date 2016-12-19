require 'rails_helper'

RSpec.describe Restaurant, type: :model do

  describe '#count_available_coupons' do
    let(:number_of_coupon) { Random.rand(10) }
    let(:restaurant) { create(:restaurant) }
    let!(:coupons) { create_list(:coupon, number_of_coupon, restaurant: restaurant) }
    
    it 'should return number of coupons belong to restaurant' do
      expect(restaurant.count_available_coupons).to eq number_of_coupon
    end
  end

  describe '.get_index' do
    let(:params) { { test: "No requirement yet" } }
    let!(:restaurants) { create_list(:restaurant, 3) }
    
    it 'should return all Restaurants' do
      expect(Restaurant.get_index(params).pluck(:id)).to match_array restaurants.map(&:id)
    end
  end
end
