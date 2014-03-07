Getting set up
---------------

1. @TODO Install behat

1. @TODO Set up behat.yml


Writing a behat test for Drupal, step-by-step
---------------------------------------------

1. All the tests for the particular feature you're testing live in
   test/features/my-feature.feature. In this example, we're going to test the login
   feature provided by Drupal core's User module.

        cd /path/to/my-site-repo/test/features
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

1. Each feature is tested by one or more "scenarios". Each scenario follows the
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

1. Implement "step definitions" (PHP functions) to enable Behat to run the test
   scenario(s) you invented. The easiest way to figure out what step definitions
   you need to write and what they should be named is to run Behat as if you
   were ready to run your tests. Behat will detect which scenarios are missing
   step definitions and tell you what to do.

        cd /path/to/my-site-repo
        ./behat

   Behat stubs out PHP functions for you and gives you instructions like this:

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
 
   Happily, we are not starting from scratch. The drupal extension included in
   our composer.json pulled in a bunch of Drupal step definitions created to
   test the D6->D7 upgrade for drupal.org. Rather than write our own step
   definitions, we can reuse existing ones.



Helpful commands
-----------------
# See available behat "step definitions"
./vendor/bin/behat ./behat.local.yml -dl

# symlink for convenience
ln -s ./vendor/bin/behat behat

# run behat (using default behat.yml)
behat

# run behat (using your own config)
behat -c behat.my-config.yml


Behat documentation
--------------------
 - [Docs](http://docs.behat.org/quick_intro.html)
 - [Quick Intro](http://docs.behat.org/quick_intro.html)

