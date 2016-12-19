Feature: Manage Owner
  As an super admin
  In Order to manage all owners in the system
  I want to be able to list, view, edit and create restaurant owner

  Scenario: Super Admin Manage Owner
    Given There is some owners in the system
    Given I log in as super admin
    When I go to cms restaurant owners index page
    Then I should see list of restaurant owners
    Then I click on create new restaurant owners
    And I fill in the restaurant owners form
    And I click on "Submit" button
    Then I should see my newly created coupon details
    Then I click on Sang Trang Sửa button
    Then I edit this restaurant owners
    And I click on "Submit" button
    Then I should see my coupon is updated
