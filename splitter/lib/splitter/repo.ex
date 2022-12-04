defmodule Splitter.Repo do
  use Ecto.Repo,
    otp_app: :splitter,
    adapter: Ecto.Adapters.Postgres
end
