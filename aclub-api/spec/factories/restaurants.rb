FactoryGirl.define do
  factory :restaurant do
    name { Faker::Name.name }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
  end
end
