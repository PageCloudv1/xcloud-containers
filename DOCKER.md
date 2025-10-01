# 🐳 xCloud Docker Infrastructure

Este documento descreve a infraestrutura completa de containers Docker do ecossistema xCloud.

## 📋 Índice

- [Estrutura do Projeto](#estrutura-do-projeto)
- [Desenvolvimento Local](#desenvolvimento-local)
- [Produção](#produção)
- [Multi-Stage Builds](#multi-stage-builds)
- [Health Checks](#health-checks)
- [Troubleshooting](#troubleshooting)

## 🏗️ Estrutura do Projeto

```
xcloud-containers/
├── docker/                    # Dockerfiles otimizados
│   ├── app/
│   │   ├── Dockerfile.nodejs  # Multi-stage para Node.js
│   │   └── Dockerfile.python  # Multi-stage para Python
│   └── nginx/
│       ├── Dockerfile         # Nginx reverse proxy
│       └── nginx-prod.conf    # Configuração de produção
├── compose/                   # Docker Compose
│   ├── docker-compose.yml     # Desenvolvimento
│   ├── docker-compose.prod.yml # Produção
│   └── nginx.conf             # Configuração Nginx para dev
├── examples/                  # Aplicações de exemplo
│   ├── nodejs-app/
│   └── python-app/
└── base/                      # Imagens base (Podmanfiles)
    ├── nodejs/
    └── python/
```

## 🚀 Desenvolvimento Local

### Iniciando o Stack Completo

```bash
cd compose
docker-compose up -d
```

Isso iniciará:
- **Node.js App** em `http://localhost:3000`
- **Python App** em `http://localhost:8000`
- **Nginx Proxy** em `http://localhost:80`

### Testando Individualmente

#### Node.js App

```bash
# Com a imagem base
docker run -v $(pwd)/examples/nodejs-app:/home/xcloud/app \
  -p 3000:3000 \
  ghcr.io/pagecloudv1/xcloud-nodejs:latest \
  npm run dev

# Testar
curl http://localhost:3000/health
```

#### Python App

```bash
# Com a imagem base
docker run -v $(pwd)/examples/python-app:/home/xcloud/app \
  -p 8000:8000 \
  ghcr.io/pagecloudv1/xcloud-python:latest \
  python main.py

# Testar
curl http://localhost:8000/health
```

### Logs e Debugging

```bash
# Ver logs de todos os serviços
docker-compose logs -f

# Ver logs de um serviço específico
docker-compose logs -f nodejs-app

# Executar comandos dentro do container
docker-compose exec nodejs-app bash
```

## 🏭 Produção

### Build das Imagens de Produção

#### Node.js

```bash
cd docker/app
docker build -f Dockerfile.nodejs -t xcloud-nodejs-app:prod ../../examples/nodejs-app
```

#### Python

```bash
cd docker/app
docker build -f Dockerfile.python -t xcloud-python-app:prod ../../examples/python-app
```

#### Nginx

```bash
cd docker/nginx
docker build -t xcloud-nginx:prod .
```

### Deploy com Docker Compose (Produção)

```bash
cd compose
docker-compose -f docker-compose.prod.yml up -d
```

## 🔨 Multi-Stage Builds

### Node.js Multi-Stage Build

O `Dockerfile.nodejs` usa 3 stages:

1. **dependencies**: Instala todas as dependências
2. **build**: Compila o código (se necessário)
3. **production**: Imagem final otimizada

**Vantagens:**
- Imagem final menor (~100MB vs ~500MB)
- Apenas dependências de produção
- Build cache otimizado

### Python Multi-Stage Build

O `Dockerfile.python` usa 2 stages:

1. **builder**: Instala dependências em virtual environment
2. **production**: Imagem final com runtime mínimo

**Vantagens:**
- Remove ferramentas de build (gcc, g++, make)
- Virtual environment isolado
- Imagem final otimizada (~150MB vs ~400MB)

## 🏥 Health Checks

Todos os containers incluem health checks configurados:

```yaml
healthcheck:
  test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:PORT/health"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

### Verificando Health Status

```bash
# Status de todos os containers
docker ps

# Detalhes do health check
docker inspect --format='{{json .State.Health}}' container-name | jq
```

### Implementando Health Checks em Suas Apps

#### Node.js (Express)

```javascript
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});
```

#### Python (FastAPI)

```python
@app.get("/health")
async def health_check():
    return {"status": "healthy"}
```

## 🔧 Configurações Avançadas

### Resource Limits (Produção)

O `docker-compose.prod.yml` inclui limites de recursos:

```yaml
deploy:
  resources:
    limits:
      cpus: '1'
      memory: 512M
    reservations:
      cpus: '0.5'
      memory: 256M
```

### Logging

Configuração de logs rotacionados:

```yaml
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

### Networks

Rede dedicada para isolamento:

```yaml
networks:
  xcloud-network:
    driver: bridge
    name: xcloud-prod-network
```

## 🐛 Troubleshooting

### Container não inicia

```bash
# Ver logs
docker logs container-name

# Ver últimas 50 linhas
docker logs --tail 50 container-name

# Seguir logs em tempo real
docker logs -f container-name
```

### Health Check falhando

```bash
# Verificar se o endpoint existe
docker exec container-name wget -O- http://localhost:PORT/health

# Verificar se a aplicação está rodando
docker exec container-name ps aux
```

### Problemas de permissão

```bash
# Verificar usuário do processo
docker exec container-name whoami

# Verificar permissões dos arquivos
docker exec container-name ls -la /home/xcloud/app
```

### Container reiniciando constantemente

```bash
# Ver histórico de eventos
docker events --filter container=container-name

# Verificar resource limits
docker stats container-name
```

### Problemas de rede

```bash
# Ver networks
docker network ls

# Inspecionar network
docker network inspect xcloud-network

# Testar conectividade entre containers
docker exec nodejs-app ping python-app
```

### Limpeza de recursos

```bash
# Parar e remover todos os containers
docker-compose down

# Remover volumes também
docker-compose down -v

# Limpeza geral do Docker
docker system prune -a
```

## 📊 Monitoramento

### Métricas em Tempo Real

```bash
# Stats de todos os containers
docker stats

# Stats de um container específico
docker stats container-name
```

### Exportar Logs

```bash
# Salvar logs em arquivo
docker-compose logs > logs.txt

# Logs em formato JSON
docker inspect --format='{{json .}}' container-name > container-info.json
```

## 🔐 Segurança

### Boas Práticas Implementadas

1. **Usuário não-root**: Todos os containers rodam como `xcloud` user
2. **Imagens mínimas**: Base Alpine Linux
3. **Multi-stage builds**: Apenas runtime na imagem final
4. **Health checks**: Detecção automática de problemas
5. **Resource limits**: Prevenção de resource exhaustion
6. **Security headers**: Configurados no Nginx

### Scanning de Vulnerabilidades

```bash
# Com Trivy
trivy image ghcr.io/pagecloudv1/xcloud-nodejs:latest

# Com Docker Scout
docker scout cves ghcr.io/pagecloudv1/xcloud-nodejs:latest
```

## 📚 Referências

- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Multi-stage Builds](https://docs.docker.com/build/building/multi-stage/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Health Checks](https://docs.docker.com/engine/reference/builder/#healthcheck)

## 🆘 Suporte

Para problemas ou dúvidas:
1. Consulte a [documentação central](https://pagecloudv1.github.io/xcloud-docs/)
2. Abra uma issue no repositório
3. Entre em contato com a equipe xCloud

---

**Última atualização**: Janeiro 2025
**Versão**: 1.0.0
