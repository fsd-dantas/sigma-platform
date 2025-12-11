# SIGMA — Sistema Integrado de Governança e Monitoramento Administrativo

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![.NET](https://img.shields.io/badge/.NET-8.0-purple.svg)
![React](https://img.shields.io/badge/React-18.x-61DAFB.svg)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791.svg)

## Sumário

- [Visão Geral](#visão-geral)
- [Arquitetura](#arquitetura)
- [Stack Tecnológico](#stack-tecnológico)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Pré-requisitos](#pré-requisitos)
- [Instalação](#instalação)
- [Execução](#execução)
- [Testes](#testes)
- [Documentação](#documentação)
- [Contribuição](#contribuição)
- [Licença](#licença)

---

## Visão Geral

O **SIGMA** é uma plataforma integrada desenvolvida para a **Secretaria Estadual da Educação do Paraná (SEED)**, no âmbito do **Programa de Educação para o Futuro do Estado do Paraná (PEFEP) — Componente 4**.

O sistema tem como objetivo modernizar e unificar os processos administrativos da secretaria, abrangendo:

| Domínio | Descrição |
|---------|-----------|
| **Fazendário** | Orçamento, finanças, contabilidade e prestações de contas |
| **Contratações** | Governança, compras, licitações e contratos |
| **Convênios e Fomentos** | Gestão de convênios, recursos e transferências |
| **Obras e Imóveis** | Planejamento, patrimônio, projetos e fiscalização |

---

## Arquitetura

O SIGMA adota uma arquitetura em camadas concêntricas, seguindo os princípios de **Clean Architecture** e **Domain-Driven Design (DDD)**:

```
┌─────────────────────────────────────────────────────────────┐
│                    Pacotes Funcionais                        │
│  (Fazendário, Contratações, Convênios, Obras e Imóveis)     │
├─────────────────────────────────────────────────────────────┤
│                  Plataforma Operacional                      │
│  (Identidade, Auditoria, Workflow, BI, Integrações)         │
├─────────────────────────────────────────────────────────────┤
│                  Domínios Transversais                       │
│  (Regras de Negócio, Governança de Dados)                   │
├─────────────────────────────────────────────────────────────┤
│                    Infraestrutura                            │
│  (PostgreSQL, MinIO, NGINX, GitHub Actions)                 │
└─────────────────────────────────────────────────────────────┘
```

### Decisões Arquiteturais (ADRs)

| ADR | Decisão | Status |
|-----|---------|--------|
| ADR-001 | Arquitetura Monolítica Modular | Estável |
| ADR-002 | Domain-Driven Design (DDD) | Estável |
| ADR-003 | Clean Architecture | Estável |
| ADR-004 | Stack Tecnológico (.NET 8, React 18) | Estável |
| ADR-005 | Plataforma Operacional com 9 domínios transversais | Estável |
| ADR-006 | Arquitetura Física com 4 VMs | Estável |

---

## Stack Tecnológico

### Backend

| Tecnologia | Versão | Propósito |
|------------|--------|-----------|
| .NET | 8.0 LTS | Runtime principal |
| ASP.NET Core | 8.0 | Web API |
| Entity Framework Core | 8.x | ORM |
| MediatR | 12.x | CQRS / Mediator Pattern |
| FluentValidation | 11.x | Validação de comandos |
| Polly | 8.x | Resiliência e retry policies |

### Frontend

| Tecnologia | Versão | Propósito |
|------------|--------|-----------|
| React | 18.x | Framework UI |
| TypeScript | 5.x | Tipagem estática |
| Vite | 5.x | Build tool |
| TailwindCSS | 3.x | Estilização |
| Zustand | 4.x | State management |
| React Query | 5.x | Server state |

### Infraestrutura

| Tecnologia | Versão | Propósito |
|------------|--------|-----------|
| PostgreSQL | 16 | Banco de dados |
| NGINX | Latest | Reverse proxy / Web server |
| MinIO | Latest | Object storage (S3-compatible) |
| Ansible | 2.15+ | Infrastructure as Code |
| GitHub Actions | - | CI/CD |

---

## Estrutura do Projeto

```
sigma-platform/
├── .github/
│   └── workflows/           # Pipelines CI/CD
├── design/
│   ├── figma/              # Exports e tokens de design
│   └── icons/              # Ícones customizados
├── docs/
│   ├── api/                # Documentação OpenAPI
│   ├── architecture/
│   │   ├── adrs/           # Architecture Decision Records
│   │   ├── c4/             # Diagramas C4
│   │   └── diagrams/       # Diagramas gerais
│   └── guides/             # Guias de desenvolvimento
├── infra/
│   ├── ansible/            # Playbooks e roles
│   ├── docker/             # Dockerfiles e compose
│   └── scripts/            # Scripts de automação
├── src/
│   ├── backend/
│   │   ├── 1-Host/         # API e Background Jobs
│   │   ├── 2-Application/  # Commands, Queries, Handlers
│   │   ├── 3-Domain/       # Entidades, Aggregates, Events
│   │   ├── 4-Infrastructure/ # Repositórios, Integrações
│   │   └── 5-CrossCutting/ # Utilitários compartilhados
│   └── frontend/
│       ├── portal-admin/   # Portal administrativo
│       ├── portal-bi/      # Portal de BI/Dashboards
│       └── portal-usuario/ # Portal do usuário final
└── tests/
    ├── architectural/      # Testes de arquitetura (NetArchTest)
    ├── e2e/               # Testes end-to-end
    ├── integration/       # Testes de integração
    ├── performance/       # Testes de carga
    └── unit/              # Testes unitários
```

---

## Pré-requisitos

### Desenvolvimento Local

- **.NET SDK 8.0** ou superior
- **Node.js 20.x** LTS
- **PostgreSQL 16** ou superior
- **Git 2.40+**

### Verificação

```bash
# Verificar versões instaladas
dotnet --version    # 8.0.x
node --version      # v20.x.x
npm --version       # 10.x.x
psql --version      # 16.x
git --version       # 2.40+
```

---

## Instalação

### 1. Clonar o Repositório

```bash
git clone https://github.com/fsd-dantas/sigma-platform.git
cd sigma-platform
```

### 2. Backend

```bash
cd src/backend
dotnet restore
dotnet build
```

### 3. Frontend

```bash
cd src/frontend/portal-admin
npm install
```

### 4. Banco de Dados

```bash
# Criar banco de dados
createdb sigma_dev

# Aplicar migrations
cd src/backend/4-Infrastructure/Sigma.Infrastructure.Persistence
dotnet ef database update
```

---

## Execução

### Backend (API)

```bash
cd src/backend/1-Host/Sigma.Api
dotnet run
# API disponível em: https://localhost:5001
```

### Frontend (Portal Admin)

```bash
cd src/frontend/portal-admin
npm run dev
# App disponível em: http://localhost:5173
```

---

## Testes

```bash
# Testes unitários
dotnet test tests/unit

# Testes de integração
dotnet test tests/integration

# Testes arquiteturais
dotnet test tests/architectural

# Testes E2E
cd tests/e2e && npm run test

# Cobertura de código
dotnet test --collect:"XPlat Code Coverage"
```

---

## Documentação

| Documento | Descrição |
|-----------|-----------|
| [PID](docs/PID.md) | Project Initiation Document |
| [IAD](docs/architecture/IAD.md) | Integrated Architectural Document |
| [SRS](docs/SRS.md) | Software Requirements Specification |
| [DEV-Guide](docs/guides/DEV-GUIDE.md) | Guia de Desenvolvimento |
| [API Docs](docs/api/README.md) | Documentação da API (OpenAPI) |

---

## Contribuição

Contribuições são bem-vindas! Por favor, leia o [CONTRIBUTING.md](CONTRIBUTING.md) para detalhes sobre o processo de submissão de pull requests.

### Fluxo de Trabalho

1. Crie uma branch a partir de `develop`
2. Implemente suas alterações seguindo o [DEV-Guide](docs/guides/DEV-GUIDE.md)
3. Escreva testes para novas funcionalidades
4. Submeta um Pull Request para `develop`

### Conventional Commits

Este projeto utiliza [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(fazendario): add orcamento aggregate
fix(api): correct JWT validation
docs(architecture): update C4 diagrams
test(contratacoes): add integration tests
```

---

## Licença

Este projeto está licenciado sob a **MIT License** - veja o arquivo [LICENSE](LICENSE) para detalhes.

---

## Contato

**Secretaria Estadual da Educação do Paraná (SEED)**  
Programa de Educação para o Futuro do Estado do Paraná (PEFEP)

---

## Referências

- EVANS, Eric. **Domain-Driven Design**. Addison-Wesley, 2003.
- MARTIN, Robert C. **Clean Architecture**. Prentice Hall, 2017.
- VERNON, Vaughn. **Implementing Domain-Driven Design**. Addison-Wesley, 2013.
- FOWLER, Martin. **MonolithFirst**. 2015.
