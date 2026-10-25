package pe.edu.qa;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Ejemplo adicional para explicar paralelismo a alumnos avanzados.
 * Se limita a @smoke: consultas independientes sin escritura compartida.
 *
 * mvn test -Dtest=PetstoreParallel
 */
class PetstoreParallel {

    @Test
    void consultasEnParalelo() {
        // El numero 3 representa la cantidad maxima de hilos concurrentes.
        Results resultados = Runner.path("classpath:features")
                .tags("@smoke")
                .parallel(3);

        // La compilacion debe fallar si existio algun escenario fallido.
        assertEquals(0, resultados.getFailCount(), resultados.getErrorMessages());
    }
}
