defmodule WebElixir.Repo do
  use Ecto.Repo,
    otp_app: :web_elixir,
    adapter: Ecto.Adapters.Postgres
end
