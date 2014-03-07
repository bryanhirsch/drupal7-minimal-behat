# features/login.feature
Feature: login
  In order to log into my Drupal site
  As a site administrator
  I need to be able to authenticate using my username and password

Scenario: Authenticate via user block on home page
  Given I am on the homepage
  When I enter "admin" for "name"
  And I enter "admin" for "pass"
  And I press the "Log in" button
  Then I should see the heading "Navigation"
  And I should see the heading "Management"
