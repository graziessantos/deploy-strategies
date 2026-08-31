#!/bin/bash
# Uso: ./set-canary-weight.sh 5     -> 5% do tráfego pro canário, 95% pro estável
# Uso: ./set-canary-weight.sh 50    -> 50/50
# Uso: ./set-canary-weight.sh 100   -> promove o canário totalmente (vira o novo estável)
set -e

CANARY=$1
if ! [[ "$CANARY" =~ ^[0-9]+$ ]] || [ "$CANARY" -lt 0 ] || [ "$CANARY" -gt 100 ]; then
  echo "Uso: ./set-canary-weight.sh <0-100>"
  exit 1
fi

STABLE=$((100 - CANARY))
[ "$STABLE" -eq 0 ] && STABLE=1   # nginx exige weight >= 1
[ "$CANARY" -eq 0 ] && CANARY=1

cat > nginx/nginx.conf << EOF
events {}

http {
    upstream backend {
        server stable:80 weight=$STABLE;
        server canary:80 weight=$CANARY;
    }

    server {
        listen 80;
        location / {
            proxy_pass http://backend;
            proxy_set_header Connection "";
        }
    }
}
EOF

docker compose exec router nginx -s reload
echo "Pesos atualizados: stable=$STABLE canary=$CANARY"
echo "Rode ./watch.sh para ver a distribuição de tráfego."
