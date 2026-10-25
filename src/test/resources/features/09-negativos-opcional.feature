@manual
Feature: 09 - Laboratorio opcional: codigo de error en una consulta
  # Este caso puede variar entre versiones del servidor de demostracion.

  Background:
    * url baseUrl

  Scenario: Consultar una mascota inexistente
    Given path 'pet', 899999999999999
    When method get
    Then status 404
    # No validar el texto literal del error sin que sea parte del contrato.
