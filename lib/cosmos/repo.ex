defmodule Cosmos.Repo do
  use Ecto.Repo,
    otp_app: :cosmos,
    adapter: Ecto.Adapters.Postgres
end
