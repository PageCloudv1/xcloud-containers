#!/usr/bin/env sh
set -euo pipefail

TAG=${1:-latest}
SKIP_RETAG=${SKIP_RETAG:-0}

REPO_ROOT=$(cd "$(dirname "$0")/.." && pwd)

build_image() {
  name="$1"
  context_dir="$2"
  podmanfile="$3"

  printf '\n=== Building %s:%s ===\n' "$name" "$TAG"
  podman build \
    --file "$podmanfile" \
    --tag "localhost/$name:$TAG" \
    "$context_dir"

  if [ "$SKIP_RETAG" -ne 1 ]; then
    printf 'Tagging %s:%s for ghcr.io\n' "$name" "$TAG"
    podman tag "localhost/$name:$TAG" "ghcr.io/pagecloudv1/$name:$TAG"
  fi
}

cd "$REPO_ROOT"

build_image xcloud-base base base/Podmanfile
build_image xcloud-nodejs nodejs nodejs/Podmanfile
build_image xcloud-python python python/Podmanfile

echo '\nTodas as imagens foram construídas com sucesso.'
