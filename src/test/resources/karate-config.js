// Karate evalua esta funcion antes de cada escenario.
function fn() {
  var config = {
    baseUrl: karate.properties['baseUrl'] || 'https://petstore3.swagger.io/api/v3'
  };

  // Limites de conexion/lectura en milisegundos.
  karate.configure('connectTimeout', 10000);
  karate.configure('readTimeout', 15000);

  // Por defecto SI validamos certificados SSL (buena practica).
  // Solo para diagnostico en una red de confianza y con autorizacion:
  // mvn test -Dtest=PetstoreTest -DsslTrustAll=true
  // Esto NO corrige el almacen de certificados; desactiva su validacion.
  if (karate.properties['sslTrustAll'] == 'true') {
    karate.configure('ssl', true);
  }

  return config;
}
