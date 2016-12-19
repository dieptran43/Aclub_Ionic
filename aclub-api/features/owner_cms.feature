Feature: Owner CMS
  As an restaurant owner
  In Order to manage my restaurant
  I have to use cms system

  Scenario: Super Admin CMS Page
    Given I log in as an owner
    When I go to super admin cms venues index page
    Then I should be redirect to home page