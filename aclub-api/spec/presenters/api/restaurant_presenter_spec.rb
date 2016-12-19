require 'rails_helper'

module Api
  RSpec.describe RestaurantPresenter do
    let(:restaurant) { create(:restaurant) }
    let(:subject) { JSON.parse(RestaurantPresenter.new(restaurant).to_json) }
    let(:expected_result) { 
      HashWithIndifferentAccess.new({
        id: restaurant.id,
        city: restaurant.city.try(:name),
        district: restaurant.district.try(:name),
        area: restaurant.area.try(:name),
        restaurant_category: restaurant.restaurant_category.try(:name),
        alias: restaurant.alias,
        name: restaurant.try(:name),
        address: restaurant.try(:address),
        logo_image: { thumb: restaurant.try(:image), origin: restaurant.try(:image) },
        phone: restaurant.phone,
        lat: restaurant.lat,
        lon: restaurant.lon,
        images: restaurant.try(:images),
        menus: ArrayPresenter.new(restaurant.menus, MenuPresenter).as_json,
        average_rating: restaurant.average_rating,
        comment_count: restaurant.comments_count,
        coupons: ArrayPresenter.new(restaurant.coupons, CouponInformationPresenter).as_json,
        comments: ArrayPresenter.new(restaurant.comments, CommentPresenter).as_json
      })
    }

    describe '#as_json' do
      it 'should build json presenter for restaurant' do
        expect(subject).to eq expected_result
      end
    end
  end
end
