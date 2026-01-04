import Config

config :web_elixir, WebElixir.Repo,
  url:
    System.get_env("DATABASE_URL") ||
      "postgres://postgres:postgres@localhost:5432/web_elixir_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :web_elixir, WebElixirWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "test_secret_key_base_at_least_64_bytes_long_for_testing_purposes_only",
  server: false

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime
