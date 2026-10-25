@regression
Feature: 03 - POST con JSON definido directamente dentro del feature
  # Crea datos de demostracion en un servidor publico: ejecutar con criterio.

  Background:
    * url baseUrl

  Scenario: Crear una mascota con un request inline y consultar el resultado
    # ID de laboratorio aleatorio para reducir choques con otros alumnos.
    * def mascotaId = 700000000000 + Math.floor(Math.random() * 1000000000)
    * def nombreMascota = 'Curso-Inline-' + mascotaId

    Given path 'pet'
    And header Accept = 'application/json'
    And header Content-Type = 'application/json'
    # #(variable) sustituye variables de Karate dentro de un JSON.
    And request
      """
      {
        "id": "#(mascotaId)",
        "name": "#(nombreMascota)",
        "category": { "id": 1, "name": "Perros" },
        "photoUrls": ["https://example.org/curso.png"],
        "tags": [{ "id": 1, "name": "formacion" }],
        "status": "available"
      }
      """
    When method post
    Then status 200
    And match response contains { id: '#(mascotaId)', name: '#(nombreMascota)' }

    # Una segunda llamada comprueba que el recurso es consultable.
    Given path 'pet', mascotaId
    When method get
    Then status 200
    And match response.name == nombreMascota

    # Limpieza de datos creados durante la prueba.
    Given path 'pet', mascotaId
    When method delete
    Then status 200
