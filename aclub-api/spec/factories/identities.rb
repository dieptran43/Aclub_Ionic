FactoryGirl.define do
  factory :identity do
    uid { Faker::Internet.mac_address }
    access_token { Faker::Internet.mac_address }
  end

  factory :facebook_identity do
    uid { Faker::Internet.mac_address }
    access_token { Faker::Internet.mac_address }
  end
end
