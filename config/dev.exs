import Config

config :caju, Caju.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "caju_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :caju, CajuWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "OdKGbY+CCwigI67cCxg+GdSSmXrbaleRJQdNk2Urwo8ip5+C4ldpl3zRtqqi8mjW",
  watchers: []

config :caju, dev_routes: true

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
