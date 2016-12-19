FactoryGirl.define do
  factory :coupon do
    description { Faker::Lorem.paragraph(2) }
    short_description { Faker::Lorem.sentence }
    start_date { Date.current }
    end_date { 1.months.from_now }
    restaurant
  end
end
