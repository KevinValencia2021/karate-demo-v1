@regression @post @request-archivo
Feature: 04 - POST con request JSON y headers JSON externos

  Background:
    * url baseUrl

  Scenario: Crear mascota usando archivos externos reutilizables
    * def mascotaId = 700000000000 + Math.floor(Math.random() * 1000000000)
    * def nombreMascota = 'Curso-Archivo-' + mascotaId

    # Primero se definen las variables; despues se lee la plantilla.
    * def cuerpo = read('classpath:data/requests/crear-mascota.json')
    * def cabeceras = read('classpath:data/headers/headers-petstore.json')

    Given path 'pet'
    And headers cabeceras
    And request cuerpo
    When method post
    Then status 200
    And match response.id == mascotaId
    And match response.name == nombreMascota

    Given path 'pet', mascotaId
    When method get
    Then status 200
    And match response.name == nombreMascota

    # La eliminacion reduce los efectos sobre el ambiente compartido.
    Given path 'pet', mascotaId
    When method delete
    Then status 200
