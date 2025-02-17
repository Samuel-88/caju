defmodule Caju.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CajuWeb.Telemetry,
      Caju.Repo,
      {DNSCluster, query: Application.get_env(:caju, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Caju.PubSub},
      CajuWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Caju.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    CajuWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
