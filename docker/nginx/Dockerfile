# =============================================================================
# Dockerfile for Nginx Reverse Proxy
# =============================================================================
# Nginx otimizado para servir como reverse proxy no ecossistema xCloud
# =============================================================================
FROM nginx:alpine

LABEL maintainer="xCloud Team <contact@xcloud.com>"
LABEL description="Optimized Nginx reverse proxy for xCloud applications"

# Remove configuração padrão
RUN rm -rf /etc/nginx/conf.d/default.conf

# Copia configuração customizada
COPY nginx-prod.conf /etc/nginx/nginx.conf

# Cria diretórios necessários
RUN mkdir -p /var/cache/nginx /var/log/nginx && \
    chown -R nginx:nginx /var/cache/nginx /var/log/nginx

# Expõe portas HTTP e HTTPS
EXPOSE 80 443

# Health check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost/health || exit 1

# Usa usuário não-root
USER nginx

# Comando padrão
CMD ["nginx", "-g", "daemon off;"]
