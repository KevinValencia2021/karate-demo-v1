// Karate ejecuta esta funcion ANTES de cada escenario.
// Evitamos duplicar URL base y timeout en los archivos .feature.
function fn() {
  var config = {
    // Por defecto utilizamos el servidor publico Petstore OpenAPI 3.
    // Puede cambiarse: -DbaseUrl=http://localhost:8080/api/v3
    baseUrl: karate.properties['baseUrl'] || 'https://petstore3.swagger.io/api/v3'
  };

  // Milisegundos: 10 segundos para conectar y 15 para leer respuesta.
  karate.configure('connectTimeout', 10000);
  karate.configure('readTimeout', 15000);

  return config;
}
