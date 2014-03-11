Getting started with Behat: Drupal 7, Minimal install profile
=============================================================

https://travis-ci.org/bryanhirsch/drupal7-minimal-behat.png

Contents
--------
 - [#getting-set-up](#getting-set-up)
 - [#writing-a-behat-test-for-drupal-step-by-step](#writing-a-behat-test-for-drupal-step-by-step)
 - [#helpful-commands](#helpful-commands)
 - [#behat-documentation-and-helpful-links](#behat-documentation-and-helpful-links)
 - [#todo](#todo)

Getting set up
---------------

1. Set up your composer.json file with these contents. (This file should be in
   the top-level directory of your site repo, a sybling to docroot.)

        {
          "name": "drupal7-minimal-behat",
          "description": "Test Drupal 7 minimal install profile with Behat",
          "require": {
            "drupal/drupal-extension": "*",
            "drush/drush": "~6.0"
          }
        }


1. Download composer.phar to the top-level directory of your site repo. (If you
   have composer installed already, you can skip this.)

        curl http://getcomposer.org/installer | php

1. Install via composer (from top-level directory in your repo).

        # Install with composer.phar.
        ./composer.phar install

        # If composer was already installed on your machine you can install like
        # this.
        composer install

1. Symlink executable

        ln -s ./vendor/bin/behat behat

1. Set up behat.yml file using the contents below. Replace
   http://drupal7-minimal-behat.dev:8888 with whatever the URL is for your local
   site install. Note: By default Behat will create a
   directory called "features" and look for your tests there. The YAML config below
   chages this default to "tests/features".

        default:
          paths:
            features: tests/features
          extensions:
            Behat\MinkExtension\Extension:
              goutte: ~
              selenium2: ~
              default_session: goutte
              javascript_session: selenium2
              base_url: http://drupal7-minimal-behat.dev:8888
            Drupal\DrupalExtension\Extension:
              blackbox: ~

1. View available "step definitions" from drupal-extension included in composer.json.

        ./behat -dl

1. Set up behat. This will create your features directory and stub out
   FeatureContext.php (located here: features/bootstrap/FeatureContext.php) for
   you.

        ./behat --init

   Try listing available step definitions again. If they don't work, something
   went wrong with generating FeatureContext.php. Open it up and add/edit the
   following lines.

   Edit this file:

        tests/features/bootstrap/FeatureContext.php 

   Include DrupalContext class (paste this around line 9, below other similar
   looking lines):

        use Drupal\DrupalExtension\Context\DrupalContext;

   FeatureContext should extend DrupalContext (replace the word "BehatContext"
   with "DrupalContext" like the line below):

        class FeatureContext extends DrupalContext

1. Install Drupal 7 using the core "minmal" profile. Set up user 1 with the
   credentials username: admin, password: admin. This is all you need to
   follow along with examples below.


Writing a behat test for Drupal, step-by-step
---------------------------------------------

1. All the tests for the particular feature you're testing live in
   test/features/my-feature.feature. In this example, we're going to test the login
   feature provided by Drupal core's User module.

        cd /path/to/my-site-repo/tests/features
        touch login.feature
        echo "# features/login.feature" >> login.feature

1. Start by describing the feature you want to test. Follow this standard format:

        Feature: [name]
          In order to [verb]            # What does this feature accomplish?
          As a [noun]                   # Who is the user in your user story?
          I need to be able to [_____]  # What specifically needs to happen or work?

   Using our login example:

        echo "Feature: login"                                                     >> login.feature
        echo "  In order to log into my Drupal site"                              >> login.feature
        echo "  As a site administrator"                                          >> login.feature
        echo "  I need to be able to authenticate using my username and password" >> login.feature
        echo ""                                                                   >> login.feature

1. Each feature is examined by one or more test "scenarios". Each scenario follows the
   same basic format: Given, When, Then. Like this:

      Scenario: [Some description of the scenario]
          Given [some context]
           When [some event]
           Then [outcome]
   
   More detailed scenarios can be created with And and But. Like this:

      Scenario: [Some description of the scenario]
          Given [some context]
            And [more context]
           When [some event]
            And [second event occurs]
           Then [outcome]
            And [another outcome]
            But [another outcome]

   Continuing our login example:

        echo "Scenario: Authenticate via user block on home page"               >> login.feature
        echo "  Given I'm on the home page"                                     >> login.feature
        echo "  When I enter my username"                                       >> login.feature
        echo "  And I enter my password"                                        >> login.feature
        echo "  Then I successfully authenticate"                               >> login.feature

1. Now try running this test. If Behat doesn't know what to do during any of the
   steps defined in your test scenario, it will tell you. (Since we just made
   all this up, we do not expect Behat to be able to complete our test. But
   Behat will give us a nice neat list of PHP functions to implement in order to
   make this test fully functional.)

        cd /path/to/my-site-repo
        ./behat

   Behat stubs out PHP functions for each of the steps defined in your
   scenario--called "step definitions"--and gives you instructions like this:

        You can implement step definitions for undefined steps with these snippets:

    ```php
          /**
           * @Given /^I\'m on the home page$/
           */
          public function iMOnTheHomePage() {
            throw new PendingException();
          }

          /**
           * @When /^I enter my username$/
           */
          public function iEnterMyUsername() {
            throw new PendingException();
          }

          /**
           * @Given /^I enter my password$/
           */
          public function iEnterMyPassword() {
            throw new PendingException();
          }

          /**
           * @Then /^I successfully authenticate$/
           */
          public function iSuccessfullyAuthenticate() {
            throw new PendingException();
          }
    ```

   If we were starting from scratch, writing custom test scenarios, the
   next step would be to copy the PHP code above, paste it into
   FeatureContext.php (see path below), and then fill in functions with your
   custom logic. When a step fails, throw an exception. (See examples
   [here](http://docs.behat.org/quick_intro.html#writing-your-step-definitions).)

        test/features/bootstrap/FeatureContext.php
 
   Writing custom tests like ^^ this is pretty simple. But it's even easier to
   reuse existing tests. The drupal extension included in composer.json pulled
   in a bunch of Drupal-specific step definitions we can  use. Rather than start
   by writing our own step definitions, lets see if there's anything there we
   can reuse. (Note also: If/When you DO need to invent custom step definitions,
   check out the README included in the [Behat Drupal
   Extension](https://drupal.org/project/drupalextension) project to see how to
   best leverage and extend all the great work that's already done there for you.)

1. Check existing step definitions. Reuse any applicable before writing our own
   new custom tests. (Note: At a technical level, there is no difference between
   Then, And, But, Given, When used at the start of each the line. Any available
   step definition can begin with any of these keywords.)

   Check existing step definitions like this:

        behat -dl

   Make the following edit to use an existing step definition:

   ```diff
     Scenario: Authenticate via user block on home page
    -  Given I'm on the home page
    +  Given I am on the homepage
       When I enter my username
       And I enter my password
       Then I successfully authenticate 
   ```

   Here are more we can reuse:

   ```diff
     Scenario: Authenticate via user block on home page
       Given I am on the homepage
    -  When I enter my username
    +  When I enter "admin" for "name"
       And I enter my password
       Then I successfully authenticate 
   ```

   ```diff
     Scenario: Authenticate via user block on home page
       Given I am on the homepage
       When I enter "admin" for "name"
    -  And I enter my password
    +  And I enter "admin" for "pass"
       Then I successfully authenticate 
   ```

   There's nothing obvious for "successfully authenticate", but there are some
   visible changes that happen when I log in successfully. Let's use those to test whether
   authentication was successful.

   ```diff
    Scenario: Authenticate via user block on home page
       When I enter "admin" for "name"
       And I enter "admin" for "pass"
       And I press the "Log in" button
    -  Then I successfully authenticate 
    +  Then I should see the heading "Navigation"
    +  And I should see the heading "Management"
   ```

    Try running the your tests again. (It will fail.)

        ./behat

    We're entering info into the fields, but we forgot to press enter. 

   ```diff
    Scenario: Authenticate via user block on home page
      Given I am on the homepage
      When I enter "admin" for "name"
      And I enter "admin" for "pass"
   +  And I press the "Log in" button
      Then I should see the heading "Navigation"
      And I should see the heading "Management"
   ```

    Try running the your tests again. (This time it should pass!)

        ./behat

1. The test above is a good start. It works. And it's a lot better than no test!
   But it's brittle. It relies on a particular username and password and block
   configuration stored in the database. All of these are things site admins
   change frequently. Here are a few ways we could harden our tests (there's no
   single right way, you can probably think of more):

    - use drush to get the username for user 1, then (re)set user 1's password
    - start as an unauthenticated user, then log in, and then go to a path that
      would not be accessible if you were not authenticated (like /admin)


Set up continuous integration with Travis CI
--------------------------------------------



@todo
-----
 - See drupal-extension/README. Add the following examples:
   - [ ] @javascript
   - [ ] include foo.behat.inc in module foo
   - [ ] @api
   - [ ] drush driver
   - [ ] drupal bootstrap
   - [ ] target content in specific regions
   - [ ] alter text strings in available step definitions
 - [ ] automate with Travis CI



Helpful commands
-----------------
See available behat "step definitions"

        ./vendor/bin/behat ./behat.local.yml -dl

symlink for convenience

        ln -s ./vendor/bin/behat behat

run behat (using default behat.yml)

        behat

run behat (using your own config)

        behat -c behat.my-config.yml


Behat documentation and helpful links
--------------------------------------
 - [Docs](http://docs.behat.org/quick_intro.html)
 - [Quick Intro](http://docs.behat.org/quick_intro.html)
 - [Drupal.org BDD](http://drupal.org/project/doobie)
 - [Behat Drupal Extension](https://drupal.org/project/drupalextension)
