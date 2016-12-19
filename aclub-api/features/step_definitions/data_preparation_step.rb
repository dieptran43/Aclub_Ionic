Given(/^There is some venues in the system$/) do
  FactoryGirl.create_list(:venue, 2)
end

Given(/^There is some coupons in the system$/) do
  FactoryGirl.create_list(:coupon, 2)
end

When(/^I go to cms coupons index page$/) do
  visit cms_coupons_path
end