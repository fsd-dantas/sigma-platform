# Guia de Contribuição — SIGMA

Obrigado pelo interesse em contribuir com o SIGMA! Este documento fornece diretrizes para garantir um processo de contribuição eficiente e consistente.

## Sumário

- [Código de Conduta](#código-de-conduta)
- [Como Contribuir](#como-contribuir)
- [Configuração do Ambiente](#configuração-do-ambiente)
- [Fluxo de Trabalho Git](#fluxo-de-trabalho-git)
- [Padrões de Código](#padrões-de-código)
- [Commits](#commits)
- [Pull Requests](#pull-requests)
- [Revisão de Código](#revisão-de-código)
- [Reportando Bugs](#reportando-bugs)
- [Sugerindo Melhorias](#sugerindo-melhorias)

---

## Código de Conduta

Este projeto adota um Código de Conduta que esperamos que todos os participantes sigam. Por favor, seja respeitoso e colaborativo em todas as interações.

---

## Como Contribuir

### Tipos de Contribuição

1. **Correção de Bugs**: Identificou um bug? Abra uma issue ou submeta um fix.
2. **Novas Funcionalidades**: Discuta primeiro via issue antes de implementar.
3. **Documentação**: Melhorias em docs são sempre bem-vindas.
4. **Testes**: Aumento de cobertura de testes.
5. **Refatoração**: Melhorias de código que não alteram comportamento.

### Processo Geral

1. Verifique se já existe uma issue relacionada
2. Crie ou comente na issue para indicar que está trabalhando nela
3. Fork o repositório (contribuidores externos)
4. Crie uma branch seguindo o padrão de nomenclatura
5. Implemente as alterações
6. Escreva/atualize testes
7. Submeta um Pull Request

---

## Configuração do Ambiente

### Pré-requisitos

```bash
# Verificar instalações
dotnet --version    # 8.0.x
node --version      # v20.x.x
npm --version       # 10.x.x
git --version       # 2.40+
```

### Setup Inicial

```bash
# Clonar repositório
git clone https://github.com/fsd-dantas/sigma-platform.git
cd sigma-platform

# Configurar hooks (opcional, recomendado)
git config core.hooksPath .githooks

# Backend
cd src/backend
dotnet restore
dotnet build

# Frontend
cd ../frontend/portal-admin
npm install
```

### Variáveis de Ambiente

Copie os templates de configuração:

```bash
cp appsettings.Development.json.template appsettings.Development.json
cp .env.example .env.local
```

---

## Fluxo de Trabalho Git

### Branches

Este projeto utiliza **GitFlow** adaptado:

| Branch | Propósito | Origem | Destino |
|--------|-----------|--------|---------|
| `main` | Produção estável | - | - |
| `develop` | Desenvolvimento ativo | `main` | `main` |
| `feature/*` | Novas funcionalidades | `develop` | `develop` |
| `bugfix/*` | Correções não-críticas | `develop` | `develop` |
| `hotfix/*` | Correções críticas em produção | `main` | `main` + `develop` |
| `release/*` | Preparação de release | `develop` | `main` + `develop` |

### Nomenclatura de Branches

```
<tipo>/<scope>-<descricao-curta>
```

Exemplos:
```
feature/fazendario-criar-orcamento
bugfix/api-jwt-validation
hotfix/auth-token-expiration
release/v1.2.0
```

### Fluxo de Feature

```bash
# 1. Atualizar develop
git checkout develop
git pull origin develop

# 2. Criar branch de feature
git checkout -b feature/fazendario-criar-orcamento

# 3. Implementar (commits frequentes)
git add .
git commit -m "feat(fazendario): add Orcamento aggregate"

# 4. Push da branch
git push -u origin feature/fazendario-criar-orcamento

# 5. Abrir Pull Request para develop
```

---

## Padrões de Código

### Backend (.NET)

- Seguir convenções C# da Microsoft
- Usar `record` para Commands/Queries (imutabilidade)
- Validações via FluentValidation
- Regras de negócio no Domain, não em Controllers
- Cobertura mínima de 80% em testes unitários

```csharp
// Exemplo de Command
public sealed record CriarOrcamentoCommand(
    string Descricao,
    decimal ValorTotal,
    int AnoExercicio
) : ICommand<Guid>;

// Exemplo de Handler
public sealed class CriarOrcamentoHandler 
    : ICommandHandler<CriarOrcamentoCommand, Guid>
{
    // ...
}
```

### Frontend (React/TypeScript)

- Componentes funcionais com hooks
- TypeScript strict mode
- Estilização via TailwindCSS
- Nomenclatura PascalCase para componentes
- Nomenclatura camelCase para funções e variáveis

```typescript
// Exemplo de componente
interface OrcamentoCardProps {
  orcamento: Orcamento;
  onSelect: (id: string) => void;
}

export function OrcamentoCard({ orcamento, onSelect }: OrcamentoCardProps) {
  return (
    <div className="p-4 border rounded-lg shadow-sm">
      {/* ... */}
    </div>
  );
}
```

### Linting

```bash
# Backend
dotnet format

# Frontend
npm run lint
npm run lint:fix
```

---

## Commits

### Conventional Commits

Este projeto adota [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Types

| Type | Descrição | Exemplo |
|------|-----------|---------|
| `feat` | Nova funcionalidade | `feat(fazendario): add orcamento creation` |
| `fix` | Correção de bug | `fix(api): correct JWT expiration handling` |
| `docs` | Documentação | `docs(readme): update installation steps` |
| `style` | Formatação (sem mudança de código) | `style(ui): fix indentation` |
| `refactor` | Refatoração | `refactor(domain): extract value object` |
| `perf` | Performance | `perf(query): optimize orcamento listing` |
| `test` | Testes | `test(fazendario): add unit tests for aggregate` |
| `build` | Build/CI | `build(ci): add SonarCloud analysis` |
| `chore` | Manutenção | `chore(deps): update MediatR to 12.4` |

### Scopes

| Scope | Descrição |
|-------|-----------|
| `fazendario` | Domínio Fazendário |
| `contratacoes` | Domínio Contratações |
| `convenios` | Domínio Convênios |
| `obras` | Domínio Obras |
| `platform` | Plataforma transversal |
| `infra` | Infraestrutura |
| `api` | API endpoints |
| `ui` | Interface do usuário |
| `auth` | Autenticação/Autorização |
| `audit` | Auditoria |

### Exemplos

```bash
# Feature simples
git commit -m "feat(fazendario): add Orcamento aggregate with domain events"

# Bug fix com issue reference
git commit -m "fix(api): correct JWT validation for expired tokens

Fixes #123"

# Breaking change
git commit -m "feat(api)!: change authentication endpoint response format

BREAKING CHANGE: The /auth/login endpoint now returns a different JSON structure.
See migration guide in docs/MIGRATION.md"
```

---

## Pull Requests

### Checklist Antes de Submeter

- [ ] Branch atualizada com `develop`
- [ ] Código segue os padrões do projeto
- [ ] Testes escritos/atualizados
- [ ] Testes passando localmente
- [ ] Documentação atualizada (se necessário)
- [ ] Commits seguem Conventional Commits
- [ ] Sem conflitos de merge

### Template de PR

```markdown
## Descrição

Breve descrição das alterações.

## Tipo de Mudança

- [ ] Bug fix (correção que não quebra funcionalidade existente)
- [ ] Nova feature (funcionalidade que não quebra existente)
- [ ] Breaking change (fix ou feature que quebra funcionalidade existente)
- [ ] Documentação

## Como Testar

1. Passo 1
2. Passo 2
3. ...

## Checklist

- [ ] Código segue padrões do projeto
- [ ] Self-review realizado
- [ ] Testes adicionados/atualizados
- [ ] Documentação atualizada

## Issues Relacionadas

Fixes #123
Relates to #456
```

### Tamanho do PR

- **Ideal**: < 400 linhas alteradas
- **Aceitável**: 400-800 linhas
- **Evitar**: > 800 linhas (dividir em PRs menores)

---

## Revisão de Código

### Responsabilidades do Autor

- Responder comentários em até 48h
- Fazer alterações solicitadas ou justificar
- Manter PR atualizado com `develop`

### Responsabilidades do Revisor

- Revisar em até 48h
- Ser construtivo e específico
- Aprovar quando pronto ou solicitar mudanças claras

### Critérios de Aprovação

- Código funciona conforme especificado
- Testes adequados
- Sem violações de arquitetura
- Performance aceitável
- Segurança verificada

---

## Reportando Bugs

### Template de Issue (Bug)

```markdown
**Descrição**
Descrição clara do bug.

**Passos para Reproduzir**
1. Vá para '...'
2. Clique em '...'
3. Observe o erro

**Comportamento Esperado**
O que deveria acontecer.

**Comportamento Atual**
O que está acontecendo.

**Screenshots**
Se aplicável.

**Ambiente**
- OS: [ex: Windows 11]
- Browser: [ex: Chrome 120]
- Versão: [ex: v1.2.0]

**Contexto Adicional**
Qualquer informação relevante.
```

---

## Sugerindo Melhorias

### Template de Issue (Feature Request)

```markdown
**Problema/Motivação**
Qual problema esta feature resolve?

**Solução Proposta**
Descrição da solução desejada.

**Alternativas Consideradas**
Outras soluções avaliadas.

**Contexto Adicional**
Mockups, diagramas, referências.
```

---

## Dúvidas

Para dúvidas sobre contribuição, abra uma issue com a tag `question` ou entre em contato com os mantenedores.

---

**Obrigado por contribuir com o SIGMA!**
