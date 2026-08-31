#!/bin/bash
# Faz várias requisições e mostra qual versão respondeu cada uma
PORT=${1:-8082}
N=${2:-20}
echo "Batendo $N requisições em http://localhost:$PORT ..."
for i in $(seq 1 "$N"); do
  curl -s "http://localhost:$PORT" | grep -E "VERSÃO|Servidor" | tr -d '\n'
  echo ""
done
