FactoryGirl.define do
  factory :advertising_event do
    maximum_number_of_winners 10
    url { Faker::Internet.name }
  end
end
