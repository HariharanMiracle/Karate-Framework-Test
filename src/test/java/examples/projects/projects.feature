Feature: Karate test script for application service

  Background:
    * url 'http://localhost:8082/applications/api/v1/'

  # Get request test - project entity
  Scenario: get all projects and then get the first project by projectId, organizationId, projectTitle, description
    Given path 'projects'
    When method get
    Then status 200

    * def res = response

    Given path 'projects'
    And param projectId = res.data.project[1].projectId
    And param organizationId = res.data.project[1].organizationId
    And param projectTitle = res.data.project[1].projectTitle
    And param description = res.data.project[1].description
    When method get
    Then status 200

  # Post request test - project entity
  Scenario: create a project and then get it by projectId, organizationId, projectTitle, description
    * def project =
      """
        {
          "projectTitle": "test project3",
          "description": "test description3"
        }
        """

    Given url 'http://localhost:8082/applications/api/v1'
    Given path 'projects'
    And param organization-id = 'b55bc057-4767-476b-e667-19f7f2076105'
    And request project
    When method post
    Then status 201

    * def id = response.data.project.projectId
    * print 'created id is: ', id

    Given path 'projects'
    And param projectId = id
    And param organization-id = 'b55bc057-4767-476b-e667-19f7f2076105'
    And param projectTitle = 'test project3'
    And param description = 'test description3'
    When method get
    Then status 200

  # Put request test - project entity
  Scenario: update a project and then get it by projectId, organizationId, projectTitle, description
    # automated the process of inputting the organization and project id
    Given url 'http://localhost:8082/applications/api/v1'
    Given path 'projects'
    When method get
    Then status 200

    * def res = response

    * def project =
      """
        {
          "projectTitle": "change test project2",
          "description": "change test description2"
        }
        """

    Given path 'projects'
    And param organization-id = res.data.project[1].organizationId
    And param project-id = res.data.project[1].projectId
    And request project
    When method put
    Then status 200

    * def projectId = response.data.project.projectId
    * def organizationId = response.data.project.organizationId
    * print 'updated projectId is: ', projectId
    * print 'updated organizationId is: ', organizationId

    Given path 'projects'
    And param projectId = projectId
    And param organization-id = organizationId
    And param projectTitle = 'change test project1'
    And param description = 'change test description1'
    When method get
    Then status 200

  # Delete request test - project entity
  Scenario: delete a project by getting the first project in the list
    Given url 'http://localhost:8082/applications/api/v1'
    Given path 'projects'
    When method get
    Then status 200

    Given path 'projects'
    And param organization-id = response.data.project[1].organizationId
    And param project-id = response.data.project[1].projectId
    When method delete
    Then status 200

  # Post request test - application entity
  Scenario: create an application entity by getting the first project in the list
    # Automated the process of inputting the organization and project id
    Given url 'http://localhost:8082/applications/api/v1'
    Given path 'projects'
    When method get
    Then status 200

    * def application =
      """
        {
           "createdUserId":"f6f39cbf-53b8-45e6-82ab-eeec182fdcda",
           "createdUserEmail":"isharakumbalathara@randoli.ca",
           "status":"DRAFT",
           "name":"Test001 Service",
           "description":"Manage integrations like gitlab and slack",
           "tags": [],
           "notificationEmail":"ishara.kumbalathara@gmail.com",
           "slackChannel":"customer_slack",
           "definition": [
              {
                 "envName": "dev",
                 "resources": {
                    "deployment": {
                       "replicas": 2,
                       "cpu": "100m",
                       "memory": "100Mi",
                       "labels":[
                          { "app": "integration_service" },
                          { "appId": "fbd91299-017d-49f2-9c54-1c44b75c899c" },
                          { "label 1": "value1" },
                          { "label 2": "value2" }
                       ]
                    },
                    "networkPolicy": {
                       "hostName": "test host",
                       "path": "path",
                       "appPort": 9882,
                       "outsidePort": 2450,
                       "tls": "Edge",
                       "labels": [
                          { "app": "integration_service" },
                          { "appId": "fbd91299-017d-49f2-9c54-1c44b75c899c" }
                       ]
                    },
                    "configuration": {
                       "labels": [
                          { "app": "integration_service" },
                          { "appId": "fbd91299-017d-49f2-9c54-1c44b75c899c" }
                       ],
                       "data": [
                          { "key 1": "value 1" },
                          { "key 2": "value 2" }
                       ]
                    },
                    "secrets": {
                       "labels": [
                          { "app": "integration_service" },
                          { "appId": "fbd91299-017d-49f2-9c54-1c44b75c899c" }
                       ],
                       "data": [
                          { "secret 1": "secret value 1" },
                          { "secret 2": "secret value 2" }
                       ]
                    }
                 },
                 "pipeline": {
                    "notificationEmail":"ishara.kumbalathara@gmail.com",
                    "slackChannel":"customer_slack",
                    "deploymentStrategy": "BUILD_FROM_SOURCE",
                    "appType": "JAVA_11_WAR",
                    "steps": [
                       {
                          "id": "TASK_SCAN_SOURCE",
                          "inputs": {
                             "repoUrl": "https://gitlab.com/randoli/eng/services/app-director/application-service",
                             "repoRevision": "MASTER",
                             "credentialId": "28f5e864-7787-4caf-8116-080c15856969"
                          }
                       },
                       {
                          "id": "TASK_BUILD_JAVA_11_WAR",
                          "inputs": {
                             "repoUrl": "https://gitlab.com/randoli/eng/services/app-director/application-service",
                             "repoRevision": "MASTER",
                             "credentialId": "28f5e864-7787-4caf-8116-080c15856969"
                          }
                       },
                       {
                          "id": "TASK_BUILD_IMAGE",
                          "inputs": {
                             "imageRegistry": "https://quay.io",
                             "imageName": "application-service",
                             "tag": "latest",
                             "credentialId": "e45575a8-448a-4554-a534-5a4ccae78b0d"
                          }
                       },
                       {
                          "id": "TASK_SCAN_IMAGE",
                          "inputs": {
                             "imageRegistry": "https://quay.io",
                             "imageName": "application-service",
                             "tag": "latest",
                             "credentialId": "e45575a8-448a-4554-a534-5a4ccae78b0d"
                          }
                       }
                    ],
                    "endSteps": [
                       {
                          "id": "TASK_NOTIFIY_EMAIL",
                          "inputs": {
                             "notificationEmail": "ishara.kumbalathara@gmail.com"
                          }
                       },
                       {
                          "id": "TASK_NOTIFIY_SLACK",
                          "inputs": {
                             "slackChannel": "customer_slack"
                          }
                       },
                       {
                          "id": "TASK_TRIGGER_CLEAN_UP"
                       }
                    ]
                 }
              },
              {
                 "envName": "test",
                 "resources": {},
                 "pipeline": {}
              }
           ]
        }
        """

    Given url 'http://localhost:8082/applications/api/v1'
    Given path 'projects/applications'
    And param organization-id = response.data.project[1].organizationId
    And param project-id = response.data.project[1].projectId
    And request application
    When method post
    Then status 201

    * def id = response.data.application.appId
    * print 'created id is: ', id