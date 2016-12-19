Given(/^There is some owners in the system$/) do
  create(:restaurant_owner)
end

When(/^I go to cms restaurant owners index page$/) do
  visit cms_restaurant_owners_path
end

Then(/^I should see list of restaurant owners$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I click on create new restaurant owners$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I fill in the restaurant owners form$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I edit this restaurant owners$/) do
  pending # express the regexp above with the code you wish you had
end
