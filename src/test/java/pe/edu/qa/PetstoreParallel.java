package pe.edu.qa;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;

import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Demostracion de ejecucion en tres hilos independientes.
 *
 * Se usa Runner.path(...).parallel(...) para finalizar una suite completa
 * y escribir karate-summary.html EN CADA ejecucion, incluso con escenarios fallidos.
 * El reporte tiene una carpeta propia para no sobreescribir otras ejecuciones.
 */
public class PetstoreParallel {

    @Test
    void ejecutar() {
        // Tag: filtra los escenarios que corresponden a esta clase.
        // Ruta: evita mezclar evidencias de otros tipos de ejecucion.
        String carpetaReportes = "target/karate-reports-parallel";

        Results resultados = Runner.path("classpath:features")
                .tags("@smoke")
                .reportDir(carpetaReportes)
                .outputHtmlReport(true)       // Reporte navegable de Karate
                .outputJunitXml(true)         // Evidencia estandar para CI/JUnit
                .outputCucumberJson(true)     // Compatible con reportes externos
                .parallel(3);                 // Hilos; 1 = ejecucion secuencial

        // En 1.4.1 .parallel() finaliza la suite y genera karate-summary.html.
        Path reporte = Path.of(carpetaReportes, "karate-summary.html").toAbsolutePath();
        System.out.println("REPORTE KARATE: " + reporte.toUri());
        assertTrue(Files.isRegularFile(reporte),
                "No se genero el HTML esperado: " + reporte);
        assertTrue(resultados.getScenariosTotal() > 0,
                "No se encontraron escenarios con el tag indicado");

        // Validamos al final: un escenario fallido NO impide emitir el reporte.
        assertEquals(0, resultados.getFailCount(), resultados.getErrorMessages());
    }
}
