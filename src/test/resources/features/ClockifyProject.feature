@Projects
Feature: Projects in Clockify

  Background:
    Given base url https://api.clockify.me/api
    And header Content-Type = application/json
    And header Accept = */*

  @AddNewProject
  Scenario: Add a new project.
    And endpoint /v1/workspaces/680ab99aaf0c792d89b73fa7/projects
    And header x-api-key = NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz
    And body jsons/bodies/bodyAddProject.json
    When execute method POST
    Then the status code should be 201
    And response should be name = Proyecto BAT
    And validate schema jsons/schemas/addProject.json
    * define projectId = $.id

  @FindProjectById
  Scenario: Find project by ID.
    And header x-api-key = NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz
    And endpoint /v1/workspaces/680ab99aaf0c792d89b73fa7/projects/681949a23e62a459a1c6ea96
    When execute method GET
    Then the status code should be 200
    And response should be name = reportes de errores
    * print response

  @UpdateProject
  Scenario: Update project on workspace
    Given call ClockifyProject.feature@AddNewProject
    And header x-api-key = NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz
    And endpoint /v1/workspaces/680ab99aaf0c792d89b73fa7/projects/{{projectId}}
    And body jsons/bodies/bodyUpdateProject.json
    When execute method PUT
    Then the status code should be 200
    And response should be name = Proyecto archivado

  @DeleteProject
  Scenario: Delete project from workspace
    Given call ClockifyProject.feature@UpdateProject
    And header x-api-key = NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz
    And endpoint /v1/workspaces/680ab99aaf0c792d89b73fa7/projects/{{projectId}}
    When execute method DELETE
    Then the status code should be 200

  @FailAddNewProject
  Scenario Outline: Fail Add new project for <reason>
    And endpoint /v1/workspaces/<workspaceId>/projects
    And header x-api-key = <api-key>
    And generate test body <bodyRequest>
    And body {{testBody}}
    When execute method POST
    Then the status code should be <status-code>
    And response should be message = <message>

    Examples:
      | reason                                          | workspaceId              | api-key                                          | bodyRequest                                | status-code | message                                                                                                                                                                                                                                                                           |
      | empty workspaceId                               |                          | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | without changes                            | 405         | Request method 'POST' is not supported                                                                                                                                                                                                                                            |
      | null workspaceId                                | null                     | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | without changes                            | 403         | Access Denied                                                                                                                                                                                                                                                                     |
      | incomplete workspaceId                          | 680ab99aaf0c792d89b73    | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | without changes                            | 403         | Access Denied                                                                                                                                                                                                                                                                     |
#      en este caso uso un workspaceId existente, y una api-key existente pero de un usuario que no tiene permisos
      | api-key without permissions                     | 680ab99aaf0c792d89b73fa7 | MGE5ZTA2NzgtOGYzMi00ZjQzLWE2ZTEtNjBhOGYyYjhiMTJm | without changes                            | 403         | Access Denied                                                                                                                                                                                                                                                                     |
      | no body in request                              | 680ab99aaf0c792d89b73fa7 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | no body in request                         | 400         | Required request body is missing: public com.clockify.adapter.http.v1.dto.ProjectDtoImplV1 com.clockify.adapter.http.v1.project.ProjectHttpAdapter.create(java.lang.String,com.clockify.adapter.http.v1.requests.ProjectRequest,com.clockify.adapter.spring.security.CurrentAuth) |
      | no project name in body request                 | 680ab99aaf0c792d89b73fa7 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | no project name in request                 | 400         | Se requiere el nombre del proyecto                                                                                                                                                                                                                                                |
      | null project name                               | 680ab99aaf0c792d89b73fa7 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | null project name                          | 400         | Se requiere el nombre del proyecto                                                                                                                                                                                                                                                |
      | project name with with less than two characters | 680ab99aaf0c792d89b73fa7 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | project name with less than two characters | 400         | El nombre del proyecto debe tener entre 2 y 250 caracteres                                                                                                                                                                                                                        |
      | project name with more than 250 characters      | 680ab99aaf0c792d89b73fa7 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | project name with more than 250 characters | 400         | El nombre del proyecto debe tener entre 2 y 250 caracteres                                                                                                                                                                                                                        |
      | empty api-key                                   | 680ab99aaf0c792d89b73fa7 | ""                                               | without changes                            | 401         | Api key does not exist                                                                                                                                                                                                                                                            |
      | null api-key                                    | 680ab99aaf0c792d89b73fa7 | null                                             | without changes                            | 401         | Api key does not exist                                                                                                                                                                                                                                                            |
      | non-existent api-key                            | 680ab99aaf0c792d89b73fa7 | 515156sgsafaiu9esf84s48ddsg                      | without changes                            | 401         | Api key does not exist                                                                                                                                                                                                                                                            |


  @FailFindProjectById
  Scenario Outline: Fail Find project by ID for <reason>.
    * define empty = ""
    And header x-api-key = <api-key>
    And endpoint /v1/workspaces/<workspaceId>/projects/<projectId>
    When execute method GET
    Then the status code should be <status-code>
    And response should be message = <message>

    Examples:
      | reason                      | workspaceId              | api-key                                          | projectId                | status-code | message                                                             |
      | empty workspaceId           |                          | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 681949a23e62a459a1c6ea96 | 404         | No static resource v1/workspaces/projects/681949a23e62a459a1c6ea96. |
      | null workspaceId            | null                     | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 681949a23e62a459a1c6ea96 | 403         | Access Denied                                                       |
      | incomplete workspaceId      | 680ab99aaf0c792d89b73    | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 681949a23e62a459a1c6ea96 | 403         | Access Denied                                                       |
      | api-key without permissions | 680ab99aaf0c792d89b73fa7 | MGE5ZTA2NzgtOGYzMi00ZjQzLWE2ZTEtNjBhOGYyYjhiMTJm | 681949a23e62a459a1c6ea96 | 403         | Access Denied                                                       |
      | empty api-key               | 680ab99aaf0c792d89b73fa7 | $(empty)                                               | 681949a23e62a459a1c6ea96 | 401         | Api key does not exist                                              |
      | null api-key                | 680ab99aaf0c792d89b73fa7 | null                                             | 681949a23e62a459a1c6ea96 | 401         | Api key does not exist                                              |
      | non-existent api-key        | 680ab99aaf0c792d89b73fa7 | 515156sgsafaiu9esf84s48ddsg                      | 681949a23e62a459a1c6ea96 | 401         | Api key does not exist                                              |
      | empty projectId             | 680ab99aaf0c792d89b73fa7 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz |  $(empty)                      | 400         | Proyecto no pertenece a Espacio de trabajo                          |
      | null projectId              | 680ab99aaf0c792d89b73fa7 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | null                     | 400         | Proyecto no pertenece a Espacio de trabajo                          |
      | non-existent projectId      | 680ab99aaf0c792d89b73fa7 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 681949a23e62a459a1fr5e   | 400         | Proyecto no pertenece a Espacio de trabajo                          |

  @FailUpdateProject
  Scenario Outline: Fail Update project on workspace for <reason>
    Given call ClockifyProject.feature@AddNewProject
    And endpoint /v1/workspaces/<workspaceId>/projects/<projectId>
    And header x-api-key = <api-key>
    * define body = jsons/bodies/bodyAddProject.json
    And set value <name> of key name in body $(body)
    And body body
    When execute method POST
    Then the status code should be <status-code>
    And response should be message = <message>
    Examples:
      | reason                      | workspaceId              | projectId              | api-key                                          | name  | body                     | status-code | message                                    |
      | empty workspaceId           |                          | {{projectId}}          | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | totot | 681949a23e62a459a1c6ea96 | 404         | Access Denied                              |
      | null workspaceId            | null                     | {{projectId}}          | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz |       | 681949a23e62a459a1c6ea96 | 403         | Access Denied                              |
      | incomplete workspaceId      | 680ab99aaf0c792d89b73    | {{projectId}}          | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz |       | 681949a23e62a459a1c6ea96 | 403         | Access Denied                              |
      | api-key without permissions | 680ab99aaf0c792d89b73fa7 | {{projectId}}          | MGE5ZTA2NzgtOGYzMi00ZjQzLWE2ZTEtNjBhOGYyYjhiMTJm |       | 681949a23e62a459a1c6ea96 | 403         | Access Denied                              |
      | empty api-key               | 680ab99aaf0c792d89b73fa7 | {{projectId}}          |                                                  |       | 681949a23e62a459a1c6ea96 | 401         | Api key does not exist                     |
      | null api-key                | 680ab99aaf0c792d89b73fa7 | {{projectId}}          | null                                             |       | 681949a23e62a459a1c6ea96 | 401         | Api key does not exist                     |
      | non-existent api-key        | 680ab99aaf0c792d89b73fa7 | {{projectId}}          | 515156sgsafaiu9esf84s48ddsg                      |       | 681949a23e62a459a1c6ea96 | 401         | Api key does not exist                     |
      | empty projectId             | 680ab99aaf0c792d89b73fa7 | {}                     | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz |       | {}                       | 400         | Proyecto no pertenece a Espacio de trabajo |
      | null projectId              | 680ab99aaf0c792d89b73fa7 | null                   | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz |       | null                     | 400         | Proyecto no pertenece a Espacio de trabajo |
      | non-existent projectId      | 680ab99aaf0c792d89b73fa7 | 681949a23e62a459a1fr5e | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz |       | 681949a23e62a459a1fr5e   | 400         | Proyecto no pertenece a Espacio de trabajo |

  
