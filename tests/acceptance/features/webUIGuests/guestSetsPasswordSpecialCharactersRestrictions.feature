@webUI @insulated @disablePreviews @mailhog
Feature: enforce the restricted special characters in a password when a guest user sets its own password

  Background:
    Given user "user0" has been created with default attributes and skeleton files
    And the administrator has enabled the special characters password policy
    And the administrator has set the special characters required to "3"
    And the administrator has enabled the restrict to these special characters password policy
    And the administrator has set the restricted special characters required to "$%^&*"
    And the administrator has created guest user "guest" with email "guest@example.com"
    And user "user0" has shared folder "/simple-folder" with user "guest@example.com"

  Scenario Outline: A guest user sets own password to a string with enough restricted special characters
    When guest user "guest" registers and sets password to "<password>" using the webUI
    And user "guest@example.com" logs in using the webUI
    Then the user should be redirected to a webUI page with the title "Files - %productname%"
    And folder "simple-folder" should be listed on the webUI
    Examples:
      | password              |
      | 3$Special%Characters^ |
      | 1*2&3^4%5$6           |

  Scenario Outline: A guest user sets own password to a string that has too few restricted special characters
    When guest user "guest" registers and sets password to "<password>" using the webUI
    Then the user should be redirected to a webUI page with the title "%productname%"
    And a warning should be displayed on the set-password-page saying "The password contains too few special characters. At least 3 special characters ($%^&*) are required."
    Examples:
      | password                 |
      | NoSpecialCharacters123   |
      | Only2$Special&Characters |

  Scenario Outline: A guest user sets own password to a string that has invalid special characters
    When guest user "guest" registers and sets password to "<password>" using the webUI
    Then the user should be redirected to a webUI page with the title "%productname%"
    And a warning should be displayed on the set-password-page saying "The password contains invalid special characters. Only $%^&* are allowed."
    Examples:
      | password                                 |
      | Only#Invalid!Special@Characters          |
      | 1*2&3^4%5$6andInvalidSpecialCharacters#! |