# Buenas prácticas de Karate DSL — nivel inicial

## 1. Organización

- Mantén versiones declaradas en `pom.xml`: `maven.compiler.release=17`, `karate.version=1.4.1`.
- URLs y configuración en `karate-config.js`, no copiadas en cada escenario.
- Usa nombres de escenarios que expliquen el comportamiento esperado.
- Guarda request bodies, headers y contratos reutilizables en `data/`.
- Separa escenarios de lectura (`@smoke`) de los que modifican el estado (`@regression`).

## 2. Diseño de pruebas

- Un escenario independiente no debe depender de la ejecución de otro.
- Para escribir datos, genera un ID de prueba, valida el resultado y limpia el recurso creado.
- No dependas de datos preexistentes o de que un GET devuelva una longitud fija en Petstore público.
- Valida código HTTP y datos relevantes, no solo el estado 200.
- Usa `match response contains` para validar campos esenciales cuando el contrato permita otras propiedades.
- Usa `match response == esquema` cuando necesites coincidencia exacta y el contrato realmente la garantice.
- El `#number` de Karate es una comprobación de tipo, no una validación de rangos; agrega reglas con `#?` si corresponde.

## 3. Rendimiento y seguridad

- No uses `Thread.sleep()` para sincronizar peticiones; enseña reintentos solo cuando tengan justificación.
- Los escenarios de escritura NO deben paralelizarse al inicio, porque el ambiente público es compartido.
- No hardcodees tokens privados ni credenciales reales. Usa variables de entorno o sistemas secretos para APIs reales.
- No desactives TLS / certificados para solucionar errores sin comprender el riesgo.
- Timeouts razonables: `connectTimeout` y `readTimeout` centralizados.

## 4. Limitaciones del laboratorio

Petstore 3 es una API pública de demostración, no un ambiente QA dedicado. Otro usuario puede eliminar los datos de tu prueba; si una prueba falla antes de su último paso, el DELETE no se ejecutará. Esto no garantiza limpieza incondicional. Para uso repetible y talleres con varios alumnos, se recomienda un servicio local o un ambiente aislado.

## 5. Qué sí es y qué no es la validación de esquema de Karate

Un archivo como `data/schemas/mascota-schema.json` declara marcadores (`#number`, `#string`, `#regex`, `#[]`) reconocidos por el operador `match` de Karate. No es una validación automática de un archivo JSON Schema Draft/OpenAPI, ni un generador automático de validaciones desde `openapi.json`. Para eso se necesitaría una integración adicional y un objetivo didáctico distinto.
