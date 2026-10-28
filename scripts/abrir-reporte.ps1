# Abre el reporte Karate del tipo indicado, SIN ejecutar las pruebas.
# Desde la raiz del proyecto:
#   .\scripts\abrir-reporte.ps1 -Tipo smoke
# Tipos: smoke, regression, parallel, local
param(
    [ValidateSet('smoke','regression','parallel','local')]
    [string] $Tipo = 'smoke'
)
$Carpetas = @{
    smoke      = 'target/karate-reports'
    regression = 'target/karate-reports-regression'
    parallel   = 'target/karate-reports-parallel'
    local      = 'target/karate-reports-local'
}
$Raiz = Split-Path -Parent $PSScriptRoot
$Archivo = Join-Path (Join-Path $Raiz $Carpetas[$Tipo]) 'karate-summary.html'
if (-not (Test-Path -LiteralPath $Archivo -PathType Leaf)) {
    Write-Host "No existe el reporte: $Archivo" -ForegroundColor Yellow
    Write-Host 'Ejecuta el runner del tipo indicado desde IntelliJ o Maven.'
    exit 1
}
$Info = Get-Item -LiteralPath $Archivo
Write-Host "Reporte: $($Info.FullName)" -ForegroundColor Green
Write-Host "Ultima modificacion: $($Info.LastWriteTime)"
Start-Process -FilePath $Info.FullName
