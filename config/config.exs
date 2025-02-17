import Config

config :caju,
  ecto_repos: [Caju.Repo],
  generators: [timestamp_type: :utc_datetime]

config :caju, CajuWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: CajuWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Caju.PubSub,
  live_view: [signing_salt: "ukSywxix"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
