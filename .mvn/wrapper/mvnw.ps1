# ----------------------------------------------------------------------------
# Maven Wrapper (Windows / PowerShell) - chamado pelo mvnw.cmd
# Baixa (se necessario) a versao do Maven definida em maven-wrapper.properties
# e executa o comando recebido.
# ----------------------------------------------------------------------------
$ErrorActionPreference = 'Stop'

# $PSScriptRoot = <projeto>\.mvn\wrapper  ->  sobe dois niveis para chegar na raiz do projeto
$baseDir = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$propsFile = Join-Path $PSScriptRoot 'maven-wrapper.properties'

$line = Get-Content $propsFile | Where-Object { $_ -match '^distributionUrl=' } | Select-Object -First 1
if (-not $line) {
    Write-Error "distributionUrl nao encontrada em $propsFile"
    exit 1
}
$distUrl = ($line -replace '^distributionUrl=', '').Trim()

$distFile = $distUrl.Substring($distUrl.LastIndexOf('/') + 1)   # apache-maven-3.9.11-bin.zip
$distName = $distFile -replace '-bin\.zip$', ''                  # apache-maven-3.9.11

if ($env:MAVEN_USER_HOME) { $mavenUserHome = $env:MAVEN_USER_HOME } else { $mavenUserHome = Join-Path $env:USERPROFILE '.m2' }
$installDir = Join-Path $mavenUserHome "wrapper\dists\$distName"
$mvnCmd = Join-Path $installDir "$distName\bin\mvn.cmd"

if (-not (Test-Path $mvnCmd)) {
    Write-Host "Baixando Maven: $distUrl"
    New-Item -ItemType Directory -Force -Path $installDir | Out-Null
    $zip = Join-Path $installDir $distFile
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $distUrl -OutFile $zip -UseBasicParsing
    Expand-Archive -Path $zip -DestinationPath $installDir -Force
    Remove-Item $zip
}

& $mvnCmd @args
exit $LASTEXITCODE
