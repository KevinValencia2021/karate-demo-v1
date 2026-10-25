package pe.edu.qa;

import com.intuit.karate.junit5.Karate;

/**
 * Punto de entrada para el alumno: ejecuta solo escenarios @smoke.
 * mvn test
 *
 * @smoke = consultas y ejercicios locales que NO modifican Petstore.
 * @regression = escenarios que crean, editan o eliminan datos.
 */
class PetstoreTest {

    @Karate.Test
    Karate pruebasRapidas() {
        // Busca archivos .feature dentro de src/test/resources/features.
        return Karate.run("classpath:features").tags("@smoke");
    }
}
