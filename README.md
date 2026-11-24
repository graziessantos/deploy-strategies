# Demos práticos: Blue-Green, Rolling e Canary

Três demos independentes usando **Docker Compose + Nginx**. Nenhum precisa de Kubernetes
ou infraestrutura de nuvem — tudo roda na sua máquina.

**Pré-requisito:** Docker e Docker Compose instalados (`docker compose version` para checar).

---

## 1. Blue-Green (`blue-green/`)

Dois containers idênticos (`app-blue` e `app-green`) e um roteador (nginx) na frente,
que aponta pra um dos dois. Trocar de versão = trocar o alvo do roteador e recarregar.

```bash
cd blue-green
docker compose up -d
```

Abra **http://localhost:8080** — você verá a página azul (v1).

Agora troque para a versão verde (v2), sem downtime:
```bash
chmod +x switch.sh
./switch.sh green
```

Recarregue a página — ela virou verde instantaneamente. Para reverter:
```bash
./switch.sh blue
```

Isso simula exatamente o que o vídeo descreve: a troca acontece na camada de
roteamento (o `nginx -s reload`), não nos servidores em si. Ambos ficam rodando o
tempo todo — dá pra voltar atrás na hora.

Para encerrar: `docker compose down`

---

## 2. Rolling (`rolling/`)

Quatro servidores idênticos atrás de um roteador que distribui as requisições em
round-robin. O update é aplicado servidor por servidor, um de cada vez.

```bash
cd rolling
docker compose up -d
```

Abra **http://localhost:8081** e recarregue várias vezes — sempre aparece "VERSÃO 1",
mas o servidor que responde varia (server1, server2, server3, server4).

Em um terminal, rode o rollout gradual (ele pausa entre cada servidor pra você observar):
```bash
chmod +x rolling-update.sh watch.sh
./rolling-update.sh
```

Em **outro terminal**, enquanto isso roda, você pode ficar disparando:
```bash
./watch.sh
```
Você vai ver, no meio do processo, uma mistura de "VERSÃO 1" e "VERSÃO 2" nas respostas —
essa é a "janela de versões mistas" que o vídeo menciona.

Para encerrar: `docker compose down`

---

## 3. Canary (`canary/`)

Dois serviços (`stable` e `canary`) atrás de um roteador com balanceamento por peso.
Você controla a % de tráfego que vai para a versão nova.

```bash
cd canary
docker compose up -d
```

Abra **http://localhost:8082** — por padrão está configurado 95% estável / 5% canário.

Veja a distribuição real:
```bash
chmod +x watch.sh set-canary-weight.sh
./watch.sh          # dispara 20 requisições e mostra a versão de cada uma
```
Você deve ver a maioria "VERSÃO ESTÁVEL" e só uma ou duas "VERSÃO CANÁRIO".

Agora aumente a exposição gradualmente, exatamente como no vídeo (5% → 25% → 50% → 100%):
```bash
./set-canary-weight.sh 25
./watch.sh

./set-canary-weight.sh 50
./watch.sh

./set-canary-weight.sh 100   # promove o canário totalmente
./watch.sh
```

Para encerrar: `docker compose down`

