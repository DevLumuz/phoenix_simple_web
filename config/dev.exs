import Config

# En dev, carga .env si existe
if File.exists?(".env") do
  File.read!(".env")
  |> String.split("\n", trim: true)
  |> Enum.reject(&String.starts_with?(&1, "#"))
  |> Enum.each(fn line ->
    case String.split(line, "=", parts: 2) do
      [key, value] -> System.put_env(String.trim(key), String.trim(value))
      _ -> :ok
    end
  end)
end

config :web_elixir, WebElixir.Repo,
  url:
    System.get_env("DATABASE_URL", "postgres://postgres:postgres@localhost:5432/web_elixir_dev"),
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :web_elixir, WebElixirWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: String.to_integer(System.get_env("PORT", "4000"))],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base:
    "dev_secret_key_base_at_least_64_bytes_long_for_development_only_change_in_prod",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:web_elixir, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:web_elixir, ~w(--watch)]}
  ]

config :web_elixir, WebElixirWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"lib/web_elixir_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

config :web_elixir, dev_routes: true
config :logger, :console, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime
