@smoke @csv
Feature: 06 - Data Driven Testing con archivos CSV
  # El encabezado del CSV define las variables disponibles en Examples.

  Background:
    * url baseUrl

  @csv-local
  Scenario: Leer el CSV como un arreglo de objetos JSON
    * def filas = read('classpath:data/csv/estados-mascotas.csv')
    * match filas == '#[3]'
    * match filas[0].estado == 'available'
    # No se realiza ninguna llamada HTTP en este escenario.

  @csv-api @get
  Scenario Outline: Consultar mascotas con estado <estado>
    Given path 'pet', 'findByStatus'
    # Los valores del CSV se leen como texto; por eso van entre comillas.
    And param status = '<estado>'
    When method get
    Then status 200
    And match response == '#[]'
    * print 'Fila que se esta ejecutando:', __row

    # Cada fila del CSV genera una ejecucion independiente.
    Examples:
      | read('classpath:data/csv/estados-mascotas.csv') |
