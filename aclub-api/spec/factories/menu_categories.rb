FactoryGirl.define do
  factory :menu_category do
    trait :breakfirst do
      name MenuCategory::BREAKFIRST
    end

    trait :launch do
      name MenuCategory::LUNCH
    end

    trait :dinner do
      name MenuCategory::DINNER
    end
  end
end
