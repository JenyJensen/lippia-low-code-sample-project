@Clockify @TimeEntries
Feature: Time entries in Clockify

  Background:
    Given base url $(env.base_url_clockify)
    And header Content-Type = application/json
    And header Accept = */*

  @GetUserInfo @Regression
  Scenario: Get currently logged-in user's info
    And header x-api-key = $(env.base_apikey)
    And endpoint /v1/user
    When execute method GET
    Then the status code should be 200
    * print response
    * define userId = $.id

  @GetTimeEntriesByUserId @Regression
  Scenario: Get time entries for a user on workspace
    And call ClockifyTimeEntries.feature@GetUserInfo
    And endpoint /v1/workspaces/69061454f3abbe6b4e1013a4/user/{{userId}}/time-entries
    And header x-api-key = $(env.base_apikey)
    When execute method GET
    Then the status code should be 200
    And validate schema jsons/schemas/getTimeEntriesResponse.json
    And validate all time entries belong to same user
    * define TimeEntryId = $[0].id
    * print response

  @GetTimeEntryById @Regression
  Scenario: Get a specific time entry on workspace.
    And header x-api-key = $(env.base_apikey)
    And endpoint /v1/workspaces/69061454f3abbe6b4e1013a4/time-entries/6941cb948d3fba1733ba8ab1
    When execute method GET
    Then the status code should be 200
    And response should be description = TPFinal
    * print response

  @AddNewTimeEntry @Smoke @Regression
  Scenario: Add a new time entry
    And header x-api-key = $(env.base_apikey)
    And endpoint /v1/workspaces/69061454f3abbe6b4e1013a4/time-entries
    * define body = jsons/bodies/bodyAddNewTimeEntry.json
    And a random description is generated and stored in a variable
    And set value $(var.changeDescription) of key description in body $(var.body)
    When execute method POST
    Then the status code should be 201
    * print response
    * define timeEntryId = $.id

  @UpdateTimeEntry @Smoke @Regression
  Scenario: Update time entry on workspace
    And call ClockifyTimeEntries.feature@AddNewTimeEntry
    And header x-api-key = $(env.base_apikey)
    And endpoint /v1/workspaces/69061454f3abbe6b4e1013a4/time-entries/{{timeEntryId}}
    And body jsons/bodies/bodyUpdateTimeEntry.json
    When execute method PUT
    Then the status code should be 200
    And response should be description = Time entry modificado
    * print response

  @DeleteTimeEntry @Smoke @Regression
  Scenario: Delete time entry from workspace
    And call ClockifyTimeEntries.feature@AddNewTimeEntry
    And header x-api-key = $(env.base_apikey)
    And endpoint /v1/workspaces/69061454f3abbe6b4e1013a4/time-entries/{{timeEntryId}}
    When execute method DELETE
    Then the status code should be 204


  @FailGetTimeEntriesByUserId @Regression
  Scenario Outline: Fail get time entries for a user on workspace, for <reason>
    And endpoint /v1/workspaces/<workspaceId>/user/<userId>/time-entries
    And header x-api-key = <api-key>
    When execute method GET
    Then the status code should be <status-code>
    And response should be message = <message>

    Examples:
      | reason                      | workspaceId              | userId                   | api-key                                          | status-code | message                                                                      |
      | empty workspaceId           |                          | 680ab99aaf0c792d89b73fa6 | $(env.base_apikey)                               | 404         | No static resource v1/workspaces/user/680ab99aaf0c792d89b73fa6/time-entries. |
      | non-existent workspaceId    | 680ab99aaf0c792d89b73    | 680ab99aaf0c792d89b73fa6 | $(env.base_apikey)                               | 403         | Access Denied                                                                |
      | api-key without permissions | 69061454f3abbe6b4e1013a4 | 680ab99aaf0c792d89b73fa6 | MGE5ZTA2NzgtOGYzMi00ZjQzLWE2ZTEtNjBhOGYyYjhiMTJm | 403         | Access Denied                                                                |
      | non-existent api-key        | 69061454f3abbe6b4e1013a4 | 680ab99aaf0c792d89b73fa6 | sdsdg46e878sdg4                                  | 401         | Api key does not exist                                                       |
      | non-existent userId         | 69061454f3abbe6b4e1013a4 | 000000000000000000000000 | $(env.base_apikey)                               | 400         | Usuario no pertenece a Espacio de trabajo                                    |
      | empty userId                | 69061454f3abbe6b4e1013a4 |                          | $(env.base_apikey)                               | 404         | No static resource v1/workspaces/69061454f3abbe6b4e1013a4/user/time-entries. |
      | userId without permissions  | 69061454f3abbe6b4e1013a4 | 6804e7a71354984631812f7f | $(env.base_apikey)                               | 400         | Usuario no pertenece a Espacio de trabajo                                    |

  @FailGetTimeEntryById @Regression
  Scenario Outline: Fail get a specific time entry on workspace for <reason>
    And endpoint /v1/workspaces/<workspaceId>/time-entries/<timeEntryId>
    And header x-api-key = <api-key>
    When execute method GET
    Then the status code should be <status-code>
    And response should be message = <message>
    Examples:
      | reason                                                 | workspaceId              | timeEntryId              | api-key                                          | status-code | message                                                                 |
      | empty workspaceId                                      |                          | 6941cb948d3fba1733ba8ab1 | $(env.base_apikey)                               | 404         | No static resource v1/workspaces/time-entries/6941cb948d3fba1733ba8ab1. |
      | non-existent workspaceId                               | 680ab99aaf0c792d89b73    | 6941cb948d3fba1733ba8ab1 | $(env.base_apikey)                               | 403         | Access Denied                                                           |
      | api-key without permissions                            | 69061454f3abbe6b4e1013a4 | 6941cb948d3fba1733ba8ab1 | MGE5ZTA2NzgtOGYzMi00ZjQzLWE2ZTEtNjBhOGYyYjhiMTJm | 403         | Access Denied                                                           |
      | non-existent api-key                                   | 69061454f3abbe6b4e1013a4 | 6941cb948d3fba1733ba8ab1 | sdsdg46e878sdg4                                  | 401         | Api key does not exist                                                  |
      | non-existent time entry Id                             | 69061454f3abbe6b4e1013a4 | 000000000000000000000000 | $(env.base_apikey)                               | 400         | Entrada de tiempo no pertenece a Espacio de trabajo                     |
      | empty time entry Id                                    | 69061454f3abbe6b4e1013a4 |                          | $(env.base_apikey)                               | 405         | Request method 'GET' is not supported                                   |
      | valid time entry Id belonging to a different workspace | 69061454f3abbe6b4e1013a4 | 6941cb948d3fba1733ba8ab2 | $(env.base_apikey)                               | 400         | Entrada de tiempo no pertenece a Espacio de trabajo                     |
      | deleted time entry Id                                  | 69061454f3abbe6b4e1013a4 | 69440b66fbcefd7eee7006b6 | $(env.base_apikey)                               | 400         | Entrada de tiempo no pertenece a Espacio de trabajo                     |

  @FailAddNewTimeEntry @Regression
  Scenario Outline: Fail Add new time entry for <reason>
    And endpoint /v1/workspaces/<workspaceId>/time-entries
    And header x-api-key = <api-key>
    And generate request body <bodyRequest>
    And body {{testBody}}
    When execute method POST
    Then the status code should be <status-code>
    And response should be message = <message>

    Examples:
      | reason                             | workspaceId              | api-key                                          | bodyRequest                   | status-code | message                                                                                                                                                                                                                                                                                                                                            |
      | empty workspaceId                  |                          | $(env.base_apikey)                               | without changes               | 405         | Request method 'POST' is not supported                                                                                                                                                                                                                                                                                                             |
      | incomplete workspaceId             | 69061454f3abbe6b4e1013   | $(env.base_apikey)                               | without changes               | 403         | Access Denied                                                                                                                                                                                                                                                                                                                                      |
      | api-key without permissions        | 69061454f3abbe6b4e1013a4 | MGE5ZTA2NzgtOGYzMi00ZjQzLWE2ZTEtNjBhOGYyYjhiMTJm | without changes               | 403         | Access Denied                                                                                                                                                                                                                                                                                                                                      |
      | non-existent api-key               | 69061454f3abbe6b4e1013a4 | 515156sgsafaiu9esf84s48ddsg                      | without changes               | 401         | Api key does not exist                                                                                                                                                                                                                                                                                                                             |
      | no body in request                 | 69061454f3abbe6b4e1013a4 | $(env.base_apikey)                               | no body in request            | 400         | Required request body is missing: public com.clockify.adapter.http.v1.dto.TimeEntryDtoImplV1 com.clockify.adapter.http.v1.timeentry.TimeEntryHttpAdapter.create(java.lang.String,com.clockify.adapter.http.v1.requests.CreateTimeEntryRequest,java.lang.String,java.lang.String,java.lang.String,com.clockify.adapter.spring.security.CurrentAuth) |
      | body without start key             | 69061454f3abbe6b4e1013a4 | $(env.base_apikey)                               | without start key             | 400         | No se puede crear una entrada de tiempo solo con la hora de finalización.                                                                                                                                                                                                                                                                          |
      | body without start hour            | 69061454f3abbe6b4e1013a4 | $(env.base_apikey)                               | without start hour            | 400         | Introdujiste un valor no válido para el campo : [start]. Valores que representan [start] puede ser nulo y no puede estar vacío. Asegúrate de que la fecha [start] no es mayor que 9999-12-31 ni menor que 0001-01-01. Asegúrate de que la fecha de [start] tiene el siguiente formato: "yyyy-MM-ddThh:mm:ssZ" Ejemplo: 2018-11-29T13:00:46Z.       |
      | body without start date            | 69061454f3abbe6b4e1013a4 | $(env.base_apikey)                               | without start date            | 400         | Introdujiste un valor no válido para el campo : [start]. Valores que representan [start] puede ser nulo y no puede estar vacío. Asegúrate de que la fecha [start] no es mayor que 9999-12-31 ni menor que 0001-01-01. Asegúrate de que la fecha de [start] tiene el siguiente formato: "yyyy-MM-ddThh:mm:ssZ" Ejemplo: 2018-11-29T13:00:46Z.       |
      | body with null start value         | 69061454f3abbe6b4e1013a4 | $(env.base_apikey)                               | with null start value         | 400         | No se puede crear una entrada de tiempo solo con la hora de finalización.                                                                                                                                                                                                                                                                          |
      | body with invalid start hour value | 69061454f3abbe6b4e1013a4 | $(env.base_apikey)                               | with invalid start hour value | 400         | Introdujiste un valor no válido para el campo : [start]. Valores que representan [start] puede ser nulo y no puede estar vacío. Asegúrate de que la fecha [start] no es mayor que 9999-12-31 ni menor que 0001-01-01. Asegúrate de que la fecha de [start] tiene el siguiente formato: "yyyy-MM-ddThh:mm:ssZ" Ejemplo: 2018-11-29T13:00:46Z.       |
      | body with invalid start date value | 69061454f3abbe6b4e1013a4 | $(env.base_apikey)                               | with invalid start date value | 400         | Introdujiste un valor no válido para el campo : [start]. Valores que representan [start] puede ser nulo y no puede estar vacío. Asegúrate de que la fecha [start] no es mayor que 9999-12-31 ni menor que 0001-01-01. Asegúrate de que la fecha de [start] tiene el siguiente formato: "yyyy-MM-ddThh:mm:ssZ" Ejemplo: 2018-11-29T13:00:46Z.       |

  @FailUpdateTimeEntry @Regression
  Scenario Outline: Fail update time entry on workspace for <reason>
    And endpoint /v1/workspaces/<workspaceId>/time-entries/<timeEntryId>
    And header x-api-key = <api-key>
    And generate update request body <updateBody>
    And body {{updateRequestBody}}
    When execute method PUT
    Then the status code should be <status-code>
    And response should be message = <message>
    Examples:
      | reason                                                     | workspaceId              | timeEntryId              | api-key                                          | updateBody                    | status-code | message                                                                                                                                                                                                                                                                                                                                                             |
      | empty workspaceId                                          |                          | 6941cb948d3fba1733ba8ab1 | $(env.base_apikey)                               | without changes               | 404         | No static resource v1/workspaces/time-entries/6941cb948d3fba1733ba8ab1.                                                                                                                                                                                                                                                                                             |
      | incomplete workspaceId                                     | 69061454f3abbe6b4e1013   | 6941cb948d3fba1733ba8ab1 | $(env.base_apikey)                               | without changes               | 403         | Access Denied                                                                                                                                                                                                                                                                                                                                                       |
      | workspaceId that does not contain the time entry to update | 680ab99aaf0c792d89b73fa7 | 6941cb948d3fba1733ba8ab1 | $(env.base_apikey)                               | without changes               | 400         | Entrada de tiempo no pertenece a Espacio de trabajo                                                                                                                                                                                                                                                                                                                 |
      | api-key without permissions                                | 69061454f3abbe6b4e1013a4 | 6941cb948d3fba1733ba8ab1 | MGE5ZTA2NzgtOGYzMi00ZjQzLWE2ZTEtNjBhOGYyYjhiMTJm | without changes               | 403         | Access Denied                                                                                                                                                                                                                                                                                                                                                       |
      | non-existent api-key                                       | 69061454f3abbe6b4e1013a4 | 6941cb948d3fba1733ba8ab1 | 515156sgsafaiu9esf84s48ddsg                      | without changes               | 401         | Api key does not exist                                                                                                                                                                                                                                                                                                                                              |
      | empty time entry Id                                        | 69061454f3abbe6b4e1013a4 |                          | $(env.base_apikey)                               | without changes               | 405         | Request method 'PUT' is not supported                                                                                                                                                                                                                                                                                                                               |
      | non-existent time entry Id                                 | 69061454f3abbe6b4e1013a4 | 000000000000000000000000 | $(env.base_apikey)                               | without changes               | 400         | Entrada de tiempo no pertenece a Espacio de trabajo                                                                                                                                                                                                                                                                                                                 |
      | deleted time entry Id                                      | 69061454f3abbe6b4e1013a4 | 69440b66fbcefd7eee7006b6 | $(env.base_apikey)                               | without changes               | 400         | Entrada de tiempo no pertenece a Espacio de trabajo                                                                                                                                                                                                                                                                                                                 |
      | no body in request                                         | 69061454f3abbe6b4e1013a4 | 6941cb948d3fba1733ba8ab1 | $(env.base_apikey)                               | no body in request            | 400         | Required request body is missing: public com.clockify.adapter.http.v1.dto.TimeEntryDtoImplV1 com.clockify.adapter.http.v1.timeentry.TimeEntryHttpAdapter.update(java.lang.String,java.lang.String,com.clockify.adapter.http.v1.requests.UpdateTimeEntryRequest,java.lang.String,java.lang.String,java.lang.String,com.clockify.adapter.spring.security.CurrentAuth) |
      | body without start key                                     | 69061454f3abbe6b4e1013a4 | 6941cb948d3fba1733ba8ab1 | $(env.base_apikey)                               | without start key             | 400         | Introdujiste un valor no válido para el campo : [start]. Valores que representan [start] no puede ser nulo y no puede estar vacío. Asegúrate de que la fecha [start] no es mayor que 9999-12-31 ni menor que 0001-01-01. Asegúrate de que la fecha de [start] tiene el siguiente formato: "yyyy-MM-ddThh:mm:ssZ" Ejemplo: 2018-11-29T13:00:46Z.                     |
      | body without start hour                                    | 69061454f3abbe6b4e1013a4 | 6941cb948d3fba1733ba8ab1 | $(env.base_apikey)                               | without start hour            | 400         | Introdujiste un valor no válido para el campo : [start]. Valores que representan [start] no puede ser nulo y no puede estar vacío. Asegúrate de que la fecha [start] no es mayor que 9999-12-31 ni menor que 0001-01-01. Asegúrate de que la fecha de [start] tiene el siguiente formato: "yyyy-MM-ddThh:mm:ssZ" Ejemplo: 2018-11-29T13:00:46Z.                     |
      | body without start date                                    | 69061454f3abbe6b4e1013a4 | 6941cb948d3fba1733ba8ab1 | $(env.base_apikey)                               | without start date            | 400         | Introdujiste un valor no válido para el campo : [start]. Valores que representan [start] no puede ser nulo y no puede estar vacío. Asegúrate de que la fecha [start] no es mayor que 9999-12-31 ni menor que 0001-01-01. Asegúrate de que la fecha de [start] tiene el siguiente formato: "yyyy-MM-ddThh:mm:ssZ" Ejemplo: 2018-11-29T13:00:46Z.                     |
      | body with null start value                                 | 69061454f3abbe6b4e1013a4 | 6941cb948d3fba1733ba8ab1 | $(env.base_apikey)                               | with null start value         | 400         | Introdujiste un valor no válido para el campo : [start]. Valores que representan [start] no puede ser nulo y no puede estar vacío. Asegúrate de que la fecha [start] no es mayor que 9999-12-31 ni menor que 0001-01-01. Asegúrate de que la fecha de [start] tiene el siguiente formato: "yyyy-MM-ddThh:mm:ssZ" Ejemplo: 2018-11-29T13:00:46Z.                     |
      | body with invalid start hour value                         | 69061454f3abbe6b4e1013a4 | 6941cb948d3fba1733ba8ab1 | $(env.base_apikey)                               | with invalid start hour value | 400         | Introdujiste un valor no válido para el campo : [start]. Valores que representan [start] no puede ser nulo y no puede estar vacío. Asegúrate de que la fecha [start] no es mayor que 9999-12-31 ni menor que 0001-01-01. Asegúrate de que la fecha de [start] tiene el siguiente formato: "yyyy-MM-ddThh:mm:ssZ" Ejemplo: 2018-11-29T13:00:46Z.                     |
      | body with invalid start date value                         | 69061454f3abbe6b4e1013a4 | 6941cb948d3fba1733ba8ab1 | $(env.base_apikey)                               | with invalid start date value | 400         | Introdujiste un valor no válido para el campo : [start]. Valores que representan [start] no puede ser nulo y no puede estar vacío. Asegúrate de que la fecha [start] no es mayor que 9999-12-31 ni menor que 0001-01-01. Asegúrate de que la fecha de [start] tiene el siguiente formato: "yyyy-MM-ddThh:mm:ssZ" Ejemplo: 2018-11-29T13:00:46Z.                     |

  @FailDeleteTimeEntry @Regression
  Scenario Outline: Fail delete time entry from workspace for <reason>
    And header x-api-key = <api-key>
    And endpoint /v1/workspaces/<workspaceId>/time-entries/<timeEntryId>
    When execute method DELETE
    Then the status code should be <status-code>
    And response should be message = <message>
    Examples:
      | reason                                                     | api-key                                          | workspaceId              | timeEntryId              | status-code | message                                                                 |
      | api-key without permissions                                | MGE5ZTA2NzgtOGYzMi00ZjQzLWE2ZTEtNjBhOGYyYjhiMTJm | 69061454f3abbe6b4e1013a4 | 6941cb948d3fba1733ba8ab1 | 403         | Access Denied                                                           |
      | non-existent api-key                                       | 515156sgsafaiu9esf84s48ddsg                      | 69061454f3abbe6b4e1013a4 | 6941cb948d3fba1733ba8ab1 | 401         | Api key does not exist                                                  |
      | empty workspaceId                                          | $(env.base_apikey)                               |                          | 6941cb948d3fba1733ba8ab1 | 404         | No static resource v1/workspaces/time-entries/6941cb948d3fba1733ba8ab1. |
      | incomplete workspaceId                                     | $(env.base_apikey)                               | 680ab99aaf0c792d89b73    | 6941cb948d3fba1733ba8ab1 | 403         | Access Denied                                                           |
      | workspaceId that does not contain the time entry to delete | $(env.base_apikey)                               | 680ab99aaf0c792d89b73fa7 | 6941cb948d3fba1733ba8ab1 | 400         | Entrada de tiempo no pertenece a Espacio de trabajo                     |
      | empty time entry Id                                        | $(env.base_apikey)                               | 69061454f3abbe6b4e1013a4 |                          | 405         | Request method 'DELETE' is not supported                                |
      | non-existent time entry Id                                 | $(env.base_apikey)                               | 69061454f3abbe6b4e1013a4 | 000000000000000000000000 | 400         | Entrada de tiempo no pertenece a Espacio de trabajo                     |
      | already deleted time entry Id                              | $(env.base_apikey)                               | 69061454f3abbe6b4e1013a4 | 69440b66fbcefd7eee7006b6 | 400         | Entrada de tiempo no pertenece a Espacio de trabajo                     |
