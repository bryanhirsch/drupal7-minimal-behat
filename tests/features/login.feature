# features/login.feature
Feature: login
  In order to log into my Drupal site
  As a site administrator
  I need to be able to authenticate using my username and password

Scenario: Authenticate via user block on home page
  Given I am on the homepage
  When I enter "admin" for "name"
  And I enter my password
  Then I successfully authenticate 

