# WebElixir - CRUD de Productos

Phoenix + PostgreSQL, listo para Fly.io.

## Setup Local

```bash
cp .env.example .env
# Editar .env con tu DB local
make setup
make server
```

Abrir http://localhost:4000

## Comandos

```bash
make setup      # Instalar deps + crear DB + migrar + seeds
make server     # Iniciar servidor
make db.migrate # Ejecutar migraciones
make db.seed    # Poblar datos de prueba
```

## Deploy en Fly.io

### 1. Instalar CLI

```bash
curl -L https://fly.io/install.sh | sh
```

### 2. Login y Launch

```bash
fly auth login
fly launch
```

Cuando pregunte, acepta crear la base de datos Postgres.

### 3. Configurar SECRET_KEY_BASE

```bash
mix phx.gen.secret
fly secrets set SECRET_KEY_BASE=<tu_secret>
```

### 4. Deploy

```bash
fly deploy
```

### 5. Ejecutar migraciones

```bash
fly ssh console -C "/app/bin/migrate"
```

### Comandos útiles

```bash
fly status      # Ver estado
fly logs        # Ver logs
fly ssh console # Conectar al servidor
fly open        # Abrir app en browser
```
