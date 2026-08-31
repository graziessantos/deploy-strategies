#!/bin/bash
# Uso: ./switch.sh blue   ou   ./switch.sh green
set -e

TARGET=$1
if [[ "$TARGET" != "blue" && "$TARGET" != "green" ]]; then
  echo "Uso: ./switch.sh [blue|green]"
  exit 1
fi

echo "Trocando roteador para: app-$TARGET"

# Reescreve a linha "server app-xxx:80;" com o novo alvo
sed -i "s/server app-[a-z]*:80;/server app-$TARGET:80;/" nginx/nginx.conf

# Recarrega o nginx sem derrubar o container (isso simula a "virada instantânea")
docker compose exec router nginx -s reload

echo "Pronto! Acesse http://localhost:8080 e recarregue a página."
echo "A troca foi instantânea - sem downtime."
