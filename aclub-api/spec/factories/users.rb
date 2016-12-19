FactoryGirl.define do
  factory :user do
    phone { "84969#{Random.rand.to_s[2..7]}" }
    name { Faker::Name.name }
  end
end
