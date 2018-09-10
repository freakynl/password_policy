@api
Feature: enforce the minimum length of a password when changing a user password

  As an administrator
  I want user passwords to always be a certain minimum length
  So that users cannot set passwords that are too short (easy to crack)

  Background:
    Given the administrator has enabled the minimum characters password policy
    And the administrator has set the minimum characters required to "10"
    And these users have been created:
      | username | password   | displayname | email        |
      | user1    | 1234567890 | User One    | u1@oc.com.np |

  Scenario Outline: admin changes a user password to one that is long enough
    Given using OCS API version "<ocs-api-version>"
    When user "admin" sends HTTP method "PUT" to OCS API endpoint "/cloud/users/user1" with body
      | key   | password   |
      | value | <password> |
    Then the OCS status code should be "<ocs-status>"
    And the HTTP status code should be "200"
    Examples:
      | password             | ocs-api-version | ocs-status |
      | 10tenchars           | 1               | 100        |
      | 10tenchars           | 2               | 200        |
      | morethan10characters | 1               | 100        |
      | morethan10characters | 2               | 200        |

  Scenario Outline: admin changes a user password to one that is not long enough
    Given using OCS API version "<ocs-api-version>"
    When user "admin" sends HTTP method "PUT" to OCS API endpoint "/cloud/users/user1" with body
      | key   | password   |
      | value | <password> |
    Then the OCS status code should be "<ocs-status>"
    And the HTTP status code should be "<http-status>"
    Examples:
      | password  | ocs-api-version | ocs-status | http-status |
      | A         | 1               | 403        | 200         |
      | A         | 2               | 403        | 403         |
      | 123456789 | 1               | 403        | 200         |
      | 123456789 | 2               | 403        | 403         |