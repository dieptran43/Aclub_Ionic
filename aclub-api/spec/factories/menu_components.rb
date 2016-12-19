FactoryGirl.define do
  factory :menu_component do
    content { Faker::Lorem.word }
    menu
  end
end
