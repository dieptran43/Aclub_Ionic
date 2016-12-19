When(/^I click on create new record$/) do
  find(".btn.new-record").click
end

When(/^I click on "(.*?)" button$/) do |text|
  click_button text
end

Then(/^I click on Sang Trang Sửa button$/) do
  #somehow capybara does not understand vietnamese text when find button by text
  find(".btn.btn-info").click
end
