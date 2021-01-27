Feature: Karate test script for project service

  Background:
    * url 'http://localhost:8082/applications/api/v1/'

  # Get request test - application entity
  Scenario: get all applications and then get the first application by appId
    Given path 'applications'
    When method get
    Then status 200

    * def res = response

    Given path 'applications'
    And param appId = res.data.application[1].appId
    When method get
    Then status 200

  # Put request test - application entity
  Scenario: update an application
    # Automated the process of inputting the app, organization and project Id
    Given path 'applications'
    When method get
    Then status 200

    * def application =
        """
        {
            "definition": {
                  "comment": "comment to update",
                  "projectId": "eaf83580-c85f-4bc3-a595-1970217e88d1"
                },
            "status": "DRAFT"
        }
        """

    Given url 'http://localhost:8082/applications/api/v1'
    Given path 'applications'
    And param organization-id = response.data.application[1].organizationId
    And param project-id = response.data.application[1].projectId
    And param app-id = response.data.application[1].appId
    And request application
    When method put
    Then status 200

    * def appId = response.data.application.appId
    * print 'updated appId is: ', appId

    Given path 'applications'
    And param appId = appId
    When method get
    Then status 200

  # Delete request test - application entity
  Scenario: delete an application by getting the first project in the list
    Given url 'http://localhost:8082/applications/api/v1'
    Given path 'applications'
    When method get
    Then status 200

    Given path 'applications'
    And param organization-id = response.data.application[1].organizationId
    And param project-id = response.data.application[1].projectId
    And param app-id = response.data.application[1].appId
    When method delete
    Then status 204