@regression
Feature: 08 - Ciclo CRUD: POST, GET, PUT y DELETE

  Background:
    * url baseUrl

  Scenario: Crear, leer, actualizar y eliminar una mascota
    * def mascotaId = 700000000000 + Math.floor(Math.random() * 1000000000)
    * def nombreMascota = 'Curso-CRUD-' + mascotaId
    * def cuerpo = read('classpath:data/requests/crear-mascota.json')

    # CREATE
    Given path 'pet'
    And request cuerpo
    When method post
    Then status 200

    # READ
    Given path 'pet', mascotaId
    When method get
    Then status 200
    And match response.id == mascotaId

    # UPDATE: reutiliza la plantilla, cambia propiedades en memoria.
    * set cuerpo.name = 'Curso-Actualizado-' + mascotaId
    * set cuerpo.status = 'sold'
    Given path 'pet'
    And request cuerpo
    When method put
    Then status 200
    And match response.name == cuerpo.name

    # Verificar que GET devuelva el dato modificado.
    Given path 'pet', mascotaId
    When method get
    Then status 200
    And match response contains { status: 'sold' }

    # DELETE
    Given path 'pet', mascotaId
    When method delete
    Then status 200
