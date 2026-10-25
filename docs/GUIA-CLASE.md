# Guía para dictar Karate DSL desde cero

**Stack:** JDK 17 + Maven + Karate 1.4.1 + Petstore 3.  
**Público:** alumnos sin experiencia en Karate; se asume noción básica de HTTP.  
**Duración sugerida:** 2 sesiones de 90 minutos o una sesión de 3 horas con descansos.

## Antes de la clase: checklist del instructor

1. Revisar Java 17: `java -version`; Maven: `mvn -version` (o Maven integrado en IntelliJ).
2. Cargar `pom.xml` y descargar dependencias antes de compartir pantalla.
3. Abrir Swagger UI de Petstore 3 y enseñar el contrato y los métodos.
4. Ejecutar solo `PetstoreTest.java` para verificar que los GET están disponibles.
5. Si hay fallos de red, demostrar validaciones locales del archivo `01-primer-get.feature`.
6. Para un grupo numeroso, evitar ejecutar CRUD contra el servidor compartido de forma simultánea; considerar un Petstore local por equipo.

## Clase 1 — Conceptos y primera automatización (90 minutos)

| Bloque | Min | Material | Objetivo |
| --- | ---: | --- | --- |
| HTTP + Swagger | 15 | Petstore Swagger UI | Recursos, URL, path, query, códigos 2xx/4xx |
| Maven + estructura | 15 | `pom.xml`, `karate-config.js`, runners | Qué hace JDK, dependencia, archivo feature |
| Primer GET | 20 | `01-primer-get.feature` | `Given/When/Then`, `path`, `param`, `status`, `match` |
| Headers | 15 | `02-headers.feature` | Headers inline y desde JSON |
| Data Driven | 20 | `06-csv.feature`, `07-outline-inline.feature` | `Scenario Outline`, `Examples` y CSV |
| Repaso | 5 | reporte HTML | Diagnosticar por pasos y evidencias |

**Actividad A (GET):** cambiar el estado de consulta de `available` a `pending`, ejecutar y comprobar `status 200`. Antes, explicar por qué no se debe asegurar cantidad de mascotas.

**Actividad B (Headers):** añadir `X-Grupo: Grupo-01` dentro del feature; luego hacerlo en `headers-petstore.json`. Los headers del request se observan en el reporte.

**Actividad C (CSV):** agregar una fila válida al CSV y verificar que `Scenario Outline` construya la cantidad correspondiente de casos. Actualiza el `match filas == '#[3]'` del ejemplo de lectura local si agregas filas.

## Clase 2 — Requests, contratos y buenas prácticas (90 minutos)

| Bloque | Min | Material | Objetivo |
| --- | ---: | --- | --- |
| Enviar POST | 20 | `03-request-inline.feature` | JSON, placeholders, headers y status |
| Externalizar request | 15 | `04-request-archivo.feature` | `read()` y datos separados |
| Validación de esquema | 20 | `05-validar-esquema.feature` | `#number`, `#string`, `#regex`, `contains` |
| CRUD completo | 20 | `08-crud-completo.feature` | Crear, obtener, editar, eliminar |
| Runners, tags y reportes | 15 | runners y `target/karate-reports` | `@smoke`, `@regression`, aislamiento |

**Actividad D (Request):** editar la categoría del archivo externo, enviar petición y validar el valor devuelto.

**Actividad E (Schema):** hacer fallar intencionalmente una validación `#number` al cambiarla por `#string` para el ID; leer en el reporte la diferencia `actual` vs `expected`; luego restaurar.

**Actividad F (CRUD):** agregar la validación de que, tras el PUT, el nombre cambió y `status` sea `sold`.

## Miniglosario

| Elemento | Función | Ejemplo |
| --- | --- | --- |
| `Feature:` | Agrupa escenarios de una funcionalidad | `Feature: Consulta de mascotas` |
| `Background:` | Pasos comunes repetidos en cada escenario | `* url baseUrl` |
| `Scenario:` | Caso de prueba independiente | `Scenario: GET ...` |
| `Given` | Preparación de petición | `Given path 'pet', 123` |
| `And` | Continuación de pasos | `And header Accept = ...` |
| `When` | Ejecución | `When method get` |
| `Then` | Verificación | `Then status 200` |
| `match` | Aserción / contrato | `match response.id == '#number'` |
| `read()` | Lee JSON, CSV y otros archivos | `read('classpath:data/...')` |
| `Examples` | Conjunto de datos de un Outline | tabla o CSV |

## ¿Qué explica cada validación?

- `match response == '#[]'`: la respuesta es un arreglo JSON.
- `match response.name == '#string'`: el campo `name` es texto.
- `match response.id == mascotaId`: el ID coincide con el que enviamos.
- `match response contains esquema`: la respuesta contiene las propiedades y tipos esperados en el esquema; tolera otras propiedades de nivel superior.
- `match header Content-Type contains 'json'`: el tipo de contenido describe una respuesta JSON.
- `status 200`: el servidor respondió con estado HTTP 200.

**Diferencia clave:** no es lo mismo validar que la API respondió `200` que validar **el contenido correcto**. Ambas aserciones son necesarias en pruebas de contrato.

## Inspección y depuración

1. Primero mira el código HTTP real y el cuerpo (`response`).
2. Revisa la URL completa: `baseUrl + path + param`.
3. Comprueba headers enviados y body de la petición.
4. Distingue entre error funcional (match incorrecto) y problema de ambiente (DNS, timeout, servidor compartido).
5. Verifica los tests en `target/karate-reports/karate-summary.html`.

## Windows / IntelliJ: si Java y Maven no son reconocidos

1. En IntelliJ ve a **File > Project Structure > Project** y asigna el JDK 17 al proyecto.
2. En **Settings > Build, Execution, Deployment > Build Tools > Maven > Runner**, asigna **JRE = 17**.
3. En **Settings > Build Tools > Maven**, selecciona Maven incluido (**Bundled**).
4. Si necesitas consola, verifica dónde se instaló JDK. Ejemplo ilustrativo de ruta: `C:\Program Files\Java\jdk-17` (usa tu ruta real).
5. En Windows configura la variable `JAVA_HOME` apuntando a la carpeta raíz del JDK 17, **sin `\bin`**, y añade `%JAVA_HOME%\bin` a PATH.
6. Si instalaste Maven independiente, añade `<ruta-de-maven>\bin` a PATH (por ejemplo `C:\tools\apache-maven-3.9.9\bin`).
7. Cierra y reabre CMD, PowerShell e IntelliJ si cambiaste variables. Revisa `java -version` y `mvn -version`.
8. Para ver rutas y versiones en PowerShell: `Get-Command java -ErrorAction SilentlyContinue`, `Get-Command mvn -ErrorAction SilentlyContinue`, `$env:JAVA_HOME`.
9. Usa `scripts/diagnostico-windows.ps1` si quieres un resumen local sin modificar variables.

## Ampliaciones posteriores (no obligatorias para la clase 0)

- Separar pruebas por servicios y dominios; agregar ambientes qa/staging.
- Compartir creación de fixtures mediante `call read()` en otro feature.
- Contratos negativos, autenticación real (sin subir secretos), estrategias de retry.
- Paralelismo controlado para escenarios independientes (ver `PetstoreParallel.java`).
- Integración CI/CD con GitHub Actions o GitLab CI.

**Regla del curso:** no inventar el mensaje exacto de error ni asegurar un volumen de datos fijo en un servidor de pruebas compartido.
