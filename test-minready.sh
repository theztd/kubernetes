#!/bin/bash
set -e

# Image verze odpovidajici pozadavkum Kubernetes (Go 1.25+)
BUILD_IMAGE="registry.k8s.io/build-image/kube-cross:v1.36.0-go1.25.6-bullseye.0"

echo "=== 1. Generování kódu (update-codegen) ==="
docker run --rm \
  -v "$(pwd):/go/src/k8s.io/kubernetes" \
  -w "/go/src/k8s.io/kubernetes" \
  "$BUILD_IMAGE" \
  hack/update-codegen.sh

echo "=== 2. Spouštění testů (endpointslice) ==="
docker run --rm \
  -v "$(pwd):/go/src/k8s.io/kubernetes" \
  -w "/go/src/k8s.io/kubernetes" \
  "$BUILD_IMAGE" \
  go test -v ./staging/src/k8s.io/endpointslice/...

echo "=== Hotovo ==="

