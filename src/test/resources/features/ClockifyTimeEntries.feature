@TimeEntries
Feature: Time entries in Clockify

  Background:
    Given base url https://api.clockify.me/api
    And header Content-Type = application/json
    And header Accept = */*

  @GetUserInfo
  Scenario: Get currently logged-in user's info
    And header x-api-key = NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz
    And endpoint /v1/user
    When execute method GET
    Then the status code should be 200
    * print response
    * define userId = $.id

  @GetTimeEntriesByUserId
  Scenario: Get time entries for a user on workspace
    And call ClockifyTimeEntries.feature@GetUserInfo
    And endpoint /v1/workspaces/69061454f3abbe6b4e1013a4/user/{{userId}}/time-entries
    And header x-api-key = NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz
    When execute method GET
    Then the status code should be 200
    And validate schema jsons/schemas/getTimeEntriesResponse.json
    And validate all time entries belong to same user
    * define TimeEntryId = $[0].id
    * print response

  @GetTimeEntryById
  Scenario: Get a specific time entry on workspace.
    And header x-api-key = NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz
    And endpoint /v1/workspaces/69061454f3abbe6b4e1013a4/time-entries/6941cb948d3fba1733ba8ab1
    When execute method GET
    Then the status code should be 200
    And response should be description = TPFinal
    * print response

  @AddNewTimeEntry
  Scenario: Add a new time entry
    And header x-api-key = NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz
    And endpoint /v1/workspaces/69061454f3abbe6b4e1013a4/time-entries
    And body jsons/bodies/bodyAddNewTimeEntry.json
#    And se crea una descripcion random para el time entry
#    And set value $(var.changeDescription) of key description in body $(var.body)
    When execute method POST
    Then the status code should be 400
    * print response

#  @AddNewTimeEntry
#  Scenario: Add a new time entry
#    And header x-api-key = NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz
#    And endpoint /v1/workspaces/69061454f3abbe6b4e1013a4/time-entries
#    * define body = jsons/bodies/bodyAddNewTimeEntry.json
#    And se crea una descripcion random para el time entry
#    And set value $(var.changeDescription) of key description in body $(var.body)
#    When execute method POST
#    Then the status code should be 201
#    * print response
#    * define timeEntryId = $.id

  @UpdateTimeEntry
  Scenario: Update time entry on workspace
    And call ClockifyTimeEntries.feature@AddNewTimeEntry
    And header x-api-key = NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz
    And endpoint /v1/workspaces/69061454f3abbe6b4e1013a4/time-entries/{{timeEntryId}}
    And body jsons/bodies/bodyUpdateTimeEntry.json
    When execute method PUT
    Then the status code should be 200
    And response should be description = Time entry modificado
    * print response

  @DeleteTimeEntryById
  Scenario: Delete time entry from workspace
    And call ClockifyTimeEntries.feature@AddNewTimeEntry
    And header x-api-key = NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz
    And endpoint /v1/workspaces/69061454f3abbe6b4e1013a4/time-entries/{{timeEntryId}}
    When execute method DELETE
    Then the status code should be 204


  @FailGetTimeEntriesByUserId
  Scenario Outline: Fail get time entries for a user on workspace, for <reason>
    And endpoint /v1/workspaces/<workspaceId>/user/<userId>/time-entries
    And header x-api-key = <api-key>
    When execute method GET
    Then the status code should be <status-code>
    And response should be message = <message>

    Examples:
      | reason                      | workspaceId              | userId                   | api-key                                          | status-code | message                                                                      |
      | empty workspaceId           |                          | 680ab99aaf0c792d89b73fa6 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 404         | No static resource v1/workspaces/user/680ab99aaf0c792d89b73fa6/time-entries. |
      | non-existent workspaceId    | 680ab99aaf0c792d89b73    | 680ab99aaf0c792d89b73fa6 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 403         | Access Denied                                                                |
      | api-key without permissions | 69061454f3abbe6b4e1013a4 | 680ab99aaf0c792d89b73fa6 | MGE5ZTA2NzgtOGYzMi00ZjQzLWE2ZTEtNjBhOGYyYjhiMTJm | 403         | Access Denied                                                                |
      | non-existent api-key        | 69061454f3abbe6b4e1013a4 | 680ab99aaf0c792d89b73fa6 | sdsdg46e878sdg4                                  | 401         | Api key does not exist                                                       |
      | non-existent userId         | 69061454f3abbe6b4e1013a4 | 000000000000000000000000 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 400         | Usuario no pertenece a Espacio de trabajo                                    |
      | empty userId                | 69061454f3abbe6b4e1013a4 |                          | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 404         | No static resource v1/workspaces/69061454f3abbe6b4e1013a4/user/time-entries. |

  @FailGetTimeEntryById
  Scenario Outline: Fail get a specific time entry on workspace for <reason>
    And endpoint /v1/workspaces/<workspaceId>/time-entries/<timeEntryId>
    And header x-api-key = <api-key>
    When execute method GET
    Then the status code should be <status-code>
    And response should be message = <message>
    Examples:
      | reason                                                 | workspaceId              | timeEntryId              | api-key                                          | status-code | message                                                                  |
      | empty workspaceId                                      |                          | 6941cb948d3fba1733ba8ab1 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 404         | [No static resource v1/workspaces/time-entries/6941cb948d3fba1733ba8ab1. |
      | non-existent workspaceId                               | 680ab99aaf0c792d89b73    | 6941cb948d3fba1733ba8ab1 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 403         | Access Denied                                                            |
      | api-key without permissions                            | 69061454f3abbe6b4e1013a4 | 6941cb948d3fba1733ba8ab1 | MGE5ZTA2NzgtOGYzMi00ZjQzLWE2ZTEtNjBhOGYyYjhiMTJm | 403         | Access Denied                                                            |
      | non-existent api-key                                   | 69061454f3abbe6b4e1013a4 | 6941cb948d3fba1733ba8ab1 | sdsdg46e878sdg4                                  | 401         | Api key does not exist                                                   |
      | non-existent time entry Id                             | 69061454f3abbe6b4e1013a4 | 000000000000000000000000 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 400         | Entrada de tiempo no pertenece a Espacio de trabajo                      |
      | empty time entry Id                                    | 69061454f3abbe6b4e1013a4 |                          | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 405         | Request method 'GET' is not supported                                    |
      | valid time entry Id belonging to a different workspace | 69061454f3abbe6b4e1013a4 | 6941cb948d3fba1733ba8ab2 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 400         | Entrada de tiempo no pertenece a Espacio de trabajo                      |
      | deleted time entry Id                                  | 69061454f3abbe6b4e1013a4 | 69440b66fbcefd7eee7006b6 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 400         | Entrada de tiempo no pertenece a Espacio de trabajo                      |

  @FailAddNewTimeEntry
  Scenario Outline: Fail Add new time entry for <reason>
    And endpoint /v1/workspaces/<workspaceId>/time-entries
    And header x-api-key = <api-key>
    And generate request body <bodyRequest>
    And body {{testBody}}
    When execute method POST
    Then the status code should be <status-code>
    And response should be message = <message>

    Examples:
      | reason                             | workspaceId              | api-key                                          | bodyRequest                   | status-code | message                                                                                                                                                                                                                                                                                                                                             |
#      | empty workspaceId           |                          | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz                                                                                                                                                                                                                                                                                               | without changes    | 405         | Request method 'POST' is not supported                                                                                                                                                                                                                                            |
#      | incomplete workspaceId      | 680ab99aaf0c792d89b73    | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz                                                                                                                                                                                                                                                                                               | without changes    | 403         | Access Denied                                                                                                                                                                                                                                                                     |
#      | api-key without permissions | 69061454f3abbe6b4e1013a4 | MGE5ZTA2NzgtOGYzMi00ZjQzLWE2ZTEtNjBhOGYyYjhiMTJm                                                                                                                                                                                                                                                                                               | without changes    | 403         | Access Denied                                                                                                                                                                                                                                                                     |
     # | empty api-key               | 69061454f3abbe6b4e1013a4 | ""                                                                                                                                                                                                                                                                                                                                             | without changes    | 401         | Api key does not exist                                                                                                                                                                                                                                                            |
#      | null api-key                | 69061454f3abbe6b4e1013a4 | null                                                                                                                                                                                                                                                                                                                                           | without changes    | 401         | Api key does not exist                                                                                                                                                                                                                                                            |
#      | non-existent api-key        | 69061454f3abbe6b4e1013a4 | 515156sgsafaiu9esf84s48ddsg                                                                                                                                                                                                                                                                                                                    | without changes    | 401         | Api key does not exist                                                                                                                                                                                                                                                            |
      | no body in request                 | 69061454f3abbe6b4e1013a4 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | no body in request            | 400         | Required request body is missing: public com.clockify.adapter.http.v1.dto.TimeEntryDtoImplV1 com.clockify.adapter.http.v1.timeentry.TimeEntryHttpAdapter.create(java.lang.String,com.clockify.adapter.http.v1.requests.CreateTimeEntryRequest,java.lang.String,java.lang.String,java.lang.String,com.clockify.adapter.spring.security.CurrentAuth) |
     | body without start key             | 69061454f3abbe6b4e1013a4 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | without start key             | 400         | No se puede crear una entrada de tiempo solo con la hora de finalización.                                                                                                                                                                                                                                                                           |
     | body without start hour            | 69061454f3abbe6b4e1013a4 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | without start hour            | 400         | Introdujiste un valor no válido para el campo : [start]. Valores que representan [start] puede ser nulo y no puede estar vacío. Asegúrate de que la fecha [start] no es mayor que 9999-12-31 ni menor que 0001-01-01. Asegúrate de que la fecha de [start] tiene el siguiente formato: "yyyy-MM-ddThh:mm:ssZ" Ejemplo: 2018-11-29T13:00:46Z.      |
      | body without start date            | 69061454f3abbe6b4e1013a4 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | without start date            | 400         | Introdujiste un valor no válido para el campo : [start]. Valores que representan [start] puede ser nulo y no puede estar vacío. Asegúrate de que la fecha [start] no es mayor que 9999-12-31 ni menor que 0001-01-01. Asegúrate de que la fecha de [start] tiene el siguiente formato: "yyyy-MM-ddThh:mm:ssZ" Ejemplo: 2018-11-29T13:00:46Z.      |
      | body with null start value         | 69061454f3abbe6b4e1013a4 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | with null start value         | 400         | No se puede crear una entrada de tiempo solo con la hora de finalización.                                                                                                                                                                                                                                                                           |
 #     | body with invalid start hour value | 69061454f3abbe6b4e1013a4 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | with invalid start hour value | 400         | Introdujiste un valor no válido para el campo : [start]. Valores que representan [start] puede ser nulo y no puede estar vacío. Asegúrate de que la fecha [start] no es mayor que 9999-12-31 ni menor que 0001-01-01. Asegúrate de que la fecha de [start] tiene el siguiente formato: "yyyy-MM-ddThh:mm:ssZ" Ejemplo: 2018-11-29T13:00:46Z.      |
  #    | body with invalid start date value | 69061454f3abbe6b4e1013a4 | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | with invalid start date value | 400         | Introdujiste un valor no válido para el campo : [start]. Valores que representan [start] puede ser nulo y no puede estar vacío. Asegúrate de que la fecha [start] no es mayor que 9999-12-31 ni menor que 0001-01-01. Asegúrate de que la fecha de [start] tiene el siguiente formato: "yyyy-MM-ddThh:mm:ssZ" Ejemplo: 2018-11-29T13:00:46Z.      |
##      | userId without permissions  | 69061454f3abbe6b4e1013a4 | 6804e7a71354984631812f7f | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 400         | Usuario no pertenece a Espacio de trabajo                                    |



#  @FailUpdateProject
#  Scenario Outline: Fail Update project on workspace for <reason>
#    And endpoint /v1/workspaces/<workspaceId>/projects/<projectId>
#    And header x-api-key = <api-key>
#    And generate update test body <updateBody>
#    And body {{updateTestBody}}
#    When execute method PUT
#    Then the status code should be <status-code>
#    And response should be message = <message>
#    Examples:
#      | reason                                          | workspaceId              | projectId                | api-key                                          | updateBody                                 | status-code | message                                                                                                                                                                                                                                                                                                  |
#      | empty workspaceId                               |                          | 690625a4133ebe6373041dee | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | without changes                            | 404         | No static resource v1/workspaces/projects/690625a4133ebe6373041dee.                                                                                                                                                                                                                                      |
#      | null workspaceId                                | null                     | 690625a4133ebe6373041dee | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | without changes                            | 403         | Access Denied                                                                                                                                                                                                                                                                                            |
#      | incomplete workspaceId                          | 680ab99aaf0c792d89b73    | 690625a4133ebe6373041dee | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | without changes                            | 403         | Access Denied                                                                                                                                                                                                                                                                                            |
#      | api-key without permissions                     | 69061454f3abbe6b4e1013a4 | 690625a4133ebe6373041dee | MGE5ZTA2NzgtOGYzMi00ZjQzLWE2ZTEtNjBhOGYyYjhiMTJm | without changes                            | 403         | Access Denied                                                                                                                                                                                                                                                                                            |
#      | empty api-key                                   | 69061454f3abbe6b4e1013a4 | 690625a4133ebe6373041dee |                                                  | without changes                            | 401         | Api key does not exist                                                                                                                                                                                                                                                                                   |
#      | null api-key                                    | 69061454f3abbe6b4e1013a4 | 690625a4133ebe6373041dee | null                                             | without changes                            | 401         | Api key does not exist                                                                                                                                                                                                                                                                                   |
#      | non-existent api-key                            | 69061454f3abbe6b4e1013a4 | 690625a4133ebe6373041dee | 515156sgsafaiu9esf84s48ddsg                      | without changes                            | 401         | Api key does not exist                                                                                                                                                                                                                                                                                   |
#      | null projectId                                  | 69061454f3abbe6b4e1013a4 | null                     | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | without changes                            | 400         | Proyecto no pertenece a Espacio de trabajo                                                                                                                                                                                                                                                               |
#      | non-existent projectId                          | 69061454f3abbe6b4e1013a4 | 681949a23e62a459a1fr5e   | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | without changes                            | 400         | Proyecto no pertenece a Espacio de trabajo                                                                                                                                                                                                                                                               |
#      | no body in request                              | 69061454f3abbe6b4e1013a4 | 690625a4133ebe6373041dee | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | no body in request                         | 400         | Required request body is missing: public com.clockify.adapter.http.v1.dto.ProjectDtoImplV1 com.clockify.adapter.http.v1.project.ProjectHttpAdapter.update(java.lang.String,java.lang.String,com.clockify.adapter.http.v1.requests.UpdateProjectRequest,com.clockify.adapter.spring.security.CurrentAuth) |
#      | project name with with less than two characters | 69061454f3abbe6b4e1013a4 | 690625a4133ebe6373041dee | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | project name with less than two characters | 400         | El nombre del proyecto debe tener entre 2 y 250 caracteres                                                                                                                                                                                                                                               |
#      | project name with more than 250 characters      | 69061454f3abbe6b4e1013a4 | 690625a4133ebe6373041dee | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | project name with more than 250 characters | 400         | El nombre del proyecto debe tener entre 2 y 250 caracteres                                                                                                                                                                                                                                               |
#
#  @FailDeleteProject
#  Scenario Outline: Fail delete project for <reason>
#    And header x-api-key = <api-key>
#    And endpoint /v1/workspaces/<workspaceId>/projects/<archivedProjectId>
#    When execute method DELETE
#    Then the status code should be <status-code>
#    And response should be message = <message>
#    Examples:
#      | reason                                                  | api-key                                          | workspaceId              | archivedProjectId        | status-code | message                                                             |
#      | api-key without permissions                             | MGE5ZTA2NzgtOGYzMi00ZjQzLWE2ZTEtNjBhOGYyYjhiMTJm | 69061454f3abbe6b4e1013a4 | 693adec282bbd06f54ee1035 | 403         | Access Denied                                                       |
#      | empty api-key                                           | ""                                               | 69061454f3abbe6b4e1013a4 | 693adec282bbd06f54ee1035 | 401         | Api key does not exist                                              |
#      | null api-key                                            | null                                             | 69061454f3abbe6b4e1013a4 | 693adec282bbd06f54ee1035 | 401         | Api key does not exist                                              |
#      | non-existent api-key                                    | 515156sgsafaiu9esf84s48ddsg                      | 69061454f3abbe6b4e1013a4 | 693adec282bbd06f54ee1035 | 401         | Api key does not exist                                              |
#      | empty workspaceId                                       | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz |                          | 693adec282bbd06f54ee1035 | 404         | No static resource v1/workspaces/projects/693adec282bbd06f54ee1035. |
#      | null workspaceId                                        | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | null                     | 693adec282bbd06f54ee1035 | 403         | Access Denied                                                       |
#      | incomplete workspaceId                                  | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 680ab99aaf0c792d89b73    | 693adec282bbd06f54ee1035 | 403         | Access Denied                                                       |
#      | workspaceId that does not contain the project to delete | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 69061454f3abbe6b4e1013a4 | 693adec282bbd06f54ee1035 | 400         | Proyecto no pertenece a Espacio de trabajo                          |
#      | empty projectId                                         | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 69061454f3abbe6b4e1013a4 |                          | 405         | Request method 'DELETE' is not supported                            |
#      | null projectId                                          | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 69061454f3abbe6b4e1013a4 | null                     | 400         | Proyecto no pertenece a Espacio de trabajo                          |
#      | non-existent projectId                                  | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 69061454f3abbe6b4e1013a4 | 681949a23e62a459a1fr5e   | 400         | Proyecto no pertenece a Espacio de trabajo                          |
#      | trying to delete an active project                      | NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz | 69061454f3abbe6b4e1013a4 | 681949a23e62a459a1c6ea96 | 400         | No se puede eliminar un proyecto activo                             |