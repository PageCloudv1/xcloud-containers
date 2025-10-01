#!/bin/bash
# =============================================================================
# xCloud Containers - Validation Script
# =============================================================================
# Validates that all components of the Docker infrastructure are in place
# =============================================================================

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                                                                ║"
echo "║     🔍 xCloud Containers - Infrastructure Validation          ║"
echo "║                                                                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

ERRORS=0

check_file() {
    if [ -f "$1" ]; then
        echo "✅ $1"
    else
        echo "❌ $1 - NOT FOUND"
        ERRORS=$((ERRORS + 1))
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo "✅ $1/"
    else
        echo "❌ $1/ - NOT FOUND"
        ERRORS=$((ERRORS + 1))
    fi
}

echo "📁 Checking Directory Structure"
echo "═══════════════════════════════════════════════════════════════"
check_dir "docker"
check_dir "docker/app"
check_dir "docker/nginx"
check_dir "compose"
check_dir "k8s"
check_dir "examples"
check_dir "examples/nodejs-app"
check_dir "examples/python-app"
echo ""

echo "🐳 Checking Dockerfiles"
echo "═══════════════════════════════════════════════════════════════"
check_file "docker/app/Dockerfile.nodejs"
check_file "docker/app/Dockerfile.python"
check_file "docker/nginx/Dockerfile"
check_file "docker/nginx/nginx-prod.conf"
echo ""

echo "🔧 Checking Docker Compose Files"
echo "═══════════════════════════════════════════════════════════════"
check_file "compose/docker-compose.yml"
check_file "compose/docker-compose.prod.yml"
check_file "compose/nginx.conf"
echo ""

echo "☸️  Checking Kubernetes Manifests"
echo "═══════════════════════════════════════════════════════════════"
check_file "k8s/namespace.yaml"
check_file "k8s/deployment-nodejs.yaml"
check_file "k8s/deployment-python.yaml"
check_file "k8s/service.yaml"
check_file "k8s/ingress.yaml"
echo ""

echo "📚 Checking Documentation"
echo "═══════════════════════════════════════════════════════════════"
check_file "DOCKER.md"
check_file "QUICKSTART.md"
check_file "IMPLEMENTATION.md"
check_file "README.md"
check_file "docker/README.md"
check_file "compose/README.md"
check_file "k8s/README.md"
echo ""

echo "🔬 Checking Example Applications"
echo "═══════════════════════════════════════════════════════════════"
check_file "examples/nodejs-app/package.json"
check_file "examples/nodejs-app/src/index.js"
check_file "examples/nodejs-app/README.md"
check_file "examples/python-app/main.py"
check_file "examples/python-app/requirements.txt"
check_file "examples/python-app/README.md"
echo ""

echo "🔐 Checking Configuration Files"
echo "═══════════════════════════════════════════════════════════════"
check_file ".dockerignore"
check_file ".gitignore"
echo ""

echo "═══════════════════════════════════════════════════════════════"
if [ $ERRORS -eq 0 ]; then
    echo "✅ ALL CHECKS PASSED"
    echo ""
    echo "🎉 Docker Infrastructure is complete and ready to use!"
    echo ""
    echo "📖 Next steps:"
    echo "   1. Read QUICKSTART.md for quick usage guide"
    echo "   2. Read DOCKER.md for complete documentation"
    echo "   3. Try: cd compose && docker-compose up -d"
    echo ""
    exit 0
else
    echo "❌ VALIDATION FAILED: $ERRORS error(s) found"
    echo ""
    exit 1
fi
