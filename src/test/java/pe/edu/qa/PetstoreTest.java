package pe.edu.qa;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;

import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * RUNNER PRINCIPAL PARA CLASES: permite filtrar por tags en todos los features.
 *
 * Desde Maven:
 *   mvn test "-DtestTags=@smoke"
 *   mvn test "-DtestTags=@csv"
 *   mvn test "-DtestTags=@regression"
 *
 * Desde IntelliJ (Run > Edit Configurations > VM options):
 *   -DtestTags=@headers
 *
 * Si no se proporciona testTags, SOLO se ejecutan las pruebas @smoke.
 * No hay que cambiar el codigo Java para seleccionar nuevas etiquetas.
 */
public class PetstoreTest {

    @Test
    void ejecutar() {
        // Lee la etiqueta desde Maven o IntelliJ; @smoke es la seleccion segura.
        String tagsSeleccionados = System.getProperty("testTags", "@smoke").trim();
        assertTrue(!tagsSeleccionados.isEmpty(),
                "La propiedad testTags esta vacia. Ejemplo: -DtestTags=@smoke");

        // Consulta TODOS los archivos .feature de la carpeta y sus subcarpetas.
        // Los escenarios no necesitan estar dentro de un feature determinado.
        String carpetaReportes = "target/karate-reports";
        System.out.println("TAGS KARATE SELECCIONADOS: " + tagsSeleccionados);
        System.out.println("BUSQUEDA DE FEATURES: classpath:features");

        Results resultados = Runner.path("classpath:features")
                .tags(tagsSeleccionados)      // Solo escenarios que tengan ese tag
                .reportDir(carpetaReportes)
                .outputHtmlReport(true)       // HTML navegable
                .outputJunitXml(true)         // Formato JUnit para CI
                .outputCucumberJson(true)     // JSON para otros reportes
                .parallel(1);                 // Inicialmente secuencial para enseñar

        Path reporte = Path.of(carpetaReportes, "karate-summary.html").toAbsolutePath();
        System.out.println("REPORTE KARATE: " + reporte.toUri());
        assertTrue(Files.isRegularFile(reporte),
                "No se genero el HTML esperado: " + reporte);
        assertTrue(resultados.getScenariosTotal() > 0,
                "No hay escenarios con el filtro: " + tagsSeleccionados
                        + ". Comprueba que el tag exista en los archivos .feature");
        // Un escenario fallido por SSL / API se refleja en el reporte antes de fallar JUnit.
        assertEquals(0, resultados.getFailCount(), resultados.getErrorMessages());
    }
}
