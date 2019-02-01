use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :waller, WallerWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :waller, Waller.Repo,
  username: "postgres",
  password: "postgres",
  database: "waller_test",
  hostname: "localhost",
  port: 54322,
  pool: Ecto.Adapters.SQL.Sandbox

config :waller, :redix_pool,
  # host: System.get_env("REDIS_HOST") || "redis",
  host: "redis",
  port: System.get_env("REDIS_PORT") || 6379,
  cache_time: System.get_env("REDIS_CACHE_TIME") || 10 * 60

config :waller, :recaptcha_secret, "6Ldlm4UUAAAAAMwECDVBzSuncDBEw5A6EubInKyT"
