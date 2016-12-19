Given(/^I log in as an owner$/) do
  owner = FactoryGirl.create(:admin, :owner, password: 'password')
  visit new_admin_session_path
  fill_in :admin_email, with: owner.email
  fill_in :admin_password, with: 'password'
  click_button 'Log in'
end

When(/^I go to super admin cms venues index page$/) do
  visit cms_venues_path
end

Then(/^I should be redirect to home page$/) do
  expect(current_path).to eq root_path
end

Given(/^I log in as super admin$/) do
  admin = FactoryGirl.create(:admin, :super_admin, password: 'password')
  visit new_admin_session_path
  fill_in :admin_email, with: admin.email
  fill_in :admin_password, with: 'password'
  click_button 'Log in'
end

When(/^I go to owner cms venues index page$/) do
  visit owner_venues_path
end

Given(/^There is some user in the system$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I go to users index page$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see list of users$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I click to show a user$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see this user details information$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^There is some advertising events in the system$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I go to advertising events index page$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see list of advertising events$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I click on create new advertising event$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I fill in advertising event form$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see my newly created advertising event details$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I edit this advertising event$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see my event is updated$/) do
  pending # express the regexp above with the code you wish you had
end
