param(
    [Parameter(Mandatory = $true)]
    [string]$Base
)

function New-DirectoryIfNotExists($path) {
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path | Out-Null
        Write-Host "[CREATE] $path"
    }
}

# Ensure base exists and resolve absolute path
if (-not (Test-Path $Base)) {
    New-Item -ItemType Directory -Path $Base | Out-Null
}
$Base = (Resolve-Path $Base).Path

Write-Host "=== Creating clean SIGMA directory structure ==="
Write-Host "Base directory: $Base"
Write-Host ""

# ==============================================================================
# 1. Top-level folders
# ==============================================================================

$topLevel = @(
    "$Base\.github\workflows",
    "$Base\src",
    "$Base\docs",
    "$Base\infra",
    "$Base\tests",
    "$Base\design"
)

foreach ($dir in $topLevel) { New-DirectoryIfNotExists $dir }

# ==============================================================================
# 2. SRC/BACKEND canonical structure
# ==============================================================================

$backend = @(
    "$Base\src\backend",
    "$Base\src\backend\1-Host\Sigma.Api\Controllers\v1",
    "$Base\src\backend\1-Host\Sigma.Api\Middleware",
    "$Base\src\backend\1-Host\Sigma.BackgroundJobs",

    "$Base\src\backend\2-Application\Sigma.Application\Features\Fazendario\Orcamento\Commands",
    "$Base\src\backend\2-Application\Sigma.Application\Features\Fazendario\Orcamento\Queries",
    "$Base\src\backend\2-Application\Sigma.Application\Features\Contratacoes",
    "$Base\src\backend\2-Application\Sigma.Application\Features\ConveniosFomentos",
    "$Base\src\backend\2-Application\Sigma.Application\Features\ObrasImoveis",
    "$Base\src\backend\2-Application\Sigma.Application\Behaviors",
    "$Base\src\backend\2-Application\Sigma.Application\Common\Interfaces",

    "$Base\src\backend\3-Domain\Sigma.Domain.Shared",
    "$Base\src\backend\3-Domain\Sigma.Domain.Fazendario",
    "$Base\src\backend\3-Domain\Sigma.Domain.Contratacoes",
    "$Base\src\backend\3-Domain\Sigma.Domain.ConveniosFomentos",
    "$Base\src\backend\3-Domain\Sigma.Domain.ObrasImoveis",

    "$Base\src\backend\4-Infrastructure\Sigma.Infrastructure.Persistence\Migrations",
    "$Base\src\backend\4-Infrastructure\Sigma.Infrastructure.Persistence\Repositories",
    "$Base\src\backend\4-Infrastructure\Sigma.Infrastructure.Identity",
    "$Base\src\backend\4-Infrastructure\Sigma.Infrastructure.EventStore",
    "$Base\src\backend\4-Infrastructure\Sigma.Infrastructure.Integrations\Siafic",
    "$Base\src\backend\4-Infrastructure\Sigma.Infrastructure.Integrations\EProtocolo",
    "$Base\src\backend\4-Infrastructure\Sigma.Infrastructure.Integrations\Gms",
    "$Base\src\backend\4-Infrastructure\Sigma.Infrastructure.DocumentStore",

    "$Base\src\backend\5-CrossCutting\Sigma.CrossCutting\Extensions",
    "$Base\src\backend\5-CrossCutting\Sigma.CrossCutting\Helpers",
    "$Base\src\backend\5-CrossCutting\Sigma.CrossCutting\Constants"
)

foreach ($dir in $backend) { New-DirectoryIfNotExists $dir }

# ==============================================================================
# 3. SRC/FRONTEND structure
# ==============================================================================

$frontend = @(
    "$Base\src\frontend\portal-admin\public",
    "$Base\src\frontend\portal-admin\src\assets",
    "$Base\src\frontend\portal-admin\src\components\ui",
    "$Base\src\frontend\portal-admin\src\components\layout",
    "$Base\src\frontend\portal-admin\src\pages\auth",
    "$Base\src\frontend\portal-admin\src\pages\home",
    "$Base\src\frontend\portal-admin\src\pages\fazendario",
    "$Base\src\frontend\portal-admin\src\pages\contratacoes",
    "$Base\src\frontend\portal-admin\src\pages\convenios",
    "$Base\src\frontend\portal-admin\src\pages\obras",
    "$Base\src\frontend\portal-admin\src\features",
    "$Base\src\frontend\portal-admin\src\shared\hooks",
    "$Base\src\frontend\portal-admin\src\shared\services",
    "$Base\src\frontend\portal-admin\src\shared\types",

    "$Base\src\frontend\portal-bi\public",
    "$Base\src\frontend\portal-bi\src",

    "$Base\src\frontend\portal-usuario\public",
    "$Base\src\frontend\portal-usuario\src"
)

foreach ($dir in $frontend) { New-DirectoryIfNotExists $dir }

# ==============================================================================
# 4. INFRA structure
# ==============================================================================

$infra = @(
    "$Base\infra\ansible\inventories",
    "$Base\infra\ansible\playbooks",
    "$Base\infra\ansible\roles\nginx",
    "$Base\infra\ansible\roles\dotnet",
    "$Base\infra\ansible\roles\postgresql",
    "$Base\infra\docker",
    "$Base\infra\scripts"
)

foreach ($dir in $infra) { New-DirectoryIfNotExists $dir }

# ==============================================================================
# 5. DOCS structure
# ==============================================================================

$docs = @(
    "$Base\docs\architecture\adrs",
    "$Base\docs\architecture\c4",
    "$Base\docs\architecture\diagrams",
    "$Base\docs\api",
    "$Base\docs\guides"
)

foreach ($dir in $docs) { New-DirectoryIfNotExists $dir }

# ==============================================================================
# 6. DESIGN structure
# ==============================================================================

$design = @(
    "$Base\design\figma\exports",
    "$Base\design\figma\tokens",
    "$Base\design\icons"
)

foreach ($dir in $design) { New-DirectoryIfNotExists $dir }

# ==============================================================================
# 7. TESTS structure
# ==============================================================================

$tests = @(
    "$Base\tests\unit",
    "$Base\tests\integration",
    "$Base\tests\e2e",
    "$Base\tests\performance",
    "$Base\tests\architectural"
)

foreach ($dir in $tests) { New-DirectoryIfNotExists $dir }

Write-Host ""
Write-Host "=== SIGMA structure created cleanly and successfully ==="
