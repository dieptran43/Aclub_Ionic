FactoryGirl.define do
  factory :admin do
    email { Faker::Internet.email }
    password { 'password' }

    trait :super_admin do
      role  { Admin::ADMIN }
    end

    trait :owner do
      role { Admin::OWNER }
    end
  end
end
