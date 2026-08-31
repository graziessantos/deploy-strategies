#!/bin/bash
# Atualiza os servidores um de cada vez, pausando pra você observar entre cada etapa
set -e

for i in 1 2 3 4; do
  echo ""
  echo "=== Atualizando server$i para a versão 2 ==="
  sed "s/__SERVER__/server$i/" v2/index.html > apps/server$i/index.html
  docker compose restart server$i
  echo "server$i atualizado e voltou ao ar."
  echo "Dica: rode ./watch.sh em outro terminal pra ver a mistura de versões agora."
  read -p "Pressione ENTER para atualizar o próximo servidor..." _
done

echo ""
echo "Rolling update concluído! Todos os servidores estão na versão 2."
