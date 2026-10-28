@regression @post @schema
Feature: 05 - Validar estructura y tipos de una respuesta JSON

  Background:
    * url baseUrl

  Scenario: Crear mascota y validar la respuesta con un esquema externo
    * def mascotaId = 700000000000 + Math.floor(Math.random() * 1000000000)
    * def nombreMascota = 'Curso-Schema-' + mascotaId
    * def cuerpo = read('classpath:data/requests/crear-mascota.json')
    * def esquema = read('classpath:data/schemas/mascota-schema.json')

    Given path 'pet'
    And header Content-Type = 'application/json'
    And request cuerpo
    When method post
    Then status 200

    # contains admite campos extra; match == exigiria contrato exacto.
    And match response contains esquema
    And match response.id == mascotaId
    And match response.name == nombreMascota
    And match response.photoUrls == '#[] #string'
    # Validacion de un subconjunto de la respuesta, de forma independiente.
    And match response contains { status: 'available', category: { id: 1, name: 'Perros' } }

    Given path 'pet', mascotaId
    When method delete
    Then status 200
