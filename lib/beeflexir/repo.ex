defmodule Beeflexir.Repo do
  use Ecto.Repo,
    otp_app: :beeflexir,
    adapter: Ecto.Adapters.Postgres
end
