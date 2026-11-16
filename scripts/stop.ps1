param([int]$Port = 8084)
$ErrorActionPreference = 'Stop'
$serverBase = Join-Path (Split-Path $PSScriptRoot -Parent) ".runtime/server-$Port"
if (!(Test-Path "$serverBase/server.pid")) { Write-Host 'No project server PID found.'; exit 0 }
$serverProcessId = [int](Get-Content "$serverBase/server.pid")
$serverProcess = Get-Process -Id $serverProcessId -ErrorAction SilentlyContinue
if ($serverProcess) {
    $expectedStart = [long](Get-Content "$serverBase/server.start")
    if ($serverProcess.ProcessName -ne 'java' -or $serverProcess.StartTime.ToUniversalTime().Ticks -ne $expectedStart) {
        throw 'PID no longer belongs to this project server.'
    }
    Stop-Process -Id $serverProcessId
    Write-Host 'Project Tomcat stopped.'
}
Remove-Item -LiteralPath "$serverBase/server.pid" -Force
