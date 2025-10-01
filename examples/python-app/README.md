# xCloud Python Example App

Aplicação Python FastAPI de exemplo para demonstrar o uso dos containers xCloud.

## Desenvolvimento Local

```bash
# Com Docker Compose
cd ../../compose
docker-compose up python-app

# Direto com a imagem
docker run -v $(pwd):/home/xcloud/app -p 8000:8000 ghcr.io/pagecloudv1/xcloud-python:latest python main.py
```

## Endpoints

- `GET /` - Informações da aplicação
- `GET /health` - Health check
- `GET /docs` - Documentação Swagger (automática do FastAPI)

## Build para Produção

```bash
cd ../../docker/app
docker build -f Dockerfile.python -t xcloud-python-app:prod ../../examples/python-app
```
