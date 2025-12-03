@Projects
Feature: Projects in Clockify

  Background:
    And header Content-Type = application/json
    And header Accept = */*
    And header x-api-key = NjliOWFiYmUtMzc2ZC00Zjg2LWJhYzUtNWIzOTE1ZjlkYmIz

  @AddNewProject
  Scenario: Add a new project.
    Given base url https://api.clockify.me/api
    And endpoint /v1/workspaces/680ab99aaf0c792d89b73fa7/projects
    And body jsons/bodies/bodyAddProject.json
    When execute method POST
    Then the status code should be 201
    And response should be name = Proyecto BAT
    And validate schema jsons/schemas/addProject.json
    * define projectId = $.id

  @FindProjectById
  Scenario: Find project by ID.
    Given base url https://api.clockify.me/api
    And endpoint /v1/workspaces/680ab99aaf0c792d89b73fa7/projects/681949a23e62a459a1c6ea96
    When execute method GET
    Then the status code should be 200
    And response should be name = reportes de errores
    * print response

  @UpdateProject
    Scenario: Update project on workspace
    Given call ClockifyProject.feature@AddNewProject
    And base url https://api.clockify.me/api
    And endpoint /v1/workspaces/680ab99aaf0c792d89b73fa7/projects/{{projectId}}
    And body jsons/bodies/bodyUpdateProject.json
    When execute method PUT
    Then the status code should be 200
    And response should be name = Proyecto archivado

  @DeleteProject
  Scenario: Delete project from workspace
    Given call ClockifyProject.feature@UpdateProject
    And base url https://api.clockify.me/api
    And endpoint /v1/workspaces/680ab99aaf0c792d89b73fa7/projects/{{projectId}}
    When execute method DELETE
    Then the status code should be 200

  Scenario Outline: Get character
    Given base url $(env.base_url_rickAndMorty)
    And endpoint character/<id_character>
    When execute method GET
    Then the status code should be 200
    And response should be $.name = <name>
    And response should be $.status = <status>
    And validate schema jsons/schemas/character.json

    Examples:
      | id_character | name         | status |
      | 1            | Rick Sanchez | Alive  |
      | 2            | Morty Smith  | Alive  |

  @petstore
  Scenario Outline: Add a new pet to the store
    Given base url $(env.base_url_petstore)
    And endpoint pet
    And header accept = application/json
    And header Content-Type = application/json
    And body jsons/bodies/body.json
    When execute method POST
    Then the status code should be 200
    And response should be name = <name>
    And validate schema jsons/schemas/pet.json

    Examples:
      | name   |
      | doggie |

  @petstore
  Scenario Outline: Add a new pet to the store
    Given base url $(env.base_url_petstore)
    And endpoint pet
    And header accept = application/json
    And header Content-Type = application/json
    And delete keyValue tags[0].id in body jsons/bodies/body2.json
    And set value 15 of key tags[1].id in body jsons/bodies/body2.json
    And set value "tag2" of key tags[1].name in body jsons/bodies/body2.json
    When execute method POST
    Then the status code should be 200
    And response should be name = <name>
    And validate schema jsons/schemas/pet.json

    Examples:
      | name   |
      | doggie |

      

  
