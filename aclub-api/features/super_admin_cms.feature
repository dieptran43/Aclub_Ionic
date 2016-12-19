Feature: Super Admin CMS
  As an admin
  In Order to manage system data
  I have to use cms system

  Scenario: Owner CMS Page
    Given I log in as super admin
    When I go to owner cms venues index page
    Then I should be redirect to home page

  Scenario: Super Admin CMS venues page
    Given There is some venues in the system
    Given I log in as super admin
    Then I should see list of venues
    When I click on create new venue
    And I fill in the venue form
    And I click on "Submit" button
    Then I should see my newly created venue details
    Then I click on Sang Trang Sửa button
    Then I edit this venue
    And I click on "Submit" button
    Then I should see my venue is updated

  Scenario: Super Admin CMS coupons page
    Given There is some coupons in the system
    Given I log in as super admin
    When I go to cms coupons index page
    Then I should see list of coupons
    Then I click on create new coupons
    And I fill in the coupon form
    And I click on "Submit" button
    Then I should see my newly created coupon details
    Then I click on Sang Trang Sửa button
    Then I edit this coupon
    And I click on "Submit" button
    Then I should see my coupon is updated

  Scenario: Super Admin CMS users page
    Given There is some user in the system
    Given I log in as super admin
    When I go to users index page
    Then I should see list of users
    When I click to show a user
    Then I should see this user details information

  Scenario: Super Admin CMS Adverting Events Page 
    Given There is some advertising events in the system
    Given I log in as super admin
    When I go to advertising events index page
    Then I should see list of advertising events
    Then I click on create new advertising event
    And I fill in advertising event form
    And I submit
    Then I should see my newly created advertising event details
    When I edit this advertising event
    And I submit
    Then I should see my event is updated
