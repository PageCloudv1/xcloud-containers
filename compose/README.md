# 🐳 Docker Compose - xCloud Containers

Configurações Docker Compose para desenvolvimento e produção.

## 📋 Arquivos

- `docker-compose.yml` - Ambiente de desenvolvimento
- `docker-compose.prod.yml` - Ambiente de produção
- `nginx.conf` - Configuração Nginx para desenvolvimento

## 🚀 Uso Rápido

### Desenvolvimento

```bash
# Iniciar todos os serviços
docker-compose up -d

# Iniciar serviço específico
docker-compose up -d nodejs-app

# Ver logs
docker-compose logs -f

# Parar serviços
docker-compose down
```

### Produção

```bash
# Build e iniciar
docker-compose -f docker-compose.prod.yml up -d --build

# Ver status
docker-compose -f docker-compose.prod.yml ps

# Parar
docker-compose -f docker-compose.prod.yml down
```

## 🔌 Endpoints

### Desenvolvimento

- Node.js App: http://localhost:3000
- Python App: http://localhost:8000
- Nginx Proxy: http://localhost:80

### Health Checks

- Node.js: http://localhost:3000/health
- Python: http://localhost:8000/health
- Nginx: http://localhost:80/health

## 📦 Serviços

### nodejs-app

Aplicação Node.js baseada na imagem `ghcr.io/pagecloudv1/xcloud-nodejs:latest`

**Volumes:**
- `../examples/nodejs-app` → `/home/xcloud/app`
- `node_modules` persistente

**Portas:** 3000:3000

### python-app

Aplicação Python baseada na imagem `ghcr.io/pagecloudv1/xcloud-python:latest`

**Volumes:**
- `../examples/python-app` → `/home/xcloud/app`
- `.local` persistente para pacotes

**Portas:** 8000:8000

### nginx

Reverse proxy Nginx

**Volumes:**
- `nginx.conf` → `/etc/nginx/nginx.conf`

**Portas:** 80:80

## 🔧 Customização

### Usar com Sua Própria Aplicação

1. Edite o `docker-compose.yml`
2. Altere o volume path para sua aplicação:

```yaml
volumes:
  - /path/to/your/app:/home/xcloud/app
```

3. Ajuste o comando se necessário:

```yaml
command: npm run dev  # ou seu comando customizado
```

### Adicionar Variáveis de Ambiente

```yaml
environment:
  - NODE_ENV=development
  - DATABASE_URL=postgres://...
  - API_KEY=${API_KEY}
```

### Adicionar Novos Serviços

```yaml
services:
  database:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - xcloud-network

volumes:
  db-data:
```

## 📊 Monitoramento

```bash
# Ver stats em tempo real
docker stats

# Ver logs de todos os serviços
docker-compose logs -f

# Ver logs de um serviço
docker-compose logs -f nodejs-app

# Verificar health
docker ps
```

## 🐛 Troubleshooting

### Port já em uso

```bash
# Mudar a porta no docker-compose.yml
ports:
  - "3001:3000"  # Host:Container
```

### Reiniciar um serviço

```bash
docker-compose restart nodejs-app
```

### Rebuild após mudanças

```bash
docker-compose up -d --build
```

### Remover volumes

```bash
docker-compose down -v
```

## 📚 Referências

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [xCloud Docker Documentation](../DOCKER.md)
