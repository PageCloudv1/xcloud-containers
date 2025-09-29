# Workflows do xCloud Containers

Este diretório contém os workflows do GitHub Actions para o repositório `xcloud-containers`.

## Workflows

### Reutilizáveis

-   [`reusable-build-publish.yml`](./reusable-build-publish.yml): Um workflow reutilizável que constrói uma imagem de contêiner usando Podman/Docker e a publica no GitHub Container Registry (ghcr.io). Ele pode ser chamado por outros workflows para padronizar o processo de publicação.

### Publicação de Imagens

-   [`publish-base.yml`](./publish-base.yml): Disparado em push para `main` no diretório `base/`. Constrói e publica a imagem `ghcr.io/pagecloudv1/xcloud-base`.
-   [`publish-nodejs.yml`](./publish-nodejs.yml): Disparado em push para `main` nos diretórios `nodejs/` ou `base/`. Constrói e publica a imagem `ghcr.io/pagecloudv1/xcloud-nodejs`.
-   [`publish-python.yml`](./publish-python.yml): Disparado em push para `main` nos diretórios `python/` ou `base/`. Constrói e publica a imagem `ghcr.io/pagecloudv1/xcloud-python`.
