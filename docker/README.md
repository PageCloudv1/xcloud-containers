# 🐳 Docker Production Images

Dockerfiles otimizados com multi-stage builds para produção.

## 📁 Estrutura

```
docker/
├── app/
│   ├── Dockerfile.nodejs  # Multi-stage para aplicações Node.js
│   └── Dockerfile.python  # Multi-stage para aplicações Python
└── nginx/
    ├── Dockerfile         # Nginx reverse proxy otimizado
    └── nginx-prod.conf    # Configuração de produção
```

## 🏗️ Multi-Stage Builds

### Node.js (Dockerfile.nodejs)

**3 Stages:**
1. `dependencies` - Instala todas as dependências
2. `build` - Compila o código
3. `production` - Imagem final otimizada

**Tamanho da imagem:** ~100MB (vs ~500MB sem multi-stage)

**Build:**
```bash
docker build -f Dockerfile.nodejs -t my-nodejs-app:prod /path/to/app
```

### Python (Dockerfile.python)

**2 Stages:**
1. `builder` - Instala dependências em virtual environment
2. `production` - Runtime mínimo com virtual environment

**Tamanho da imagem:** ~150MB (vs ~400MB sem multi-stage)

**Build:**
```bash
docker build -f Dockerfile.python -t my-python-app:prod /path/to/app
```

### Nginx (Dockerfile)

Nginx otimizado para reverse proxy com:
- Alpine Linux base
- Usuário não-root
- Health checks integrados
- Configuração customizada

**Build:**
```bash
docker build -t my-nginx:prod .
```

## 🚀 Uso

### Build de Aplicação Node.js

```bash
cd docker/app
docker build -f Dockerfile.nodejs -t my-nodejs-app:1.0.0 /path/to/your/nodejs/app
```

**Requisitos da aplicação:**
- `package.json` e `package-lock.json`
- Script `build` (opcional)
- Endpoint `/health` para health check

### Build de Aplicação Python

```bash
cd docker/app
docker build -f Dockerfile.python -t my-python-app:1.0.0 /path/to/your/python/app
```

**Requisitos da aplicação:**
- `requirements.txt`
- `main.py` com ASGI app (FastAPI, etc)
- Endpoint `/health` para health check

### Build de Nginx

```bash
cd docker/nginx
docker build -t my-nginx:1.0.0 .
```

## 🔧 Customização

### Dockerfile.nodejs

#### Mudar porta

```dockerfile
EXPOSE 8080  # Sua porta customizada
```

#### Mudar comando de start

```dockerfile
CMD ["node", "src/server.js"]  # Seu entrypoint
```

#### Adicionar dependências do sistema

```dockerfile
RUN apk add --no-cache \
    imagemagick \
    ffmpeg \
    && rm -rf /var/cache/apk/*
```

### Dockerfile.python

#### Usar Python diferente

Mude a imagem base em `base/Podmanfile` ou use:

```dockerfile
FROM python:3.11-alpine AS builder
```

#### Adicionar dependências do sistema

```dockerfile
RUN apk add --no-cache \
    postgresql-dev \
    && rm -rf /var/cache/apk/*
```

#### Mudar servidor ASGI

```dockerfile
CMD ["gunicorn", "main:app", "-k", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:8000"]
```

### nginx-prod.conf

#### Adicionar novo upstream

```nginx
upstream api_backend {
    server api-service:8080;
}
```

#### Adicionar novo location

```nginx
location /api/ {
    proxy_pass http://api_backend;
    proxy_set_header Host $host;
    # ... outros headers
}
```

#### SSL/TLS

```nginx
server {
    listen 443 ssl http2;
    ssl_certificate /etc/nginx/ssl/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/key.pem;
    # ... configurações SSL
}
```

## 🏥 Health Checks

Todos os Dockerfiles incluem health checks:

```dockerfile
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:PORT/health || exit 1
```

### Implementar endpoint /health

**Node.js:**
```javascript
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});
```

**Python (FastAPI):**
```python
@app.get("/health")
async def health():
    return {"status": "healthy"}
```

## 🔐 Segurança

### Práticas implementadas

✅ **Usuário não-root**
```dockerfile
USER xcloud
```

✅ **Minimal base image** (Alpine Linux)

✅ **Multi-stage builds** (remove build tools)

✅ **No secrets no build**
```dockerfile
# Use build args, não ENV
ARG API_KEY
```

✅ **Scanning de vulnerabilidades**
```bash
trivy image my-app:prod
```

## 📊 Otimização

### Build Cache

Ordene instruções do mais estável ao mais volátil:

```dockerfile
# 1. Dependências do sistema (raramente mudam)
RUN apk add --no-cache packages

# 2. Arquivos de dependências (mudam ocasionalmente)
COPY package.json package-lock.json ./

# 3. Instalar dependências
RUN npm ci

# 4. Código fonte (muda frequentemente)
COPY . .
```

### Tamanho da Imagem

```bash
# Comparar tamanhos
docker images | grep my-app

# Ver camadas
docker history my-app:prod

# Analisar tamanho das camadas
dive my-app:prod
```

## 🧪 Testando Builds

### Build e teste local

```bash
# Build
docker build -f Dockerfile.nodejs -t test-app:local ../../examples/nodejs-app

# Run
docker run -p 3000:3000 test-app:local

# Teste
curl http://localhost:3000/health
```

### Testar multi-stage específico

```bash
# Build apenas até o stage 'build'
docker build --target build -f Dockerfile.nodejs -t test-build ../../examples/nodejs-app

# Inspecionar o stage
docker run -it test-build sh
```

## 📚 Exemplos

Ver diretório `/examples` para aplicações de exemplo que usam esses Dockerfiles:
- `examples/nodejs-app/` - Aplicação Node.js Express
- `examples/python-app/` - Aplicação Python FastAPI

## 🔗 Referências

- [Multi-stage builds](https://docs.docker.com/build/building/multi-stage/)
- [Best practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Health checks](https://docs.docker.com/engine/reference/builder/#healthcheck)
- [xCloud Docker Documentation](../DOCKER.md)
