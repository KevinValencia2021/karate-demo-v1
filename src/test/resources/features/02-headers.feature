@smoke
Feature: 02 - Enviar headers en el feature y desde un JSON externo

  Background:
    * url baseUrl

  Scenario: Definir headers directamente en el archivo feature
    Given path 'pet', 'findByStatus'
    And param status = 'pending'
    # Header individual: ideal cuando solo un escenario necesita este valor.
    And header Accept = 'application/json'
    And header X-Curso = 'Karate-Desde-Cero'
    When method get
    Then status 200
    And match response == '#[]'

  Scenario: Cargar multiples headers desde un archivo JSON
    # Es mas facil mantener headers comunes en un recurso reutilizable.
    * def cabeceras = read('classpath:data/headers/headers-petstore.json')
    Given path 'pet', 'findByStatus'
    And param status = 'sold'
    And headers cabeceras
    When method get
    Then status 200
    And match response == '#[]'
    # NOTA: no afirmamos que X-Curso se refleje en la respuesta; la API no promete eco.
