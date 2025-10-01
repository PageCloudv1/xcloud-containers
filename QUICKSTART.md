# 🚀 Quick Start - xCloud Containers

Guia rápido para começar a usar a infraestrutura Docker do xCloud.

## ⚡ Setup Instantâneo

### 1. Clone o repositório

```bash
git clone https://github.com/PageCloudv1/xcloud-containers.git
cd xcloud-containers
```

### 2. Inicie o ambiente de desenvolvimento

```bash
cd compose
docker-compose up -d
```

### 3. Teste as aplicações

```bash
# Node.js app
curl http://localhost:3000/health

# Python app
curl http://localhost:8000/health

# Nginx proxy
curl http://localhost/health
```

## 🎯 Cenários Comuns

### Desenvolvimento de App Node.js

```bash
# 1. Use a imagem base
docker run -it -v $(pwd):/home/xcloud/app \
  -p 3000:3000 \
  ghcr.io/pagecloudv1/xcloud-nodejs:latest \
  bash

# 2. Dentro do container
npm install
npm run dev
```

### Desenvolvimento de App Python

```bash
# 1. Use a imagem base
docker run -it -v $(pwd):/home/xcloud/app \
  -p 8000:8000 \
  ghcr.io/pagecloudv1/xcloud-python:latest \
  bash

# 2. Dentro do container
pip install -r requirements.txt
python main.py
```

### Build para Produção

```bash
# Node.js
cd docker/app
docker build -f Dockerfile.nodejs -t my-app:prod /path/to/app

# Python
cd docker/app
docker build -f Dockerfile.python -t my-app:prod /path/to/app
```

### Deploy com Docker Compose (Produção)

```bash
cd compose
docker-compose -f docker-compose.prod.yml up -d --build
```

## 🛠️ Comandos Úteis

### Ver logs

```bash
docker-compose logs -f
```

### Reiniciar um serviço

```bash
docker-compose restart nodejs-app
```

### Parar todos os serviços

```bash
docker-compose down
```

### Remover volumes também

```bash
docker-compose down -v
```

### Ver status dos containers

```bash
docker-compose ps
```

### Executar comando dentro do container

```bash
docker-compose exec nodejs-app bash
```

## 📚 Documentação Completa

- [DOCKER.md](./DOCKER.md) - Documentação completa do Docker
- [compose/README.md](./compose/README.md) - Docker Compose
- [docker/README.md](./docker/README.md) - Multi-stage Builds

## 🆘 Problemas?

### Port já em uso

Edite o `compose/docker-compose.yml` e mude a porta do host:

```yaml
ports:
  - "3001:3000"  # 3001 é a nova porta no host
```

### Container não inicia

```bash
docker-compose logs container-name
```

### Limpeza completa

```bash
docker-compose down -v
docker system prune -a
```

## 🎓 Próximos Passos

1. Explore as aplicações de exemplo em `examples/`
2. Leia a documentação completa em `DOCKER.md`
3. Customize os Dockerfiles para suas necessidades
4. Configure CI/CD para builds automáticos

---

**Need help?** Abra uma issue ou consulte a [documentação central](https://pagecloudv1.github.io/xcloud-docs/)
