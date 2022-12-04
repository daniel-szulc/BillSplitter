defmodule Splitter.Repo.Migrations.AddBill do
  use Ecto.Migration

  def change do
    create table (:bills) do
      add :title, :string
      add :users, :string
      add :price, :float

      timestamps()
  end
end
end