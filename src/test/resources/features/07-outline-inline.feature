@smoke
Feature: 07 - Data Driven sin CSV para comparar los enfoques

  Background:
    * url baseUrl

  Scenario Outline: Consultar el estado <estado> con una tabla inline
    Given path 'pet', 'findByStatus'
    And param status = '<estado>'
    When method get
    Then status 200
    And match response == '#[]'

    Examples:
      | estado    |
      | available |
      | sold      |
