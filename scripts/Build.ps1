param(
    [ValidateSet('Debug', 'Release')]
    [string]$Configuration = 'Debug',
    [ValidateSet('Build', 'Rebuild', 'Clean')]
    [string]$Target = 'Build'
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$vsWhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
if (-not (Test-Path -LiteralPath $vsWhere)) {
    throw 'Installer Visual Studio avec le développement Desktop .NET et le targeting pack .NET Framework 4.8.'
}
$msBuild = & $vsWhere -latest -products '*' -requires Microsoft.Component.MSBuild -find 'MSBuild\Current\Bin\MSBuild.exe' | Select-Object -First 1
if (-not $msBuild) {
    throw 'MSBuild est introuvable. Vérifier les composants de Visual Studio Installer.'
}
& $msBuild (Join-Path $projectRoot 'CoursesHippiques.sln') /m:1 "/t:$Target" "/p:Configuration=$Configuration" /p:UseSharedCompilation=false /nodeReuse:false /nologo /verbosity:minimal
exit $LASTEXITCODE
