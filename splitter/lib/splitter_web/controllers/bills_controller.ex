defmodule SplitterWeb.BillsController do
  use SplitterWeb, :controller

  use Phoenix.LiveView
  require Logger

  alias Splitter.Bills
  alias Splitter.Bills.Bill
  import Plug.Conn

  import Ecto.Query
  import Kernel

  def index(conn, _params) do

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


    bills = getBills(conn)

    value_exists = Enum.any?(bills, fn bill -> Enum.any?(Enum.at(bill,2), fn users ->  users == {id, "true"} end) end)  ||  Enum.any?(bills, fn bill -> Enum.at(bill,4)== id end)

    case value_exists do
      true ->
        conn = Phoenix.Controller.put_flash(conn, :alert, "Nie można usunąć osoby " <> id <> ", ponieważ istnieje rachunek powiązany!")
        Phoenix.Controller.redirect(conn, to: "/")
      _ ->
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

        Phoenix.Controller.redirect(conn, to: "/")

    end


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

    Phoenix.Controller.redirect(conn, to: "/")
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

  def string_to_num(string) do
    try do
      String.to_integer(string)
    rescue
      ArgumentError -> String.to_float(string)
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

    Phoenix.Controller.redirect(conn, to: "/")
  end



    def calcArrayBills(-1,_,_,array) do array end

    def calcArrayBills(n, bills,users,array) do
      bill = Enum.at(bills,n)
    payer = Enum.at(bill,4)
    payerIndex = Enum.find_index(users, fn user -> to_string(user) == to_string(payer) end)
    value = Enum.at(bill,1)
    countUsers= Enum.count(Enum.at(bill,2), &(elem(&1, 1) == "true"))
    splitValue= string_to_num(value)/countUsers
    newArray = calcArrayUsers(length(Enum.at(bill,2))-1, Enum.at(bill,2), users, payerIndex,splitValue, array)
    calcArrayBills(n-1, bills,users,newArray)
  end

    def calcArrayUsers(-1, _,_,_,_,array) do array end

    def calcArrayUsers(n, bill, users, payerIndex,splitValue, array) do
        billUser =  Enum.at(bill,n)

        if elem(billUser, 1) == "true" do
          index = Enum.find_index(users, fn user -> to_string(user) == to_string(elem(billUser, 0)) end)
          new_array =  List.replace_at(array, payerIndex, List.replace_at(Enum.at(array,payerIndex), index,  Enum.at(Enum.at(array,payerIndex),index) + splitValue))
          #  IO.inspect(to_string(elem(billUser, 0)) <> " {" <> to_string(index) <> "} " <> "wisi " <> "index:" <> to_string(payerIndex) <> " kwota:" <> to_string(splitValue))
          # IO.inspect("payerIndex (col): " <> to_string(payerIndex) <> "  index (row): "<> to_string(index) <>  " current value: " <> to_string(Enum.at(Enum.at(array,index),payerIndex)) <>  " add value: " <> to_string(splitValue))

          calcArrayUsers(n-1, bill, users, payerIndex, splitValue, new_array)
          else
        calcArrayUsers(n-1, bill, users, payerIndex, splitValue, array)
      end
  end




  def createArray(conn, param) do
    users = getUsers(conn)
    bills = getBills(conn)

    indexes = length(users)

    row = List.duplicate(0, indexes)
    array = List.duplicate(row, indexes)
    result= calcArrayBills(length(bills)-1, bills,users,array)
    IO.inspect("ARRAY RESULT: ")
    IO.inspect(result)
    list_string = inspect(result)
    list_string = String.replace(list_string, "], [", ";")
    list_string = String.replace(list_string, "]]", "")
    list_string = String.replace(list_string, "[[", "")
    list_string = String.replace(list_string, " ", "")
    IO.inspect(list_string)
    Phoenix.Controller.redirect(conn, to: "/")
  end


  def create(conn, %{"bill" => bill_params}) do

    title = bill_params["title"]
    price = bill_params["price"]
    payer = bill_params["payer"]
    users = getUsers(conn)

    checkboxes = Enum.map(users, fn user ->Map.get(bill_params, "checkbox_#{user}") end)


    usersToSplit = Enum.zip(users, checkboxes)


    anySelected = Enum.any?(usersToSplit, fn user ->  elem(user,1) ==  "true" end)

    usersToSplit = case anySelected do
      false ->
        index = Enum.find_index(usersToSplit, fn user ->  elem(user,0) == payer end)
        List.replace_at(usersToSplit, index, {payer ,"true"})
        _-> usersToSplit
    end

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

    new_bill = [title, price,  usersToSplit,  id, payer]

    newList = case bills do
      nil->[new_bill];
      _->bills ++ [new_bill]
    end

    binary = :erlang.term_to_binary(newList)
    conn = put_session(conn, "bills", binary)

    Phoenix.Controller.redirect(conn, to: "/")
  end

end