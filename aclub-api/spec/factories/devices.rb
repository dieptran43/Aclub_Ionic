FactoryGirl.define do
  factory :device do
    token { Faker::Lorem.characters(10) }
    user
  end

end
