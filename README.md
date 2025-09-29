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

Para utilizar uma imagem, você pode puxá-la diretamente do GitHub Container Registry:

```sh
# Exemplo para a imagem Node.js
podman pull ghcr.io/pagecloudv1/xcloud-nodejs:latest
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
