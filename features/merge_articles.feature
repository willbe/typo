Feature: Write Articles
  As a blog administrator
  In order to organize my articles
  I want to be able to merge two existing articles in my blog

Background: 
    Given the blog is set up

    And the following users exist:
      | login  | password   | email          | profile_id | name   | state  |
      | usera  | password   | usera@test.com | 2          | user a | active |
      | userb  | password   | userb@test.com | 3          | user b | active |

    And the following articles exist:
      | title               | body                | author |
      | Great article one   | Article one body    | usera  |
      | Great article two   | Article two body    | userb  |
      | Great article three | Article three body  | userb  |

    And the following comments exist:
      | article_title       | body           | author |
      | Great article one   | First Comment  | usera  |
      | Great article two   | Second Comment | userb  |
      | Great article three | Third Comment  | userb  |

  Scenario: an Admin can merge articles
    Given I am logged into the admin panel
    And I edit the article titled "Great article one"
    Then I should see the field "merge_with"

  Scenario: a non-Admin can not merge articles
    Given I am logged in as "usera"
    And I edit the article titled "Great article one"
    Then I should not see the field "merge_with"

  Scenario: a merged article should contain the text of both previous articles
    Given I am logged into the admin panel
    And I edit the article titled "Great article two"
    And I merge the current article with the article titled "Great article three"
    Then I should see the text "Article two body"
    And I should see the text "Article three body"
    And I should see the text "First Comment"
    And I should see the text "Third Comment"
