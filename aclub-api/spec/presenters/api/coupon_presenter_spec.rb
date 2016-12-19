require 'rails_helper'

module Api
  RSpec.describe CouponPresenter do
    let(:coupon) { create(:coupon) }
    let(:subject) { JSON.parse(CouponPresenter.new(coupon).to_json) }
    let(:expected_result) { 
      HashWithIndifferentAccess.new({
        id: coupon.id,
        code: coupon.code,
        start_date: coupon.start_date.iso8601(3),
        end_date: coupon.end_date.iso8601(3),
        description: coupon.description,
        short_description: coupon.short_description,
        image: coupon.image_urls,
        required_minimum_invitees: coupon.required_minimum_invitees,
        quantity: coupon.quantity,
        restaurant: (RestaurantPresenter.new(coupon.restaurant).as_json if coupon.restaurant),
        comments_count: coupon.comments_count,
        comments: ArrayPresenter.new(coupon.comments, CommentPresenter).as_json,
        usage_count: coupon.user_coupons.count,
        distance: coupon.try(:distance),
        average_rating: coupon.average_rating
      })
    }

    describe '#as_json' do
      it 'should build json presenter for coupon' do
        expect(subject).to eq expected_result
      end
    end
  end
end
