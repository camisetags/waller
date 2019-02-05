use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :waller, WallerWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :waller, Waller.Repo,
  username: System.get_env("PGUSER") || "postgres",
  password: System.get_env("PGPASSWORD") || "postgres",
  database: System.get_env("PGTESTDATABASE") || "waller_test_database",
  hostname: System.get_env("PGHOST") || "database",
  port: System.get_env("PGPORT") || 5432,
  pool_size: 10,
  pool: Ecto.Adapters.SQL.Sandbox

config :waller, :redix_pool,
  host: "redis",
  port: System.get_env("REDIS_PORT") || 6379,
  cache_time: System.get_env("REDIS_CACHE_TIME") || 10 * 60

config :waller, :recaptcha_secret, "6Ldlm4UUAAAAAMwECDVBzSuncDBEw5A6EubInKyT"
