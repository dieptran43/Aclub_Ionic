FactoryGirl.define do
  factory :venue do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph(2) }
    longitude 105.213838
    latitude 21.812266

    trait :star_bucks do |venue|
      venue.name { 'Starbucks Coffee Lan Vien' }
      venue.longitude 105.85239200000001
      venue.latitude 21.022592
    end

    trait :vuvuzela do |venue|
      venue.name { 'Vuvuzela - Beer Club' }
      venue.longitude 105.859197
      venue.latitude 21.016534
    end

    trait :highland do |venue|
      venue.name { 'Highland Coffee' }
      venue.longitude 105.85759400000006
      venue.latitude 21.024052
    end

    trait :with_coupons do
      after(:build) do |venue|
        create_list(:coupon, 3, venue: venue)
      end
    end
  end
end
