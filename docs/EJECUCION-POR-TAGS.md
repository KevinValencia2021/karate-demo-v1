# Guía práctica: ejecutar Karate DSL 1.4.1 por tags

Este proyecto usa **un runner principal dinámico**: `src/test/java/pe/edu/qa/PetstoreTest.java`.
No necesitas modificarlo ni elegir cada archivo `.feature` para cambiar qué ejecutar.

## 1. ¿Dónde se escriben los tags?

**Nivel de Feature**: lo heredan todos sus escenarios.

```gherkin
@smoke @headers
Feature: Validar headers de Petstore

  @headers-inline
  Scenario: Header directo
    # ...

  @headers-archivo
  Scenario: Headers desde JSON
    # ...
```

El primer escenario tiene `@smoke`, `@headers`, `@headers-inline`.
El segundo tiene `@smoke`, `@headers`, `@headers-archivo`.

## 2. Ejecutar usando Maven (Windows PowerShell o CMD)

Sitúate en el directorio que contiene `pom.xml`.

```powershell
# Seleccion por defecto (sin propiedad): @smoke
mvn test

# Todos los ejemplos de headers, incluso en archivos distintos
mvn test "-DtestTags=@headers"

# SOLO el escenario de headers cargados desde JSON
mvn test "-DtestTags=@headers-archivo"

# Ejemplos con archivo CSV (uno local + outline con llamadas HTTP)
mvn test "-DtestTags=@csv"

# Pruebas con JSON schema (modifican datos en el Petstore publico)
mvn test "-DtestTags=@schema"

# CRUD completo (POST, GET, PUT, DELETE)
mvn test "-DtestTags=@crud"

# TODA la regresion (escritura / eliminacion en Petstore)
mvn test "-DtestTags=@regression"

# Pruebas completamente locales: permiten probar el reporte sin Internet
mvn test "-DtestTags=@local"

# Filtro alternativo nativo de Karate 1.x; tambien sirve
mvn test "-Dkarate.options=--tags @csv"
```

**Importante:** el ultimo ejemplo utiliza `karate.options`, una opción propia de Karate;
`testTags` es la propiedad sencilla que implementamos en este curso. Si usas ambas,
puede prevalecer la configuración nativa; usa **solo una por ejecución**.

## 3. Ejecutar por tags en IntelliJ SIN usar `mvn` en la terminal

1. Abre `PetstoreTest.java`.
2. Ve a **Run > Edit Configurations** y selecciona el runner de JUnit para `PetstoreTest`.
3. En **VM options** coloca `-DtestTags=@csv` (puedes pulsar *Modify options* para mostrar el campo).
4. Pulsa **Apply > Run**.
5. Cambia a `-DtestTags=@headers`, `-DtestTags=@local`, etc., y vuelve a ejecutar.

**No utilices Program arguments** para `-DtestTags`: es una propiedad de la JVM.

Si creas una configuración de ejecución **Maven** en IntelliJ, escribe en `Run` (goals):

```text
test -DtestTags=@csv
```

Esta ejecución utilizará el Maven incluido en IntelliJ aunque `mvn` no aparezca en PATH.

## 4. Etiquetas disponibles

| Tag | Qué selecciona | Conexión / efecto |
| --- | --- | --- |
| `@smoke` | GET, headers, CSV y validaciones introductorias | Mayormente GET |
| `@headers` | Ambas formas de enviar headers | GET |
| `@headers-inline` | Header escrito en el escenario | GET |
| `@headers-archivo` | Headers desde JSON | GET |
| `@csv` | Lectura local y Scenario Outline CSV | Local + GET |
| `@csv-api` | Solo el Scenario Outline de CSV | GET |
| `@csv-local` | Lectura local de CSV en distintos features | Sin Internet |
| `@outline` | Examples con tabla dentro del feature | GET |
| `@post` | POST inline, POST con archivo, POST con esquema | **Escribe** |
| `@request-inline` | POST con JSON en el feature | **Escribe** |
| `@request-archivo` | POST con JSON externo | **Escribe** |
| `@schema` | Validacion de esquema tras POST | **Escribe** |
| `@crud` | Crear, leer, actualizar y borrar | **Escribe** |
| `@regression` | Todos los escenarios de escritura | **Escribe** |
| `@local` | Dos escenarios del archivo de reporte local | Sin Internet |
| `@manual` | Laboratorio negativo opcional | GET, 404 esperado |
| `@get` | Escenarios identificados como lectura HTTP | GET |
| `@basico` | Primeros ejemplos de Karate | GET + local |
| `@sin-api` | Validaciones introductorias y de reporte | Sin Internet |

También están disponibles `@negativo`, `@validacion-local` y `@json` solo si agregas ese último a tu propio ejercicio.

## 5. Reportes HTML y errores frecuentes

Todos los filtros de `PetstoreTest.java` producen reportes en la **misma carpeta**:

```text
target/karate-reports/karate-summary.html
```

En cada ejecución se actualiza el reporte; el resumen siempre corresponde al **último filtro ejecutado**.
En el log puedes ver `TAGS KARATE SELECCIONADOS: @csv` antes del resultado.
Si un filtro no coincide con ningún escenario, el runner falla explícitamente para que no parezca una ejecución exitosa vacía.

No ejecutes concurrentemente dos instancias del mismo runner sobre `target/karate-reports`:
se podrían sobrescribir los resultados.

### Ejercicios para alumnos

1. Ejecuta `@headers` y cuenta cuántos escenarios coinciden.
2. Ejecuta `@headers-inline`; comprueba que solo queda uno.
3. Ejecuta `@csv-local` sin conexión a Internet; valida la generación de HTML.
4. Añade el tag `@mi-prueba` a un `Scenario` y ejecuta `mvn test "-DtestTags=@mi-prueba"`.
5. Explica por qué `@regression` puede tener efectos sobre el ambiente público.
