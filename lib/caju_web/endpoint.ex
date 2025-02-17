defmodule CajuWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :caju

  @session_options [
    store: :cookie,
    key: "_caju_key",
    signing_salt: "06o5C4Gc",
    same_site: "Lax"
  ]

  plug Plug.Static,
    at: "/",
    from: :caju,
    gzip: false,
    only: CajuWeb.static_paths()

  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :caju
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug CajuWeb.Router
end
