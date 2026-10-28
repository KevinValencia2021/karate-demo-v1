@local @sin-api
Feature: 10 - Validaciones locales para verificar la generacion del reporte
  # Este feature NO utiliza Internet y NO depende del certificado de Petstore.
  # Si aparece su reporte HTML, el mecanismo de reportes funciona.

  @validacion-local
  Scenario: Validar un JSON local
    * def mascota = { id: 42, name: 'Demo', status: 'available' }
    * match mascota.id == '#number'
    * match mascota.name == '#string'
    * match mascota contains { status: 'available' }

  @csv-local
  Scenario: Leer datos CSV locales
    * def estados = read('classpath:data/csv/estados-mascotas.csv')
    * match estados == '#[3]'
    * match estados[0].estado == 'available'
