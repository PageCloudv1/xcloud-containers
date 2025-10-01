# 🚢 Kubernetes Manifests - xCloud Containers

Manifestos Kubernetes básicos para deploy das aplicações xCloud.

## 📋 Arquivos

- `namespace.yaml` - Namespace xcloud
- `deployment-nodejs.yaml` - Deployment da aplicação Node.js
- `deployment-python.yaml` - Deployment da aplicação Python
- `service.yaml` - Services (ClusterIP) para as aplicações
- `ingress.yaml` - Ingress para expor as aplicações (opcional)

## 🚀 Deploy Rápido

### 1. Criar namespace

```bash
kubectl apply -f namespace.yaml
```

### 2. Deploy das aplicações

```bash
# Deploy Node.js
kubectl apply -f deployment-nodejs.yaml

# Deploy Python
kubectl apply -f deployment-python.yaml
```

### 3. Criar services

```bash
kubectl apply -f service.yaml
```

### 4. Verificar deployments

```bash
kubectl get all -n xcloud
```

## 📦 Deploy Completo

```bash
# Deploy tudo de uma vez
kubectl apply -f k8s/

# Verificar status
kubectl get pods -n xcloud
kubectl get services -n xcloud
```

## 🔍 Verificação

### Ver logs

```bash
# Logs do Node.js
kubectl logs -f deployment/xcloud-nodejs-app -n xcloud

# Logs do Python
kubectl logs -f deployment/xcloud-python-app -n xcloud
```

### Testar aplicação

```bash
# Port forward para testar localmente
kubectl port-forward -n xcloud service/xcloud-nodejs-service 3000:80
kubectl port-forward -n xcloud service/xcloud-python-service 8000:80

# Testar
curl http://localhost:3000/health
curl http://localhost:8000/health
```

### Escalar replicas

```bash
# Aumentar replicas
kubectl scale deployment/xcloud-nodejs-app -n xcloud --replicas=5

# Verificar
kubectl get pods -n xcloud
```

## 🏥 Health Checks

Os deployments incluem:

**Liveness Probe**: Verifica se o container está vivo
- Path: `/health`
- Intervalo: 10s
- Timeout: 5s

**Readiness Probe**: Verifica se o container está pronto para receber tráfego
- Path: `/health`
- Intervalo: 5s
- Timeout: 3s

## 📊 Resource Limits

Cada pod tem:

**Requests** (garantido):
- Memory: 256Mi
- CPU: 250m (0.25 core)

**Limits** (máximo):
- Memory: 512Mi
- CPU: 500m (0.5 core)

## 🔐 Segurança

Implementado:
- ✅ `runAsNonRoot: true`
- ✅ `runAsUser: 1000`
- ✅ `allowPrivilegeEscalation: false`

## 🔄 Atualização

### Rolling Update

```bash
# Atualizar imagem
kubectl set image deployment/xcloud-nodejs-app \
  nodejs-app=ghcr.io/pagecloudv1/xcloud-nodejs:v2.0.0 \
  -n xcloud

# Verificar rollout
kubectl rollout status deployment/xcloud-nodejs-app -n xcloud
```

### Rollback

```bash
# Voltar para versão anterior
kubectl rollout undo deployment/xcloud-nodejs-app -n xcloud

# Verificar histórico
kubectl rollout history deployment/xcloud-nodejs-app -n xcloud
```

## 🗑️ Limpeza

```bash
# Remover tudo
kubectl delete namespace xcloud

# Ou remover individualmente
kubectl delete -f k8s/
```

## 🎯 Próximos Passos

Para produção, considere adicionar:
1. **Ingress Controller** - Expor aplicações externamente
2. **ConfigMaps** - Gerenciar configurações
3. **Secrets** - Armazenar credenciais
4. **HPA** - Auto-scaling horizontal
5. **PodDisruptionBudget** - Garantir disponibilidade
6. **NetworkPolicy** - Controle de rede

## 🔗 Helm Charts

Para deployments mais complexos, veja o diretório `helm/` (em desenvolvimento).

## 📚 Referências

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)
- [xCloud Docker Documentation](../DOCKER.md)
