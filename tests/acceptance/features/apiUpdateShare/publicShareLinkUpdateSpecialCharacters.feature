@api
Feature: enforce the required number of special characters in a password on public share links

  As an administrator
  I want public share link passwords to always contain a required number of special characters
  So that users cannot set passwords that are too easy to guess

  Background:
    Given the administrator has enabled the special characters password policy
    And the administrator has set the special characters required to "3"
    And these users have been created with default attributes and skeleton files:
      | username | password   |
      | user1    | a!b@c#1234 |
    And user "user1" has uploaded file with content "user1 file" to "/randomfile.txt"
    And user "user1" has created a public link share with settings
      | path     | randomfile.txt |
      | password | g@b#c!1234     |

  @skipOnOcV10.2
  Scenario Outline: user updates the public share link password to a string with enough special characters
    When user "user1" updates the last share using the sharing API with
      | password | <password> |
    Then the OCS status code should be "100"
    And the HTTP status code should be "200"
    And the public should be able to download the last publicly shared file using the old public WebDAV API with password "<password>" and the content should be "user1 file"
    And the public should be able to download the last publicly shared file using the new public WebDAV API with password "<password>" and the content should be "user1 file"
    And the public download of the last publicly shared file using the old public WebDAV API with password "g@b#c!1234" should fail with HTTP status code "401"
    And the public download of the last publicly shared file using the new public WebDAV API with password "g@b#c!1234" should fail with HTTP status code "401"
    Examples:
      | password              |
      | 3#Special$Characters! |
      | 1!2@3#4$5%6^7&8*      |

  @skipOnOcV10.3
  # This scenario repeats the one above, but without checking the new public WebDAV API.
  # It works against core 10.2.1. Delete the scenario when testing against 10.2.1 is no longer required.
  Scenario Outline: user updates the public share link password to a string with enough special characters
    When user "user1" updates the last share using the sharing API with
      | password | <password> |
    Then the OCS status code should be "100"
    And the HTTP status code should be "200"
    And the public should be able to download the last publicly shared file using the old public WebDAV API with password "<password>" and the content should be "user1 file"
    And the public download of the last publicly shared file using the old public WebDAV API with password "g@b#c!1234" should fail with HTTP status code "401"
    Examples:
      | password              |
      | 3#Special$Characters! |
      | 1!2@3#4$5%6^7&8*      |

  @skipOnOcV10.2
  Scenario Outline: user tries to update the public share link password to a string that has too few special characters
    When user "user1" tries to update the last share using the sharing API with
      | password | <password> |
    Then the OCS status message should be "The password contains too few special characters. At least 3 special characters are required."
    And the OCS status code should be "400"
    And the public should be able to download the last publicly shared file using the old public WebDAV API with password "g@b#c!1234" and the content should be "user1 file"
    And the public should be able to download the last publicly shared file using the new public WebDAV API with password "g@b#c!1234" and the content should be "user1 file"
    And the public download of the last publicly shared file using the old public WebDAV API with password "<password>" should fail with HTTP status code "401"
    And the public download of the last publicly shared file using the new public WebDAV API with password "<password>" should fail with HTTP status code "401"
    Examples:
      | password                 |
      | NoSpecialCharacters123   |
      | Only2$Special!Characters |

  @skipOnOcV10.3
  # This scenario repeats the one above, but without checking the new public WebDAV API.
  # It works against core 10.2.1. Delete the scenario when testing against 10.2.1 is no longer required.
  Scenario Outline: user tries to update the public share link password to a string that has too few special characters
    When user "user1" tries to update the last share using the sharing API with
      | password | <password> |
    Then the OCS status message should be "The password contains too few special characters. At least 3 special characters are required."
    And the OCS status code should be "400"
    And the public should be able to download the last publicly shared file using the old public WebDAV API with password "g@b#c!1234" and the content should be "user1 file"
    And the public download of the last publicly shared file using the old public WebDAV API with password "<password>" should fail with HTTP status code "401"
    Examples:
      | password                 |
      | NoSpecialCharacters123   |
      | Only2$Special!Characters |
