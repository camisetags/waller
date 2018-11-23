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
  secret_key_base: "8X1mbNxHXZlkdZG0N2hX26MWok6fo7up+77s4Oc+lIpgO9Wc3+zTLSL41tv+vRXz",
  render_errors: [view: WallerWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Waller.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
