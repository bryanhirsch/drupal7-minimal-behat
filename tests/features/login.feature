# features/login.feature
Feature: login
  In order to log into my Drupal site
  As a site administrator
  I need to be able to authenticate using my username and password

Scenario: Authenticate via user block on home page
  Given I'm on the home page
  When I enter my username
  And I enter my password
  Then I successfully authenticate 

