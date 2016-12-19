FactoryGirl.define do
  factory :restaurant_category do
    name { Faker::Internet.name }
    position { 1 }
  end
end
