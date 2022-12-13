defmodule Splitter.Bills do
  alias Splitter.Bills.Bill
  alias Splitter.Repo
  import Ecto.Query

  def get_bill(id) do
    Repo.get(Bill, id)
  end

  def list_bills(conn) do

  end

#  def list_bills() do
#    query = Bill |> order_by(desc: :id)
#    Repo.all(query)
#  end

  def delete_bill(id) do
    bill = Repo.get(Bill, id)
    Repo.delete(bill)
  end

  def create_bill(params) do
    %Bill{}
    |> Bill.changeset(params)
  end
end