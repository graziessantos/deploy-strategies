#!/bin/bash
# Faz várias requisições seguidas e mostra qual versão/servidor respondeu cada uma
PORT=${1:-8081}
echo "Batendo 12 requisições em http://localhost:$PORT ..."
for i in $(seq 1 12); do
  curl -s "http://localhost:$PORT" | grep -E "VERSÃO|Respondido" | tr -d '\n'
  echo ""
  sleep 0.3
done
