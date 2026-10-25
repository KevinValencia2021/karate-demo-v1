# Muestra información del entorno sin realizar cambios en Windows.
Write-Host '=== Diagnostico Java + Maven para Karate 1.4.1 ==='
Write-Host "JAVA_HOME: $env:JAVA_HOME"
Write-Host ''

$java = Get-Command java -ErrorAction SilentlyContinue
if ($java) {
    Write-Host "Java encontrado en: $($java.Source)"
    & java -version
} else {
    Write-Host 'Java NO reconocido en PATH. Configura JDK 17 o usa el SDK seleccionado en IntelliJ.'
}
Write-Host ''

$mvn = Get-Command mvn -ErrorAction SilentlyContinue
if ($mvn) {
    Write-Host "Maven encontrado en: $($mvn.Source)"
    & mvn -version
} else {
    Write-Host 'Maven NO reconocido en PATH. IntelliJ puede utilizar Maven incluido (Bundled).'
}
Write-Host ''
Write-Host 'Revisa ademas IntelliJ: Project SDK = 17; Maven Runner JRE = 17.'
