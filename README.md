#  xCloud Containers

Este repositório contém as imagens de contêiner base para o ecossistema xCloud, otimizadas para desenvolvimento, segurança e performance. As imagens são construídas usando Podman e publicadas automaticamente no GitHub Container Registry (ghcr.io).

## 📦 Imagens Disponíveis

Todas as imagens são publicadas sob a organização `pagecloudv1`.

### Imagem Base

-   **`ghcr.io/pagecloudv1/xcloud-base:latest`**
-   **Descrição**: Imagem mínima baseada em Alpine Linux com ferramentas essenciais (git, curl, wget, bash). Serve como a base para todas as outras imagens do ecossistema.
-   **Dockerfile**: [`base/Podmanfile`](./base/Podmanfile)

### Imagem Node.js

-   **`ghcr.io/pagecloudv1/xcloud-nodejs:latest`**
-   **Descrição**: Imagem de desenvolvimento para aplicações Node.js, baseada na `xcloud-base`. Inclui Node.js v20 e npm.
-   **Dockerfile**: [`nodejs/Podmanfile`](./nodejs/Podmanfile)

### Imagem Python

-   **`ghcr.io/pagecloudv1/xcloud-python:latest`**
-   **Descrição**: Imagem de desenvolvimento para aplicações Python, baseada na `xcloud-base`. Inclui Python 3.11, `uv`, e ferramentas comuns de desenvolvimento (black, flake8, pytest).
-   **Dockerfile**: [`python/Podmanfile`](./python/Podmanfile)

## 🚀 Uso

### Imagens Base

Para utilizar uma imagem base, você pode puxá-la diretamente do GitHub Container Registry:

```sh
# Exemplo para a imagem Node.js
docker pull ghcr.io/pagecloudv1/xcloud-nodejs:latest
# ou com Podman
podman pull ghcr.io/pagecloudv1/xcloud-nodejs:latest
```

### Docker Compose (Desenvolvimento Local)

Para desenvolvimento local completo com stack de aplicações:

```bash
cd compose
docker-compose up -d
```

Veja a [documentação completa do Docker](./DOCKER.md) para mais informações sobre:
- Multi-stage builds para produção
- Docker Compose para desenvolvimento e produção
- Health checks e monitoramento
- Troubleshooting

## 🐳 Infraestrutura Docker

O repositório inclui infraestrutura completa para desenvolvimento e produção:

-   **Docker Compose**: Configurações para desenvolvimento local e produção
-   **Multi-stage Builds**: Dockerfiles otimizados para Node.js e Python
-   **Nginx**: Reverse proxy configurado com health checks
-   **Kubernetes**: Manifestos básicos para deploy em clusters K8s
-   **Exemplos**: Aplicações de exemplo para demonstrar o uso

📖 **[Documentação Completa do Docker](./DOCKER.md)**

### Estrutura

```
docker/        # Dockerfiles otimizados para produção
compose/       # Docker Compose para dev e prod
k8s/           # Kubernetes manifests (deployments, services, ingress)
examples/      # Aplicações de exemplo
```

## ⚙️ Automação (CI/CD)

O build e a publicação das imagens são totalmente automatizados usando GitHub Actions.

-   **Processo**: Ao fazer um push para a branch `main` em um dos diretórios de imagem (`base/`, `nodejs/`, `python/`), um workflow é acionado.
-   **Ação**: O workflow constrói a imagem correspondente (e suas dependentes) e a publica no `ghcr.io` com a tag `latest`.
-   **Workflows**: A configuração dos workflows pode ser encontrada em [`.github/workflows`](./.github/workflows).

## 🤝 Contribuição

Contribuições são bem-vindas! Se você deseja adicionar uma nova imagem ou melhorar uma existente, siga os passos:

1.  Crie um novo diretório para sua imagem.
2.  Adicione um `Podmanfile` (ou `Dockerfile`) seguindo o padrão das imagens existentes (baseado em `xcloud-base`).
3.  Crie um novo workflow de publicação em `.github/workflows`.
4.  Abra um Pull Request com suas alterações.
