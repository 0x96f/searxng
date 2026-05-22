#!/usr/bin/env bash

set -e

if [ -z "${SEARXNG_SECRET:-}" ]; then
  echo "Error: SEARXNG_SECRET is not set" >&2
  exit 1
fi

docker compose up -d

echo ""
echo "SearXNG is starting..."
echo "Search page: http://localhost:9009"
echo "JSON API: http://localhost:9009/search?q=test&format=json"
