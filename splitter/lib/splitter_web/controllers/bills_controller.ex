defmodule SplitterWeb.BillsController do
  use SplitterWeb, :controller
  require Logger

  alias Splitter.Bills
  alias Splitter.Bills.Bill
  import Plug.Conn
  import Ecto.Query

  def index(conn, _params) do

    #bills = Bills.list_bills(conn)
    bills = getBillsForIndex(conn)
    users = getUsersForIndex(conn)
    changeset = Bill.changeset(%Bill{}, %{})
    render(conn, "index.html", bills: bills, users: users, changeset: changeset)
  end

  def getBillsForIndex(conn) do
        bills = get_session(conn, "bills")
          case bills do
              nil ->
                  nil
                  _->
                    getBills(conn)
                    end
        end

  def getUsersForIndex(conn) do
    users = get_session(conn, "users")
    case users do
      nil ->
        nil
      _->
        getUsers(conn)
    end
  end



  def trashUser_button(conn, %{"id" => id}) do

    users = getUsersForIndex(conn)

    selectedObj = Enum.find_index(users, fn user -> to_string(user) == to_string(id) end)

    newList = case selectedObj do
      nil ->
        users
      _ ->
        List.delete_at(users, selectedObj)
    end
    newList = case length(newList) do
      0 -> nil
      _-> newList
    end
    binary = :erlang.term_to_binary(newList)
    conn = put_session(conn, "users", binary)

    redirect(conn, to: "/")
  end

  def trash_button(conn, %{"id" => id}) do

    bills = getBillsForIndex(conn)

    changeset = Bill.changeset(%Bill{}, %{})

    selectedObj = Enum.find_index(bills, fn bill -> to_string(Enum.at(bill,3)) == to_string(id) end)

    newList = case selectedObj do
      nil ->
        bills
      _ ->
        List.delete_at(bills, selectedObj)
    end
    binary = :erlang.term_to_binary(newList)
    conn = put_session(conn, "bills", binary)

    redirect(conn, to: "/")
  end

  def getBills(conn) do

    bills = get_session(conn, "bills")
    case bills do
      nil ->
        nil;
      _ ->
        parts = :erlang.binary_to_term(bills)
        parts
    end
    end

  def getUsers(conn) do

    users = get_session(conn, "users")
    case users do
      nil ->
        nil;
      _ ->
        parts = :erlang.binary_to_term(users)
        parts
    end
  end

  def createUser(conn, %{"bill" => user_params}) do
    Logger.info "New User"
    Logger.info user_params
    user = user_params["user"]

    users = getUsers(conn)

    newList = case users do
      nil->[user];
      _->users ++ [user]
    end

    binary = :erlang.term_to_binary(newList)
    conn = put_session(conn, "users", binary)

    redirect(conn, to: "/")
  end

  def create(conn, %{"bill" => bill_params}) do

    Logger.info "New Bill"

    title = bill_params["title"]
    price = bill_params["price"]
    users = getUsers(conn)

    checkboxes = Enum.map(users, fn user -> Map.get(bill_params, "checkbox_#{user}") end)
    Logger.info checkboxes
   # users = bill_params["users"]

    bills = getBills(conn)

    id= case bills do
      nil ->0;
      _-> case length(bills) do
      nil-> 0;
      0->0;
      _->
        Enum.at((Enum.at(bills, length(bills)-1)), 3)+1
    end
    end

    new_bill = [title, price, users, id]

    newList = case bills do
      nil->[new_bill];
      _->bills ++ [new_bill]
    end

    binary = :erlang.term_to_binary(newList)
    conn = put_session(conn, "bills", binary)

    redirect(conn, to: "/")
  end

end