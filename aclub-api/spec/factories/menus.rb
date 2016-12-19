FactoryGirl.define do
  factory :menu do
    name { Faker::Internet.name }
    price { Random.rand(10000) }
    menu_category
  end
end
