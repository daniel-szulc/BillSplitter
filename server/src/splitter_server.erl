-module(splitter_server).
-export([start/0, start/1]).
-define(TIMEOUT, 20000).
start() ->
  start(4100).

start(Port) ->
  io:fwrite("Server started on port ~p | http://localhost:~p/", [Port, Port] ),
  spawn(fun () -> {ok, Sock} = gen_tcp:listen(Port, [{active, false}]),
    loop(Sock) end).

setDataToArray(0,_,Array,_) ->
  Array;

setDataToArray(ColNumb, RowNumb, Array, Row) when ColNumb > 0 ->
  io:fwrite("ColNumb: ~p || RowNumb: ~p\n",[ColNumb, RowNumb]),
  NewArray = array_2d:set(RowNumb-1,ColNumb-1, list_to_integer(lists:nth(ColNumb, Row)),Array),
  io:fwrite("Dodano liczbe ~p do ineksu ~px~p\n",[lists:nth(ColNumb, Row), ColNumb-1, RowNumb-1]),
  setDataToArray(ColNumb-1, RowNumb, NewArray, Row).

dataToArray(_,0, _,Array) ->
  Array;

dataToArray(ColNumb, RowNumb, Array, NewArray) when RowNumb > 0 ->
  io:fwrite("Row number ~p\n", [RowNumb]),
  io:fwrite( "~p\n\n", [NewArray]),
  Row = string:tokens(lists:nth(RowNumb, Array), ","),
  NewNewArray = setDataToArray(ColNumb, RowNumb, NewArray, Row),
  dataToArray(ColNumb, RowNumb-1, Array,  NewNewArray).



arrayToRows(0, RowNumb, _, Row) ->
  Comma =
    if RowNumb==1 -> "";
      true -> "," end,
  Row ++ "]" ++ Comma;

arrayToRows(ColNumb, RowNumb, Array, Row) when ColNumb > 0 ->
  Comma =
    if ColNumb==1 -> "";
      true -> "," end,
  NewRow = Row ++ integer_to_list(array_2d:get(RowNumb-1, ColNumb-1, Array)) ++ Comma,
  arrayToRows(ColNumb-1, RowNumb, Array, NewRow).

arrayToData(_,0,_, Result) ->
  "[" ++ Result ++ "]";

arrayToData(ColNumb, RowNumb, Array, Result) when RowNumb > 0 ->
  NewResult = arrayToRows(ColNumb, RowNumb, Array, Result ++"["),
  arrayToData(ColNumb, RowNumb-1, Array, NewResult).



loop(Sock) ->

  {ok, Conn} = gen_tcp:accept(Sock),

  Handler = spawn(fun () -> handle(Conn) end),
  gen_tcp:controlling_process(Conn, Handler),
  loop(Sock).


handle(Conn) ->
  io:fwrite("\n"),
  io:fwrite("\n"),
  {ok, A} = gen_tcp:recv(Conn,0),

  Chunks = string:lexemes(A, " "),
  %io:fwrite("~p\n",[Chunks]),
  io:fwrite("Zapytanie: ~p\n",[lists:nth(2, Chunks)]),

  ListaString = lists:delete($/, lists:nth(2, Chunks)),
  {BeforeRes, Response} = if ListaString /= "favicon.ico" ->
  Lista = string:tokens(ListaString, ";"),
  io:fwrite("Zapytanie: ~p\n",[Lista]),
  RowsNumb = length(string:tokens(ListaString, ";")),
  ColNumb = length(string:tokens(lists:nth(1, Lista), ",")),

  io:fwrite("Rows: ~p\n Columns: ~p\n",[RowsNumb,ColNumb]),
  XD  = array_2d:new(RowsNumb,ColNumb),
  NewArray = dataToArray(ColNumb,RowsNumb, Lista, XD),
  io:fwrite( "\n\n~p\n\n", [NewArray]),
  io:fwrite("Get element 1x1: ~p\n\n\n\n\n",[array_2d:get(1,1, NewArray)]),

  SplittedArray = splitter:splitBill(NewArray, ColNumb, RowsNumb),
  io:fwrite( "\n\n ~p \n\n", [SplittedArray]),


  Before = arrayToData(ColNumb, RowsNumb, NewArray, ""),
  Result = arrayToData(ColNumb, RowsNumb, SplittedArray, ""),
  io:fwrite( "\n\n ~p \n\n", [Result]),
    {Before, Result}
  end,


  gen_tcp:send(Conn, response("Dane wejsciwowe:\n" ++ BeforeRes ++ "\n\n" ++ "Wynik:\n" ++ Response)),
  gen_tcp:close(Conn).

response(Str) ->
  B = iolist_to_binary(Str),
  iolist_to_binary(
    io_lib:fwrite(
      "HTTP/1.0 200 OK\nContent-Type: text/html\nContent-Length: ~p\n\n~s",
      [size(B), B])).