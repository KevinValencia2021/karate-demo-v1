# Karate DSL 1.4.1 + Java 17 + Petstore 3

## Ejecutar por tags (actualización v3)

**`PetstoreTest.java` ahora filtra dinámicamente todos los archivos `.feature` por tag.**
No es necesario seleccionar un archivo específico o editar el código Java.

```powershell
mvn test                           # Por defecto: @smoke
mvn test "-DtestTags=@headers"      # Ambos escenarios de headers
mvn test "-DtestTags=@csv"          # Todos los ejemplos CSV
mvn test "-DtestTags=@schema"       # Contratos JSON (escribe datos)
mvn test "-DtestTags=@regression"   # Todos los escenarios de escritura
mvn test "-DtestTags=@local"        # Reportes sin Internet
```

Desde IntelliJ: ejecuta `PetstoreTest.java` con **VM options** `-DtestTags=@csv`.
Los reportes siguen generándose en `target/karate-reports/karate-summary.html`.
**Guía completa y tabla de etiquetas:** `docs/EJECUCION-POR-TAGS.md`.


Proyecto Maven educativo, preparado para abrir en **IntelliJ IDEA** y enseñar automatización REST **desde cero**. Incluye ejemplos comentados en español, archivos de datos y runners independientes con reportes HTML reproducibles.

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
7. Abre `src/test/java/pe/edu/qa/PetstoreTest.java`. Haz clic en el triángulo verde junto a `ejecutar()` para ejecutar.
8. Abre el reporte generado en **`target/karate-reports/karate-summary.html`** y revisa pasos, peticiones y respuestas.

### Si no funcionan `java` o `mvn` en CMD/PowerShell

Esto **no implica necesariamente** que Java o Maven falten. Puede que no estén configurados en el PATH. Con IntelliJ puedes ejecutar usando JDK 17 y Maven integrados. Si deseas usar consola, comprueba `java -version` y `mvn -version`; consulta `docs/GUIA-CLASE.md` para las correcciones y `scripts/diagnostico-windows.ps1` para revisar el entorno.

## Reportes HTML siempre al finalizar una ejecucion (revision v2)

Los 4 runners Java utilizan **Runner.path(...).parallel(N)** de Karate 1.4.1 dentro
un test JUnit 5. Esta API genera un resumen HTML al terminar la suite, antes de
que la asercion de JUnit marque fallida una ejecucion por errores HTTP/SSL.
La clase tambien **verifica que el archivo del reporte exista**.

| Runner (clic derecho > Run) | Filtra | Reporte HTML |
| --- | --- | --- |
| `PetstoreTest` | dinámico (`@smoke` por defecto, `-DtestTags=@...`) | `target/karate-reports/karate-summary.html` |
| `PetstoreRegression` | `@regression` | `target/karate-reports-regression/karate-summary.html` |
| `PetstoreParallel` | `@smoke`, 3 hilos | `target/karate-reports-parallel/karate-summary.html` |
| `PetstoreLocalReport` | `@local`, sin Internet | `target/karate-reports-local/karate-summary.html` |

**Por que antes parecia generarse solo una vez:** Karate escribe el resumen
cuando el runner finaliza la suite. Si IntelliJ vuelve a ejecutar un unico
escenario aislado, se cancela la ejecucion antes del final, se abre un reporte
antiguo, o se mira otro directorio, puede parecer que no se ha actualizado.
No es posible determinar cual caso concreto ocurrio sin el log de tu ejecucion.
Los runners nuevos fuerzan la finalizacion explicita de la suite y usan rutas
claras y separadas. No ejecutes dos runners simultaneamente sobre la MISMA carpeta.

Karate 1.4.1 hace una copia del reporte anterior cuando vuelve a ejecutar una
suite en la misma carpeta; el reporte mas reciente conserva el nombre fijo
`karate-summary.html`. **No abras el directorio de copia `_timestamp` por error.**

### Comprobacion sin depender de Internet

1. Ejecuta `PetstoreLocalReport.java` desde IntelliJ.
2. Abre `target/karate-reports-local/karate-summary.html`.
3. Comprueba que aparecen dos escenarios aprobados y la fecha de modificacion cambia.
4. Ejecutalo una segunda vez: el reporte actual se regenera y el anterior se archiva.
5. Ahora ejecuta `PetstoreTest.java`; debe aparecer el reporte `target/karate-reports/karate-summary.html` incluso si Petstore presenta un fallo de red/SSL durante un escenario.

PowerShell, desde el directorio que contiene `pom.xml`:

```powershell
mvn test -Dtest=PetstoreLocalReport
mvn test -Dtest=PetstoreTest
mvn test -Dtest=PetstoreRegression
mvn test -Dtest=PetstoreParallel

# Abre directamente el reporte correspondiente a cada runner:
.\scripts\abrir-reporte.ps1 -Tipo local
.\scripts\abrir-reporte.ps1 -Tipo smoke
```

**Importante:** `mvn clean` borra `target/` por completo, incluidos sus reportes.
Vuelve a ejecutar las pruebas antes de abrir `karate-summary.html`.

### Si tambien aparece `SSLHandshakeException: PKIX path building failed`

No confundas un fallo HTTPS con la generacion del reporte. El reporte debe
registrar el fallo de la llamada HTTP y el runner debe terminar como fallido.
La correccion segura consiste en configurar el truststore de Java 17 con la
CA apropiada tras verificar la cadena SSL. Solo como diagnostico temporal, si
la red es confiable y tienes permiso para omitir la validacion:

```powershell
mvn test -Dtest=PetstoreTest -DsslTrustAll=true
```

En IntelliJ, incluye `-DsslTrustAll=true` como propiedad de VM en la configuracion
de ejecucion cuando no usas el comando Maven. **No usar en produccion ni CI.**

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

**Importante:** `mvn test` ejecuta `PetstoreTest.java` (`@smoke` por defecto, configurable mediante `-DtestTags`). Los otros runners no terminan en `Test` y se ejecutan explicitamente. Asi la regresion no se dispara por accidente.

## 4. Estructura y qué enseña cada archivo

```text
karate-petstore-java17-1.4.1/
├─ pom.xml                               Dependencias y Java 17
├─ README.md                             Guía de instalación
├─ docs/
│  ├─ GUIA-CLASE.md                      Temario paso a paso y ejercicios
│  └─ BUENAS-PRACTICAS.md                Convenciones, contratos y límites
├─ scripts/diagnostico-windows.ps1       Ayuda para diagnosticar Java/Maven
├─ scripts/abrir-reporte.ps1             Abre resumen HTML y muestra fecha
└─ src/test/
   ├─ java/pe/edu/qa/
   │  ├─ PetstoreTest.java               Runner smoke (mvn test)
   │  ├─ PetstoreRegression.java         Runner de escritura explícita
   │  ├─ PetstoreParallel.java           Paralelismo de consultas
   │  └─ PetstoreLocalReport.java        Diagnostico de reportes offline
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
      │  ├─ 09-negativos-opcional.feature Ejemplo 404 (@manual)
      │  └─ 10-reporte-local.feature     Diagnostico offline (@local)
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
