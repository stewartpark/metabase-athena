#!/usr/bin/env bash

METABASE_VERSION=$(curl -sSL https://hub.docker.com/v2/repositories/metabase/metabase/tags | jq '.results[].name' | grep -v latest | head -n1 | tr -d \")

echo "Metabase Version: $METABASE_VERSION"

# Build a docker image with the recent metabase + the athena driver
sed "s/VERSION/$METABASE_VERSION/g" Dockerfile.tmpl | \
    docker build -t "stewartpark/metabase-athena:$METABASE_VERSION" -

if [ -n "$PUSH" ]; then
    # Push it to docker hub
    docker push "stewartpark/metabase-athena:$METABASE_VERSION"

    if [ -n "$TAG_LATEST" ]; then
        # Tag this to latest
        docker tag "stewartpark/metabase-athena:$METABASE_VERSION" stewartpark/metabase-athena:latest
        docker push stewartpark/metabase-athena:latest
    fi
fi
