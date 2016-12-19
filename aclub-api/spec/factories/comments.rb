FactoryGirl.define do
  factory :comment do
    content { Faker::Lorem.sentence }
    rate { (1..10).to_a.sample }
    commenter { create(:user) }
    commentable { create(:coupon) }
  end
end
