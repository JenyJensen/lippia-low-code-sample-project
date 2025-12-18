@TimeEntries
Feature: Time entries in Clockify

  Background:
    Given base url https://api.clockify.me/api
    And header Content-Type = application/json
    And header Accept = */*

  @GetTimeEntriesByUserId
  Scenario Outline: Get time entries for a user on workspace
    And endpoint /v1/workspaces/69061454f3abbe6b4e1013a4/user/<userId>/time-entries
    And header x-api-key = NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz
    When execute method GET
    Then the status code should be 200
    And validate schema jsons/schemas/getTimeEntriesResponse.json
    And validate all time entries belong to same user <userId>
    * define TimeEntryId = $[0].id

    Examples:
      | userId                   |
      | 680ab99aaf0c792d89b73fa6 |

  @GetSpecificTimeEntryById
  Scenario: Get a specific time entry on workspace.
    And call ClockifyTimeEntries.feature@GetTimeEntriesByUserId
    And header x-api-key = NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz
    And endpoint /v1/workspaces/69061454f3abbe6b4e1013a4/time-entries/{{TimeEntryId}}
    When execute method GET
    Then the status code should be 200
    And response should be description = TPFinal
    * print response

  @AddNewTimeEntry
  Scenario: Add a new time entry
    And header x-api-key = NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz
    And endpoint /v1/workspaces/69061454f3abbe6b4e1013a4/time-entries
    * define body = jsons/bodies/bodyAddNewTimeEntry.json
    And se crea una descripcion random para el time entry
    And set value $(var.changeDescription) of key description in body $(var.body)
    When execute method POST
    Then the status code should be 201
    * print response
    * define ProjectId = $.id

  @UpdateTimeEntry
  Scenario: Update time entry on workspace
    And call ClockifyTimeEntries.feature@AddNewTimeEntry
    And header x-api-key = NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz
    And endpoint /v1/workspaces/69061454f3abbe6b4e1013a4/time-entries/{{ProjectId}}
    And body jsons/bodies/bodyUpdateTimeEntry.json
    When execute method PUT
    Then the status code should be 200
    * print response

  @DeleteTimeEntryById
  Scenario: Delete time entry from workspace
    And call ClockifyTimeEntries.feature@UpdateTimeEntry
    And header x-api-key = NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz
    And endpoint /v1/workspaces/69061454f3abbe6b4e1013a4/time-entries/{{ProjectId}}
    When execute method DELETE
    Then the status code should be 204

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
      | empty api-key               | 680ab99aaf0c792d89b73fa7 |                                                  | 681949a23e62a459a1c6ea96 | 401         | Api key does not exist                                              |
      | null api-key                | 680ab99aaf0c792d89b73fa7 | null                                             | 681949a23e62a459a1c6ea96 | 401         | Api key does not exist                                              |
      | non-existent api-key        | 680ab99aaf0c792d89b73fa7 | 515156sgsafaiu9esf84s48ddsg                      | 681949a23e62a459a1c6ea96 | 401         | Api key does not exist                                              |
      | null projectId              | 680ab99aaf0c792d89b73fa7 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | null                     | 400         | Proyecto no pertenece a Espacio de trabajo                          |
      | non-existent projectId      | 680ab99aaf0c792d89b73fa7 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 681949a23e62a459a1fr5e   | 400         | Proyecto no pertenece a Espacio de trabajo                          |

  @FailUpdateProject
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
      | empty workspaceId                               |                          | 690625a4133ebe6373041dee | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | without changes                            | 404         | No static resource v1/workspaces/projects/690625a4133ebe6373041dee.                                                                                                                                                                                                                                      |
      | null workspaceId                                | null                     | 690625a4133ebe6373041dee | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | without changes                            | 403         | Access Denied                                                                                                                                                                                                                                                                                            |
      | incomplete workspaceId                          | 680ab99aaf0c792d89b73    | 690625a4133ebe6373041dee | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | without changes                            | 403         | Access Denied                                                                                                                                                                                                                                                                                            |
      | api-key without permissions                     | 680ab99aaf0c792d89b73fa7 | 690625a4133ebe6373041dee | MGE5ZTA2NzgtOGYzMi00ZjQzLWE2ZTEtNjBhOGYyYjhiMTJm | without changes                            | 403         | Access Denied                                                                                                                                                                                                                                                                                            |
      | empty api-key                                   | 680ab99aaf0c792d89b73fa7 | 690625a4133ebe6373041dee |                                                  | without changes                            | 401         | Api key does not exist                                                                                                                                                                                                                                                                                   |
      | null api-key                                    | 680ab99aaf0c792d89b73fa7 | 690625a4133ebe6373041dee | null                                             | without changes                            | 401         | Api key does not exist                                                                                                                                                                                                                                                                                   |
      | non-existent api-key                            | 680ab99aaf0c792d89b73fa7 | 690625a4133ebe6373041dee | 515156sgsafaiu9esf84s48ddsg                      | without changes                            | 401         | Api key does not exist                                                                                                                                                                                                                                                                                   |
      | null projectId                                  | 680ab99aaf0c792d89b73fa7 | null                     | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | without changes                            | 400         | Proyecto no pertenece a Espacio de trabajo                                                                                                                                                                                                                                                               |
      | non-existent projectId                          | 680ab99aaf0c792d89b73fa7 | 681949a23e62a459a1fr5e   | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | without changes                            | 400         | Proyecto no pertenece a Espacio de trabajo                                                                                                                                                                                                                                                               |
      | no body in request                              | 680ab99aaf0c792d89b73fa7 | 690625a4133ebe6373041dee | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | no body in request                         | 400         | Required request body is missing: public com.clockify.adapter.http.v1.dto.ProjectDtoImplV1 com.clockify.adapter.http.v1.project.ProjectHttpAdapter.update(java.lang.String,java.lang.String,com.clockify.adapter.http.v1.requests.UpdateProjectRequest,com.clockify.adapter.spring.security.CurrentAuth) |
      | project name with with less than two characters | 680ab99aaf0c792d89b73fa7 | 690625a4133ebe6373041dee | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | project name with less than two characters | 400         | El nombre del proyecto debe tener entre 2 y 250 caracteres                                                                                                                                                                                                                                               |
      | project name with more than 250 characters      | 680ab99aaf0c792d89b73fa7 | 690625a4133ebe6373041dee | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | project name with more than 250 characters | 400         | El nombre del proyecto debe tener entre 2 y 250 caracteres                                                                                                                                                                                                                                               |

  @FailDeleteProject
  Scenario Outline: Fail delete project for <reason>
    And header x-api-key = <api-key>
    And endpoint /v1/workspaces/<workspaceId>/projects/<archivedProjectId>
    When execute method DELETE
    Then the status code should be <status-code>
    And response should be message = <message>
    Examples:
      | reason                                                  | api-key                                          | workspaceId              | archivedProjectId        | status-code | message                                                             |
      | api-key without permissions                             | MGE5ZTA2NzgtOGYzMi00ZjQzLWE2ZTEtNjBhOGYyYjhiMTJm | 680ab99aaf0c792d89b73fa7 | 693adec282bbd06f54ee1035 | 403         | Access Denied                                                       |
      | empty api-key                                           | ""                                               | 680ab99aaf0c792d89b73fa7 | 693adec282bbd06f54ee1035 | 401         | Api key does not exist                                              |
      | null api-key                                            | null                                             | 680ab99aaf0c792d89b73fa7 | 693adec282bbd06f54ee1035 | 401         | Api key does not exist                                              |
      | non-existent api-key                                    | 515156sgsafaiu9esf84s48ddsg                      | 680ab99aaf0c792d89b73fa7 | 693adec282bbd06f54ee1035 | 401         | Api key does not exist                                              |
      | empty workspaceId                                       | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz |                          | 693adec282bbd06f54ee1035 | 404         | No static resource v1/workspaces/projects/693adec282bbd06f54ee1035. |
      | null workspaceId                                        | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | null                     | 693adec282bbd06f54ee1035 | 403         | Access Denied                                                       |
      | incomplete workspaceId                                  | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 680ab99aaf0c792d89b73    | 693adec282bbd06f54ee1035 | 403         | Access Denied                                                       |
      | workspaceId that does not contain the project to delete | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 69061454f3abbe6b4e1013a4 | 693adec282bbd06f54ee1035 | 400         | Proyecto no pertenece a Espacio de trabajo                          |
      | empty projectId                                         | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 680ab99aaf0c792d89b73fa7 |                          | 405         | Request method 'DELETE' is not supported                            |
      | null projectId                                          | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 680ab99aaf0c792d89b73fa7 | null                     | 400         | Proyecto no pertenece a Espacio de trabajo                          |
      | non-existent projectId                                  | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 680ab99aaf0c792d89b73fa7 | 681949a23e62a459a1fr5e   | 400         | Proyecto no pertenece a Espacio de trabajo                          |
      | trying to delete an active project                      | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 680ab99aaf0c792d89b73fa7 | 681949a23e62a459a1c6ea96 | 400         | No se puede eliminar un proyecto activo                             |