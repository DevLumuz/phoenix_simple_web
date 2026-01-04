defmodule WebElixir.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WebElixirWeb.Telemetry,
      WebElixir.Repo,
      {Phoenix.PubSub, name: WebElixir.PubSub},
      WebElixirWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: WebElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    WebElixirWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
