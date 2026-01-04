# WebElixir - CRUD de Productos

Phoenix + PostgreSQL, listo para Railway.

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

## Deploy en Railway

### Variables de Entorno

| Variable | Descripción |
|----------|-------------|
| `DATABASE_URL` | Railway la genera al agregar PostgreSQL |
| `SECRET_KEY_BASE` | Generar con `mix phx.gen.secret` |
| `PHX_HOST` | `tu-app.up.railway.app` |
| `PORT` | Railway lo asigna automáticamente |

### Pasos

1. Crear proyecto en Railway
2. Agregar PostgreSQL desde "Add Service"
3. Conectar repo de GitHub
4. Agregar variables de entorno
5. En Settings > Deploy, configurar:
   - Build Command: `mix deps.get && mix assets.deploy && mix compile`
   - Start Command: `mix ecto.migrate && mix phx.server`

### Generar SECRET_KEY_BASE

```bash
mix phx.gen.secret
```
