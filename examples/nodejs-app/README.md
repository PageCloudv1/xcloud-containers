# xCloud Node.js Example App

Aplicação Node.js de exemplo para demonstrar o uso dos containers xCloud.

## Desenvolvimento Local

```bash
# Com Docker Compose
cd ../../compose
docker-compose up nodejs-app

# Direto com a imagem
docker run -v $(pwd):/home/xcloud/app -p 3000:3000 ghcr.io/pagecloudv1/xcloud-nodejs:latest npm run dev
```

## Endpoints

- `GET /` - Informações da aplicação
- `GET /health` - Health check

## Build para Produção

```bash
cd ../../docker/app
docker build -f Dockerfile.nodejs -t xcloud-nodejs-app:prod ../../examples/nodejs-app
```
