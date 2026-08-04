$ErrorActionPreference = "Stop"

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$DistDir = Join-Path $ProjectRoot "dist"
$OutputJar = Join-Path $DistDir "nekara-0.2.0+mc26.1.2.jar"
$GradleOutputJar = Join-Path $ProjectRoot "build/libs/nekara-0.2.0+mc26.1.2.jar"
$OldOutputJar = Join-Path $DistDir "nekara-music-0.1.0+mc26.1.2.jar"

if (-not (Test-Path (Join-Path $ProjectRoot "gradlew.bat"))) {
  throw "Missing Gradle wrapper in $ProjectRoot"
}

New-Item -ItemType Directory -Force -Path $DistDir | Out-Null
if (Test-Path $OutputJar) {
  Remove-Item -LiteralPath $OutputJar -Force
}
if (Test-Path $OldOutputJar) {
  Remove-Item -LiteralPath $OldOutputJar -Force
}

$JavaCandidates = @()
if ($env:JAVA_HOME -and (Test-Path (Join-Path $env:JAVA_HOME "bin/java.exe"))) {
  $JavaCandidates += $env:JAVA_HOME
}
$JavaCandidates += @("C:/Program Files/Java/jdk-25")
$GradleJavaHome = $JavaCandidates | Where-Object { Test-Path (Join-Path $_ "bin/java.exe") } | Select-Object -First 1

if (-not $GradleJavaHome) {
  throw "Could not find Java 25. Install JDK 25 or set JAVA_HOME."
}

$previousJavaHome = $env:JAVA_HOME
Push-Location $ProjectRoot
try {
  $env:JAVA_HOME = $GradleJavaHome
  & (Join-Path $ProjectRoot "gradlew.bat") clean build
  if ($LASTEXITCODE -ne 0) {
    throw "Gradle build failed with exit code $LASTEXITCODE."
  }
}
finally {
  Pop-Location
  $env:JAVA_HOME = $previousJavaHome
}

if (-not (Test-Path $GradleOutputJar)) {
  throw "Gradle did not create expected jar: $GradleOutputJar"
}

Copy-Item -LiteralPath $GradleOutputJar -Destination $OutputJar -Force
Get-Item $OutputJar
