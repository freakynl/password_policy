@api
Feature: Guests

  Background:
    Given user "user0" has been created with default attributes
    And the administrator has enabled the lowercase letters password policy
    And the administrator has set the lowercase letters required to "3"

  @mailhog
  Scenario Outline: A guest user sets own password to a string that has enough lowercase letters
    Given using OCS API version "<ocs-api-version>"
    And the administrator has created guest user "guest" with email "guest@example.com"
    And user "user0" has shared file "/textfile1.txt" with user "guest@example.com"
    When guest user "guest" registers and sets password to "<password>"
    Then the HTTP status code should be "200"
    And user "guest" should be a guest user
    And user "guest@example.com" should see the following elements
      | /textfile1.txt |
    Examples:
      | password                  | ocs-api-version |
      | 3LCase                    | 1               |
      | 3LCase                    | 2               |
      | moreThan3LowercaseLetters | 1               |
      | moreThan3LowercaseLetters | 2               |

  @mailhog
  Scenario Outline: A guest user sets own password to a string that does not have enough lowercase letters
    Given using OCS API version "<ocs-api-version>"
    And the administrator has created guest user "guest" with email "guest@example.com"
    And user "user0" has shared file "/textfile1.txt" with user "guest@example.com"
    When guest user "guest" registers and sets password to "<password>"
    Then the HTTP status code should be "200"
    And user "guest@example.com" should not see the following elements
      | /textfile1.txt |
    Examples:
      | password   | ocs-api-version |
      | 0LOWERCASE | 1               |
      | 0LOWERCASE | 2               |
      | 2lOWERcASE | 1               |
      | 2lOWERcASE | 2               |

  @mailhog
  Scenario Outline: A guest user changes own password to a string that has enough lowercase letters
    Given using OCS API version "<ocs-api-version>"
    And the administrator has created guest user "guest" with email "guest@example.com"
    And user "user0" has shared file "/textfile1.txt" with user "guest@example.com"
    Given guest user "guest" has registered and set password to "enoughLowerCase"
    When user "guest@example.com" resets the password of user "guest@example.com" to "<password>" using the provisioning API
    Then user "guest" should be a guest user
    And user "guest@example.com" should see the following elements
      | /textfile1.txt |
    Examples:
      | password                  | ocs-api-version |
      | 3LCase                    | 1               |
      | 3LCase                    | 2               |
      | moreThan3LowercaseLetters | 1               |
      | moreThan3LowercaseLetters | 2               |

  @mailhog
  Scenario Outline: A guest user changes own password to a string that does not have enough lowercase letters
    Given using OCS API version "<ocs-api-version>"
    And the administrator has created guest user "guest" with email "guest@example.com"
    And user "user0" has shared file "/textfile1.txt" with user "guest@example.com"
    Given guest user "guest" has registered and set password to "enoughLowerCase"
    When user "guest@example.com" resets the password of user "guest@example.com" to "<password>" using the provisioning API
    Then the HTTP status code should be "<http-status>"
    And the HTTP reason phrase should be "<http-reason-phrase>"
    And the OCS status code should be "<ocs-status>"
    And the OCS status message should be:
      """
      The password contains too few lowercase letters. At least 3 lowercase letters are required.
      """
    And user "guest@example.com" should not see the following elements
      | /textfile1.txt |
    Examples:
      | password   | ocs-api-version | ocs-status | http-status | http-reason-phrase |
      | 0LOWERCASE | 1               | 403        | 200         | OK                 |
      | 0LOWERCASE | 2               | 403        | 403         | Forbidden          |
      | 2lOWERcASE | 1               | 403        | 200         | OK                 |
      | 2lOWERcASE | 2               | 403        | 403         | Forbidden          |

  @mailhog
  Scenario Outline: A guest user creates a public link share with a password that has enough lowercase letters
    Given using OCS API version "<ocs-api-version>"
    And the administrator has created guest user "guest" with email "guest@example.com"
    And user "user0" has shared file "/textfile1.txt" with user "guest@example.com"
    Given guest user "guest" has registered and set password to "enoughLowerCase"
    When user "guest@example.com" creates a public link share using the sharing API with settings
      | path     | textfile1.txt |
      | password | <password>    |
    Then the OCS status code should be "<ocs-status>"
    And the HTTP status code should be "200"
    And the last public shared file should be able to be downloaded with password "<password>"
    And the last public shared file should not be able to be downloaded with password "ABCabc1234"
    Examples:
      | password                  | ocs-api-version | ocs-status |
      | 3LCase                    | 1               | 100        |
      | 3LCase                    | 2               | 200        |
      | moreThan3LowercaseLetters | 1               | 100        |
      | moreThan3LowercaseLetters | 2               | 200        |

  @mailhog
  Scenario Outline: A guest user creates a public link share with a password that does not have enough lowercase letters
    Given using OCS API version "<ocs-api-version>"
    And the administrator has created guest user "guest" with email "guest@example.com"
    And user "user0" has shared file "/textfile1.txt" with user "guest@example.com"
    Given guest user "guest" has registered and set password to "enoughLowerCase"
    When user "guest@example.com" creates a public link share using the sharing API with settings
      | path     | textfile1.txt |
      | password | <password>    |
    Then the HTTP status code should be "<http-status>"
    And the HTTP reason phrase should be "<http-reason-phrase>"
    And the OCS status code should be "<ocs-status>"
    And the OCS status message should be:
      """
      The password contains too few lowercase letters. At least 3 lowercase letters are required.
      """
    And the last public shared file should not be able to be downloaded with password "<password>"
    Examples:
       | password   | ocs-api-version | ocs-status | http-status | http-reason-phrase |
       | 0LOWERCASE | 1               | 403        | 200         | OK                 |
       | 0LOWERCASE | 2               | 403        | 403         | Forbidden          |
       | 2lOWERcASE | 1               | 403        | 200         | OK                 |
       | 2lOWERcASE | 2               | 403        | 403         | Forbidden          |
