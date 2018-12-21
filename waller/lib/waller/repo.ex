defmodule Waller.Repo do
  use Ecto.Repo,
    otp_app: :waller,
    adapter: Ecto.Adapters.Postgres
end
