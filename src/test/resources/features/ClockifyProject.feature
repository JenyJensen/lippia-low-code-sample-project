@Clockify @Projects
Feature: Projects in Clockify

  Background:
    Given base url $(env.base_url_clockify)
    And header Content-Type = application/json
    And header Accept = */*

  @AddNewProject @Regression
  Scenario: Add a new project.
    And endpoint /v1/workspaces/680ab99aaf0c792d89b73fa7/projects
    And header x-api-key = $(env.base_apikey)
    And a variable name is generated and stored in a variable
    * define body = jsons/bodies/bodyAddProject.json
    And set value $(var.variableProjName) of key name in body $(var.body)
    And body $(var.body)
    When execute method POST
    Then the status code should be 201
    And response should be name = $(var.variableProjName)
    And validate schema jsons/schemas/schemaAddProject.json
    * define projectId = $.id

  @FindProjectById @Regression
  Scenario: Find project by ID.
    And header x-api-key = $(env.base_apikey)
    And endpoint /v1/workspaces/680ab99aaf0c792d89b73fa7/projects/681949a23e62a459a1c6ea96
    When execute method GET
    Then the status code should be 200
    And response should be name = reportes de errores
    * print response

  @UpdateProject @Regression
  Scenario: Update project on workspace
    Given call ClockifyProject.feature@AddNewProject
    And header x-api-key = $(env.base_apikey)
    And endpoint /v1/workspaces/680ab99aaf0c792d89b73fa7/projects/{{projectId}}
    And body jsons/bodies/bodyUpdateProject.json
    When execute method PUT
    Then the status code should be 200

  @DeleteProject @Regression
  Scenario: Delete project from workspace
    Given call ClockifyProject.feature@UpdateProject
    And header x-api-key = $(env.base_apikey)
    And endpoint /v1/workspaces/680ab99aaf0c792d89b73fa7/projects/{{projectId}}
    When execute method DELETE
    Then the status code should be 200

  @FailAddNewProject @Regression
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
      | empty workspaceId                               |                          | $(env.base_apikey)                               | without changes                            | 405         | Request method 'POST' is not supported                                                                                                                                                                                                                                            |
      | incomplete workspaceId                          | 680ab99aaf0c792d89b73    | $(env.base_apikey)                               | without changes                            | 403         | Access Denied                                                                                                                                                                                                                                                                     |
      | api-key without permissions                     | 680ab99aaf0c792d89b73fa7 | MGE5ZTA2NzgtOGYzMi00ZjQzLWE2ZTEtNjBhOGYyYjhiMTJm | without changes                            | 403         | Access Denied                                                                                                                                                                                                                                                                     |
      | no body in request                              | 680ab99aaf0c792d89b73fa7 | $(env.base_apikey)                               | no body in request                         | 400         | Required request body is missing: public com.clockify.adapter.http.v1.dto.ProjectDtoImplV1 com.clockify.adapter.http.v1.project.ProjectHttpAdapter.create(java.lang.String,com.clockify.adapter.http.v1.requests.ProjectRequest,com.clockify.adapter.spring.security.CurrentAuth) |
      | no project name in body request                 | 680ab99aaf0c792d89b73fa7 | $(env.base_apikey)                               | no project name in request                 | 400         | Se requiere el nombre del proyecto                                                                                                                                                                                                                                                |
      | null project name                               | 680ab99aaf0c792d89b73fa7 | $(env.base_apikey)                               | null project name                          | 400         | Se requiere el nombre del proyecto                                                                                                                                                                                                                                                |
      | project name with with less than two characters | 680ab99aaf0c792d89b73fa7 | $(env.base_apikey)                               | project name with less than two characters | 400         | El nombre del proyecto debe tener entre 2 y 250 caracteres                                                                                                                                                                                                                        |
      | project name with more than 250 characters      | 680ab99aaf0c792d89b73fa7 | $(env.base_apikey)                               | project name with more than 250 characters | 400         | El nombre del proyecto debe tener entre 2 y 250 caracteres                                                                                                                                                                                                                        |
      | non-existent api-key                            | 680ab99aaf0c792d89b73fa7 | 515156sgsafaiu9esf84s48ddsg                      | without changes                            | 401         | Api key does not exist                                                                                                                                                                                                                                                            |


  @FailFindProjectById @Regression
  Scenario Outline: Fail Find project by ID for <reason>.
    And header x-api-key = <api-key>
    And endpoint /v1/workspaces/<workspaceId>/projects/<projectId>
    When execute method GET
    Then the status code should be <status-code>
    And response should be message = <message>

    Examples:
      | reason                      | workspaceId              | api-key                                          | projectId                | status-code | message                                                             |
      | empty workspaceId           |                          | $(env.base_apikey)                               | 681949a23e62a459a1c6ea96 | 404         | No static resource v1/workspaces/projects/681949a23e62a459a1c6ea96. |
      | incomplete workspaceId      | 680ab99aaf0c792d89b73    | $(env.base_apikey)                               | 681949a23e62a459a1c6ea96 | 403         | Access Denied                                                       |
      | api-key without permissions | 680ab99aaf0c792d89b73fa7 | MGE5ZTA2NzgtOGYzMi00ZjQzLWE2ZTEtNjBhOGYyYjhiMTJm | 681949a23e62a459a1c6ea96 | 403         | Access Denied                                                       |
      | non-existent api-key        | 680ab99aaf0c792d89b73fa7 | 515156sgsafaiu9esf84s48ddsg                      | 681949a23e62a459a1c6ea96 | 401         | Api key does not exist                                              |
      | non-existent projectId      | 680ab99aaf0c792d89b73fa7 | $(env.base_apikey)                               | 681949a23e62a459a1fr5e   | 400         | Proyecto no pertenece a Espacio de trabajo                          |

  @FailUpdateProject @Regression
  Scenario Outline: Fail Update project on workspace for <reason>
    And endpoint /v1/workspaces/<workspaceId>/projects/<projectId>
    And header x-api-key = <api-key>
    And generate update test body <updateBody>
    And body {{updateTestBody}}
    When execute method PUT
    Then the status code should be <status-code>
    And response should be message = <message>
    Examples:
      | reason                                          | workspaceId              | projectId                | api-key                                          | updateBody                                 | status-code | message                                                                                                                                                                                                                                                                                                  |
      | empty workspaceId                               |                          | 690625a4133ebe6373041dee | $(env.base_apikey)                               | without changes                            | 404         | No static resource v1/workspaces/projects/690625a4133ebe6373041dee.                                                                                                                                                                                                                                      |
      | incomplete workspaceId                          | 680ab99aaf0c792d89b73    | 690625a4133ebe6373041dee | $(env.base_apikey)                               | without changes                            | 403         | Access Denied                                                                                                                                                                                                                                                                                            |
      | api-key without permissions                     | 680ab99aaf0c792d89b73fa7 | 690625a4133ebe6373041dee | MGE5ZTA2NzgtOGYzMi00ZjQzLWE2ZTEtNjBhOGYyYjhiMTJm | without changes                            | 403         | Access Denied                                                                                                                                                                                                                                                                                            |
      | non-existent api-key                            | 680ab99aaf0c792d89b73fa7 | 690625a4133ebe6373041dee | 515156sgsafaiu9esf84s48ddsg                      | without changes                            | 401         | Api key does not exist                                                                                                                                                                                                                                                                                   |
      | non-existent projectId                          | 680ab99aaf0c792d89b73fa7 | 681949a23e62a459a1fr5e   | $(env.base_apikey)                               | without changes                            | 400         | Proyecto no pertenece a Espacio de trabajo                                                                                                                                                                                                                                                               |
      | empty projectId                                 | 680ab99aaf0c792d89b73fa7 |                          | $(env.base_apikey)                               | without changes                            | 405         | Request method 'PUT' is not supported                                                                                                                                                                                                                                                                    |
      | no body in request                              | 680ab99aaf0c792d89b73fa7 | 690625a4133ebe6373041dee | $(env.base_apikey)                               | no body in request                         | 400         | Required request body is missing: public com.clockify.adapter.http.v1.dto.ProjectDtoImplV1 com.clockify.adapter.http.v1.project.ProjectHttpAdapter.update(java.lang.String,java.lang.String,com.clockify.adapter.http.v1.requests.UpdateProjectRequest,com.clockify.adapter.spring.security.CurrentAuth) |
      | project name with with less than two characters | 680ab99aaf0c792d89b73fa7 | 690625a4133ebe6373041dee | $(env.base_apikey)                               | project name with less than two characters | 400         | El nombre del proyecto debe tener entre 2 y 250 caracteres                                                                                                                                                                                                                                               |
      | project name with more than 250 characters      | 680ab99aaf0c792d89b73fa7 | 690625a4133ebe6373041dee | $(env.base_apikey)                               | project name with more than 250 characters | 400         | El nombre del proyecto debe tener entre 2 y 250 caracteres                                                                                                                                                                                                                                               |

  @FailDeleteProject @Regression
  Scenario Outline: Fail delete project for <reason>
    And header x-api-key = <api-key>
    And endpoint /v1/workspaces/<workspaceId>/projects/<archivedProjectId>
    When execute method DELETE
    Then the status code should be <status-code>
    And response should be message = <message>
    Examples:
      | reason                                                  | api-key                                          | workspaceId              | archivedProjectId        | status-code | message                                                             |
      | api-key without permissions                             | MGE5ZTA2NzgtOGYzMi00ZjQzLWE2ZTEtNjBhOGYyYjhiMTJm | 680ab99aaf0c792d89b73fa7 | 693adec282bbd06f54ee1035 | 403         | Access Denied                                                       |
      | non-existent api-key                                    | 515156sgsafaiu9esf84s48ddsg                      | 680ab99aaf0c792d89b73fa7 | 693adec282bbd06f54ee1035 | 401         | Api key does not exist                                              |
      | empty workspaceId                                       | $(env.base_apikey)                               |                          | 693adec282bbd06f54ee1035 | 404         | No static resource v1/workspaces/projects/693adec282bbd06f54ee1035. |
      | incomplete workspaceId                                  | $(env.base_apikey)                               | 680ab99aaf0c792d89b73    | 693adec282bbd06f54ee1035 | 403         | Access Denied                                                       |
      | workspaceId that does not contain the project to delete | $(env.base_apikey)                               | 69061454f3abbe6b4e1013a4 | 693adec282bbd06f54ee1035 | 400         | Proyecto no pertenece a Espacio de trabajo                          |
      | empty projectId                                         | $(env.base_apikey)                               | 680ab99aaf0c792d89b73fa7 |                          | 405         | Request method 'DELETE' is not supported                            |
      | non-existent projectId                                  | $(env.base_apikey)                               | 680ab99aaf0c792d89b73fa7 | 681949a23e62a459a1fr5e   | 400         | Proyecto no pertenece a Espacio de trabajo                          |
      | trying to delete an active project                      | $(env.base_apikey)                               | 680ab99aaf0c792d89b73fa7 | 681949a23e62a459a1c6ea96 | 400         | No se puede eliminar un proyecto activo                             |