defmodule SplitterWeb.BillsController do
  use SplitterWeb, :controller

  alias Splitter.Bills
  alias Splitter.Bills.Bill

  def index(conn, _params) do
    bills = Bills.list_bills()
    changeset = Bill.changeset(%Bill{}, %{})
    render(conn, "index.html", bills: bills, changeset: changeset)
  end

  def create(conn, %{"bill" => bill_params}) do
    Bills.create_bill(bill_params)
    redirect(conn, to: "/bills")
  end
end