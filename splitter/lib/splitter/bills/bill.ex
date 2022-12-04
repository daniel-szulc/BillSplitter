defmodule Splitter.Bills.Bill do

  use Ecto.Schema
  import Ecto.Changeset

  schema "bills" do
    field :title, :string
    field :users, :string
    field :price, :float

    timestamps()
  end

  def changeset(bill, params) do
    bill
    |> cast(params, [:title, :users, :price])
  end
end