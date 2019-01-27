# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :waller,
  ecto_repos: [Waller.Repo]

# Configures the endpoint
config :waller, WallerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "F1YXGOf7vIvl0BnwhZQYMDfr01/9VICunfmDzMUPW3aKZsO416o2yaQsrFsKIFwE",
  render_errors: [view: WallerWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Waller.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Poison

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :cors_plug,
  origin: ["http://localhost:3000"],
  max_age: 86400,
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  headers: [
    "Authorization",
    "Content-Type",
    "Accept",
    "Origin",
    "User-Agent",
    "DNT",
    "Cache-Control",
    "X-Mx-ReqToken",
    "Keep-Alive",
    "X-Requested-With",
    "If-Modified-Since",
    "X-CSRF-Token",
    "Access-Control-Allow-Origin"
  ],
  send_preflight_response?: true
