-module(splitter_server).
-export([start/0, start/1]).
-define(TIMEOUT, 20000).
start() ->
  start(5700).

start(Port) ->
  io:fwrite("Server started on port ~p | http://localhost:~p/", [Port, Port] ),
  spawn(fun () -> {ok, Sock} = gen_tcp:listen(Port, [binary, {packet, 0}, {active, false}]),
    loop(Sock) end).



loop(Sock) ->

  {ok, Conn} = gen_tcp:accept(Sock),

  Handler = spawn(fun () -> handle(Conn) end),
  gen_tcp:controlling_process(Conn, Handler),
  loop(Sock).


handle(Conn) ->
  {ok, A} = gen_tcp:recv(Conn,0),
  ListaString =  binary_to_list(A),
  io:fwrite("Zapytanie: ~p\n",[ListaString]),
  Response = if ListaString /= "favicon.ico" ->
  Lista = string:tokens(ListaString, ";"),
  RowsNumb = length(string:tokens(ListaString, ";")),
  ColNumb = length(string:tokens(lists:nth(1, Lista), ",")),
  io:fwrite("Rows: ~p\nColumns: ~p\n",[RowsNumb,ColNumb]),
  XD  = array_2d:new(RowsNumb,ColNumb),
  NewArray = stringArray:stringToArray(ColNumb,RowsNumb, Lista, XD, 0),
  SplittedArray = splitter:splitBill(NewArray, ColNumb, RowsNumb),
  Before = stringArray:arrayToString(ColNumb, RowsNumb, NewArray, "", 0),
  io:fwrite( "Input Array:\n ~p \n\n", [Before]),
  Result = stringArray:arrayToString(ColNumb, RowsNumb, SplittedArray, "", 0),
  io:fwrite( "Output Array:\n ~p \n\n", [Result]),
    Result;
    true -> "" end,
 gen_tcp:send(Conn, Response),
  gen_tcp:close(Conn).

%%response(Str) ->
%%  B = iolist_to_binary(Str),
%%  iolist_to_binary(
%%    io_lib:fwrite(
%%      "HTTP/1.0 200 OK\nContent-Type: text/html\nContent-Length: ~p\n\n~s",
%%      [size(B), B])).