Then(/^I should see list of venues$/) do
  Venue.all.each do |venue|
    expect(page).to have_content venue.name
  end
end

When(/^I click on create new venue$/) do
  step 'I click on create new record'
end

When(/^I fill in the venue form$/) do
  @name = Faker::Internet.name
  @description = Faker::Lorem.paragraph
  fill_in :venue_name, with: @name
  fill_in :venue_description, with: @description
end

Then(/^I should see my newly created venue details$/) do
  expect(page).to have_content @name
  expect(page).to have_content @description
end

Then(/^I edit this venue$/) do
  @new_name = Faker::Internet.name
  @new_description = Faker::Lorem.paragraph
  fill_in :venue_name, with: @new_name
  fill_in :venue_description, with: @new_description
end

Then(/^I should see my venue is updated$/) do
  expect(page).to have_content @new_name
  expect(page).to have_content @new_description
end

Then(/^I should see list of coupons$/) do
  Coupon.all.each do |coupon|
    expect(page).to have_content coupon.venue.name
  end
end

Then(/^I click on create new coupons$/) do
  step 'I click on create new record'
end

Then(/^I fill in the coupon form$/) do
  @short_description = Faker::Internet.name
  @description = Faker::Lorem.paragraph
  fill_in :coupon_short_description, with: @short_description
  fill_in :coupon_description, with: @description
end

Then(/^I should see my newly created coupon details$/) do
  expect(page).to have_content @short_description
  expect(page).to have_content @description
end

Then(/^I edit this coupon$/) do
  @new_short_description = Faker::Internet.name
  @new_description = Faker::Lorem.paragraph
  fill_in :coupon_short_description, with: @new_short_description
  fill_in :coupon_description, with: @new_description
end

Then(/^I should see my coupon is updated$/) do
  expect(page).to have_content @new_short_description
  expect(page).to have_content @new_description
end