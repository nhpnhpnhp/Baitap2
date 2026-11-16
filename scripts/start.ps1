param([int]$Port = 8084, [string]$TomcatHome = 'C:\apache-tomcat-11.0.27-windows-x64\apache-tomcat-11.0.27')
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
Set-Location $projectRoot
if (!(Test-Path "$TomcatHome/lib/catalina.jar")) { throw 'Tomcat not found. Pass -TomcatHome with your Tomcat 11 directory.' }
$portProbe = New-Object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Loopback, $Port)
try { $portProbe.Start() } catch { throw "Port $Port is in use. Stop the existing server or choose another -Port." } finally { $portProbe.Stop() }
& mvn.cmd "-Dmaven.repo.local=$projectRoot/.runtime/m2" clean package
if ($LASTEXITCODE -ne 0) { throw 'Maven build failed.' }
$serverBase = Join-Path $projectRoot ".runtime/server-$Port"
foreach ($dir in 'conf','logs','temp','webapps','work','data') { New-Item -ItemType Directory -Force "$serverBase/$dir" | Out-Null }
New-Item -ItemType Directory -Force "$serverBase/data/category" | Out-Null
Copy-Item 'src/main/webapp/assets/avata.png' "$serverBase/data/category/avata.png" -Force
Copy-Item 'src/main/webapp/assets/avata.png' "$serverBase/data/category/avatar.png" -Force
Copy-Item "$TomcatHome/conf/*" "$serverBase/conf" -Recurse -Force
$config = Get-Content "$serverBase/conf/server.xml" -Raw
$config = $config.Replace('port="8005"','port="-1"').Replace('port="8080"',"port=`"$Port`"")
Set-Content "$serverBase/conf/server.xml" $config -Encoding UTF8
Copy-Item 'target/baitap2.war' "$serverBase/webapps/baitap2.war" -Force
$javaExe = (Get-Command java.exe).Source
$options = @(
    "-Dcatalina.home=$TomcatHome",
    "-Dcatalina.base=$serverBase",
    "-Djava.io.tmpdir=$serverBase/temp",
    '-Dfile.encoding=UTF-8',
    "-Dbaitap2.db.properties=$projectRoot/.runtime/db.properties",
    "-Djava.util.logging.config.file=$serverBase/conf/logging.properties",
    '-Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager',
    '-cp', "$TomcatHome/bin/bootstrap.jar;$TomcatHome/bin/tomcat-juli.jar",
    'org.apache.catalina.startup.Bootstrap', 'start'
)
$quotedOptions = $options | ForEach-Object { '"' + $_ + '"' }
$serverProcess = Start-Process -FilePath $javaExe -ArgumentList $quotedOptions -WindowStyle Hidden -PassThru -RedirectStandardOutput "$serverBase/logs/console.out.log" -RedirectStandardError "$serverBase/logs/console.err.log"
Set-Content "$serverBase/server.pid" $serverProcess.Id
Set-Content "$serverBase/server.start" $serverProcess.StartTime.ToUniversalTime().Ticks
for ($attempt=0; $attempt -lt 60; $attempt++) {
    Start-Sleep -Milliseconds 500
    try {
        $response = Invoke-WebRequest "http://localhost:$Port/baitap2/admin/category/add" -UseBasicParsing -TimeoutSec 3
        if ($response.StatusCode -eq 200) { Write-Host "Ready: http://localhost:$Port/baitap2/"; exit 0 }
    } catch { }
    if ($serverProcess.HasExited) { break }
}
throw "Tomcat did not become ready. See $serverBase/logs/console.err.log"
