package pe.edu.qa;

import com.intuit.karate.junit5.Karate;

/**
 * Runner para el laboratorio con escritura. No termina en 'Test':
 * Maven no lo lanza como parte del 'mvn test' normal.
 *
 * mvn test -Dtest=PetstoreRegression
 */
class PetstoreRegression {

    @Karate.Test
    Karate pruebasConEscritura() {
        return Karate.run("classpath:features").tags("@regression");
    }
}
