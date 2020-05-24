#!/bin/sh
set -e
# BUILDING THE CONTAINER TAKES A WHILE.
# JUST BE PATIENT.

# Build the container
docker build -t fgo . > /dev/null

# Create a volume to cache go modules
docker volume create fgo-cache > /dev/null

GOOS="$(uname | tr '[:upper:]' '[:lower:]')"

mkdir -p /tmp/fgo/bin

printf 'alias fgo="docker run -it \
    -v \$(pwd):/work \
    -v go-cache:/go/pkg/mod \
    -v /tmp/fgo/bin:/go/bin \
    -e GOOS=%s \
    fgo"\n' "$GOOS"

if [ "$GOOS" = "linux" ]; then
    printf 'export PATH=$PATH:/tmp/fgo/bin\n'
else
    GOARCH="$(docker run fgo env GOARCH)"
    printf 'export PATH=$PATH:/tmp/fgo/bin/%s_%s\n' "$GOOS" "$GOARCH"
fi
