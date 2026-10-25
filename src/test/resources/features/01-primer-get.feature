@smoke
Feature: 01 - Mi primera prueba GET con Karate DSL
  # Meta: comprender Given, When, Then, path, param y match.

  Background:
    # baseUrl proviene de src/test/resources/karate-config.js
    * url baseUrl

  Scenario: Consultar mascotas disponibles
    Given path 'pet', 'findByStatus'
    # Agrega ?status=available a la URL sin concatenar cadenas.
    And param status = 'available'
    When method get
    Then status 200
    # Se valida la forma general sin depender de datos ajenos.
    And match response == '#[]'
    # El tipo de contenido devuelto debe ser JSON.
    And match header Content-Type contains 'json'

  Scenario: Practicar validaciones basicas sin depender de una API
    * def ejemplo = { id: 101, name: 'Firulais', status: 'available', photoUrls: [] }
    * match ejemplo.id == 101
    * match ejemplo.name == '#string'
    * match ejemplo contains { status: 'available' }
    * match ejemplo.photoUrls == '#[]'
    # Estos matches son deterministas y ayudan a ensenar assertions.
