defmodule Waller.Repo do
  use Ecto.Repo,
    otp_app: :waller,
    adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 30
end
