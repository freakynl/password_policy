@api
Feature: enforce the required number of lowercase letters on public share links

  As an administrator
  I want public share link passwords to always contain a required number of lowercase letters
  So that users cannot set passwords that are too easy to guess

  Background:
    Given the administrator has enabled the lowercase letters password policy
    And the administrator has set the lowercase letters required to "3"
    And these users have been created:
      | username | password   |
      | user1    | abcABC1234 |
    And user "user1" has created a public link share with settings
      | path     | welcome.txt |
      | password | ABCabc1234  |

  Scenario Outline: user updates the public share link password to a string with enough lowercase letters
    When user "user1" updates the last share using the sharing API with
      | password | <password> |
    Then the OCS status code should be "100"
    And the HTTP status code should be "200"
    And the last public shared file should be able to be downloaded with password "<password>"
    And the last public shared file should not be able to be downloaded with password "ABCabc1234"
    Examples:
      | password                  |
      | 3LCase                    |
      | moreThan3LowercaseLetters |

  Scenario Outline: user tries to update the public share link password to a string with not enough lowercase letters
    When user "user1" tries to update the last share using the sharing API with
      | password | <password> |
    Then the OCS status message should be "The password contains too few lowercase letters. At least 3 lowercase letters are required."
    And the OCS status code should be "400"
    And the last public shared file should be able to be downloaded with password "ABCabc1234"
    And the last public shared file should not be able to be downloaded with password "<password>"
    Examples:
      | password   |
      | 0LOWERCASE |
      | 2lOWERcASE |
