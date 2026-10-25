# Karate DSL 1.4.1 + Java 17 + Petstore 3

Proyecto Maven educativo, preparado para abrir en **IntelliJ IDEA** y enseñar automatización REST **desde cero**. Incluye ejemplos comentados en español, archivos de datos y dos modos de ejecución para no modificar el servicio público durante las primeras clases.

> Versiones **fijas**: JDK 17, Karate `1.4.1`, Maven (recomendado `3.9.x`), JUnit 5. No se ha sustituido Karate 1.4.1 por versiones 1.5/2.x.

## 1. Requisitos

- JDK **17** instalado; seleccionarlo también como **Project SDK** y **Maven Runner JRE** en IntelliJ.
- IntelliJ IDEA Community o Ultimate con soporte Maven. Puedes usar el **Maven incluido en IntelliJ**, aunque `mvn` no funcione en tu terminal.
- Internet para descargar dependencias (la primera vez) y acceder a Petstore.
- Opcional: Maven instalado para usar `mvn` o `mvn.cmd` fuera de IntelliJ.

**Atención:** Karate 1.4.1 es compatible con JDK 17. Evita usar JDK 22+ con esta versión.

## 2. Abrir en IntelliJ (paso a paso)

1. Descomprime el ZIP y abre la carpeta **`karate-petstore-java17-1.4.1`**, NO la carpeta `src`.
2. Cuando IntelliJ detecte `pom.xml`, elige **Load Maven Project**. Si no aparece, clic derecho sobre `pom.xml` > **Add as Maven Project**.
3. Ve a **File > Project Structure > Project**: selecciona **SDK = JDK 17**. Verifica **Language level = 17**.
4. Ve a **Settings > Build, Execution, Deployment > Build Tools > Maven > Runner**: configura **JRE = JDK 17**.
5. En **Settings > Build Tools > Maven**, selecciona la **Bundled Maven** (Maven incluido) si `mvn` no está en PATH.
6. En la ventana **Maven** (lateral derecho), pulsa **Reload All Maven Projects** para descargar dependencias.
7. Abre `src/test/java/pe/edu/qa/PetstoreTest.java`. Haz clic en el triángulo verde junto a `pruebasRapidas()` para ejecutar.
8. Abre el reporte generado en **`target/karate-reports/karate-summary.html`** y revisa pasos, peticiones y respuestas.

### Si no funcionan `java` o `mvn` en CMD/PowerShell

Esto **no implica necesariamente** que Java o Maven falten. Puede que no estén configurados en el PATH. Con IntelliJ puedes ejecutar usando JDK 17 y Maven integrados. Si deseas usar consola, comprueba `java -version` y `mvn -version`; consulta `docs/GUIA-CLASE.md` para las correcciones y `scripts/diagnostico-windows.ps1` para revisar el entorno.

## 3. Ejecutar desde consola

Abre la terminal en el **mismo directorio que contiene `pom.xml`**.

```powershell
# Todas las pruebas de lectura (@smoke), sin escritura en Petstore:
mvn test

# Las pruebas que crean/modifican/eliminan recursos (@regression):
mvn test -Dtest=PetstoreRegression

# Consultas simultaneas: 3 hilos; solo @smoke:
mvn test -Dtest=PetstoreParallel

# Ejecucion apuntando a Petstore local (opcional):
mvn test "-DbaseUrl=http://localhost:8080/api/v3"

# Mostrar JDK y Maven utilizados por consola:
java -version
mvn -version
```

Si estás en IntelliJ sin `mvn` en PATH: ventana lateral **Maven > Lifecycle > test** para pruebas smoke; para regresión, ejecuta el método de `PetstoreRegression.java` mediante clic derecho/Run (o configura el goal `test -Dtest=PetstoreRegression` desde Maven).

**Importante:** `mvn test` SOLO ejecuta el runner `PetstoreTest.java`; los otros runners no terminan en `Test` y se invocan por separado. El runner de regresión no se dispara por accidente.

## 4. Estructura y qué enseña cada archivo

```text
karate-petstore-java17-1.4.1/
├─ pom.xml                               Dependencias y Java 17
├─ README.md                             Guía de instalación
├─ docs/
│  ├─ GUIA-CLASE.md                      Temario paso a paso y ejercicios
│  └─ BUENAS-PRACTICAS.md                Convenciones, contratos y límites
├─ scripts/diagnostico-windows.ps1       Ayuda para diagnosticar Java/Maven
└─ src/test/
   ├─ java/pe/edu/qa/
   │  ├─ PetstoreTest.java               Runner smoke (mvn test)
   │  ├─ PetstoreRegression.java         Runner de escritura explícita
   │  └─ PetstoreParallel.java           Paralelismo de consultas
   └─ resources/
      ├─ karate-config.js                URL base y timeouts
      ├─ features/
      │  ├─ 01-primer-get.feature        GET, query params, match
      │  ├─ 02-headers.feature           Header inline / archivo JSON
      │  ├─ 03-request-inline.feature    POST con request en el feature
      │  ├─ 04-request-archivo.feature   POST leyendo JSON externo
      │  ├─ 05-validar-esquema.feature   Esquemas y tipos de datos
      │  ├─ 06-csv.feature               CSV con Scenario Outline dinámico
      │  ├─ 07-outline-inline.feature    Tabla Examples normal
      │  ├─ 08-crud-completo.feature     POST, GET, PUT, DELETE
      │  └─ 09-negativos-opcional.feature Ejemplo 404 (@manual)
      └─ data/
         ├─ headers/headers-petstore.json
         ├─ requests/crear-mascota.json
         ├─ schemas/mascota-schema.json
         └─ csv/estados-mascotas.csv
```

## 5. Código esencial explicado

```gherkin
@smoke
Feature: Mi primer GET
  Background:
    * url baseUrl
  Scenario: Consultar mascotas por estado
    Given path 'pet', 'findByStatus'
    And param status = 'available'
    When method get
    Then status 200
    And match response == '#[]'
```

`baseUrl` proviene de `karate-config.js`; `path` ensambla la ruta, `param` incorpora `?status=available`, `method` ejecuta HTTP, `status` compara código y `match` valida la respuesta.

```gherkin
# Headers dentro del mismo feature
And header Accept = 'application/json'

# Headers de archivo JSON
* def cabeceras = read('classpath:data/headers/headers-petstore.json')
And headers cabeceras

# Request desde archivo (con placeholders #(variable))
* def mascotaId = 700000000000 + Math.floor(Math.random() * 1000000000)
* def nombreMascota = 'Prueba-' + mascotaId
* def cuerpo = read('classpath:data/requests/crear-mascota.json')
And request cuerpo
```

**JSON schema en Karate 1.4.1:** `#string`, `#number`, `#[] #string`, `#regex ...` son validadores integrados, no una validación formal automática del JSON Schema Draft. Para validar la respuesta comparas contra la plantilla en `data/schemas/mascota-schema.json`.

**CSV:** `read('classpath:data/csv/estados-mascotas.csv')` convierte columnas a objetos; usado en `Examples:` ejecuta un escenario por cada fila del archivo.

## 6. Petstore: precauciones de ambiente de demostración

- Servidor: **https://petstore3.swagger.io/api/v3** (OpenAPI 3; no confundir con `https://petstore.swagger.io/v2`).
- La API es **pública y compartida**: una prueba puede crear datos que otros usuarios editen o borren. Por eso `@smoke` NO escribe; `@regression` sí escribe y necesita limpieza.
- Los tests CRUD eliminan el recurso después de validarlo, pero si un paso falla antes del DELETE pueden dejar datos residuales.
- Un fallo intermitente HTTP no significa necesariamente un error del código; comprueba el reporte, la respuesta real y el estado de Petstore.
- Nunca envíes contraseñas, tokens reales ni datos personales a la API pública.
- Para talleres grandes es preferible levantar **una instancia de Petstore local** en Docker y usar `-DbaseUrl=http://localhost:8080/api/v3`. Verifica la disponibilidad de la imagen elegida en tu entorno.

## 7. Documentación de referencia

- Petstore 3: https://petstore3.swagger.io/
- Código / definición OpenAPI de Petstore: https://github.com/swagger-api/swagger-petstore
- Karate v1.4.1: https://github.com/karatelabs/karate/tree/v1.4.1
- Maven Central, Karate 1.4.1: https://central.sonatype.com/artifact/com.intuit.karate/karate-junit5/1.4.1

Lee `docs/GUIA-CLASE.md` para la secuencia sugerida de enseñanza y prácticas guiadas.
