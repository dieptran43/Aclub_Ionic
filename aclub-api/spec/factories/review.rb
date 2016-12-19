FactoryGirl.define do
  factory :review do
    rating { Random.rand(5) }
    venue
  end
end
