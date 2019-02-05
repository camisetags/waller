defmodule Waller.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @redix_host Application.get_env(:waller, :redix_pool)[:host]
  @redix_port Application.get_env(:waller, :redix_pool)[:port]

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Waller.Repo,
      # Start the endpoint when the application starts
      WallerWeb.Endpoint,
      # Starts a worker by calling: Waller.Worker.start_link(arg)
      # {Waller.Worker, arg},
      # Waller.RedixPool
      {Redix, host: @redix_host, port: @redix_port, name: :redix}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Waller.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    WallerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
