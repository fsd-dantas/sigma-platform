<#
.SYNOPSIS
    Script para preparar o repositório SIGMA para upload ao GitHub.
    
.DESCRIPTION
    Este script:
    1. Cria arquivos .gitkeep em diretórios vazios
    2. Inicializa o repositório Git
    3. Configura branches main e develop
    4. Prepara commits iniciais
    
.NOTES
    Projeto: SIGMA - Sistema Integrado de Governança e Monitoramento Administrativo
    Autor: Fernando Dantas
    Data: 2025-12-10
    
.EXAMPLE
    .\setup-git-repository.ps1
#>

param(
    [string]$ProjectPath = ".",
    [string]$RemoteUrl = "https://github.com/fsd-dantas/sigma-platform.git",
    [switch]$SkipGitKeep,
    [switch]$SkipGitInit,
    [switch]$DryRun
)

# Cores para output
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Write-Step {
    param([string]$Message)
    Write-ColorOutput "`n[STEP] $Message" "Cyan"
}

function Write-Success {
    param([string]$Message)
    Write-ColorOutput "[OK] $Message" "Green"
}

function Write-Warning {
    param([string]$Message)
    Write-ColorOutput "[WARN] $Message" "Yellow"
}

function Write-Error {
    param([string]$Message)
    Write-ColorOutput "[ERROR] $Message" "Red"
}

# Banner
Write-ColorOutput @"

===============================================================================
  SIGMA - Setup do Repositório Git
  Sistema Integrado de Governança e Monitoramento Administrativo
===============================================================================

"@ "Cyan"

# Verificar se está no diretório correto
$currentPath = Get-Location
Write-ColorOutput "Diretório atual: $currentPath" "Gray"

if ($DryRun) {
    Write-Warning "Modo DRY RUN ativado - nenhuma alteração será feita"
}

# =============================================================================
# PASSO 1: Criar arquivos .gitkeep em diretórios vazios
# =============================================================================

if (-not $SkipGitKeep) {
    Write-Step "Criando arquivos .gitkeep em diretórios vazios..."
    
    $emptyDirs = Get-ChildItem -Path $ProjectPath -Recurse -Directory | 
        Where-Object { 
            (Get-ChildItem -Path $_.FullName -File).Count -eq 0 -and
            $_.Name -notlike "node_modules*" -and
            $_.Name -notlike ".git*" -and
            $_.Name -notlike "bin" -and
            $_.Name -notlike "obj"
        }
    
    $createdCount = 0
    foreach ($dir in $emptyDirs) {
        $gitkeepPath = Join-Path $dir.FullName ".gitkeep"
        
        # Verificar se já existe algum arquivo
        $hasFiles = (Get-ChildItem -Path $dir.FullName -File -Force).Count -gt 0
        
        if (-not $hasFiles) {
            if (-not $DryRun) {
                New-Item -Path $gitkeepPath -ItemType File -Force | Out-Null
            }
            Write-ColorOutput "  + $($dir.FullName)\.gitkeep" "Gray"
            $createdCount++
        }
    }
    
    Write-Success "Criados $createdCount arquivos .gitkeep"
}

# =============================================================================
# PASSO 2: Inicializar repositório Git
# =============================================================================

if (-not $SkipGitInit) {
    Write-Step "Verificando/Inicializando repositório Git..."
    
    $gitDir = Join-Path $ProjectPath ".git"
    
    if (Test-Path $gitDir) {
        Write-Warning "Repositório Git já existe. Pulando inicialização."
    }
    else {
        if (-not $DryRun) {
            git init
        }
        Write-Success "Repositório Git inicializado"
    }
}

# =============================================================================
# PASSO 3: Configurar .gitignore
# =============================================================================

Write-Step "Verificando .gitignore..."

$gitignorePath = Join-Path $ProjectPath ".gitignore"

if (Test-Path $gitignorePath) {
    Write-Success ".gitignore já existe"
}
else {
    Write-Warning ".gitignore não encontrado!"
    Write-ColorOutput "  Copie o arquivo .gitignore fornecido para a raiz do projeto." "Yellow"
}

# =============================================================================
# PASSO 4: Verificar arquivos essenciais
# =============================================================================

Write-Step "Verificando arquivos essenciais..."

$essentialFiles = @(
    ".gitignore",
    "README.md",
    "LICENSE",
    "CONTRIBUTING.md"
)

foreach ($file in $essentialFiles) {
    $filePath = Join-Path $ProjectPath $file
    if (Test-Path $filePath) {
        Write-Success "$file encontrado"
    }
    else {
        Write-Warning "$file NÃO encontrado - copie o arquivo fornecido"
    }
}

# =============================================================================
# PASSO 5: Exibir comandos para execução manual
# =============================================================================

Write-Step "Comandos para execução manual..."

Write-ColorOutput @"

Execute os seguintes comandos na ordem:

# 1. Adicionar arquivos ao staging
git add .

# 2. Verificar status
git status

# 3. Primeiro commit
git commit -m "chore: initial project structure with Clean Architecture layers"

# 4. Renomear branch para main (se necessário)
git branch -M main

# 5. Adicionar remote
git remote add origin $RemoteUrl

# 6. Push inicial
git push -u origin main

# 7. Criar e fazer push da branch develop
git checkout -b develop
git push -u origin develop

# 8. Voltar para main
git checkout main

"@ "White"

# =============================================================================
# PASSO 6: Estatísticas
# =============================================================================

Write-Step "Estatísticas do projeto..."

$stats = @{
    "Diretórios" = (Get-ChildItem -Path $ProjectPath -Recurse -Directory | 
        Where-Object { $_.Name -notlike "node_modules*" -and $_.Name -notlike ".git*" }).Count
    "Arquivos" = (Get-ChildItem -Path $ProjectPath -Recurse -File | 
        Where-Object { $_.DirectoryName -notlike "*node_modules*" -and $_.DirectoryName -notlike "*.git*" }).Count
}

foreach ($stat in $stats.GetEnumerator()) {
    Write-ColorOutput "  $($stat.Key): $($stat.Value)" "Gray"
}

Write-ColorOutput @"

===============================================================================
  Setup concluído!
  
  Próximos passos:
  1. Copie os arquivos fornecidos (.gitignore, README.md, LICENSE, CONTRIBUTING.md)
  2. Execute os comandos Git listados acima
  3. Verifique o repositório em: https://github.com/fsd-dantas/sigma-platform
===============================================================================

"@ "Green"
