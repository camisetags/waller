use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :waller, WallerWeb.Endpoint,
  secret_key_base: "d840Bs8NA7Q/Elel+dWLU6rW4HGyHjjb68juNVO5LoQAR2dk71zk4uesHtRJX03z"

# Configure your database
config :waller, Waller.Repo,
  username: System.get_env("PGUSER") || "postgres",
  password: System.get_env("PGPASSWORD") || "postgres",
  database: System.get_env("PGDATABASE") || "database_name",
  hostname: System.get_env("PGHOST") || "localhost",
  port: System.get_env("PGPORT") || 54322,
  pool_size: 20

config :waller, Waller.RedixPool,
  host: System.get_env("REDIS_HOST") || "localhost",
  port: System.get_env("REDIS_PORT") || 6932
