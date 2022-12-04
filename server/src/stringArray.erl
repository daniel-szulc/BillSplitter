-module(stringArray).

-export([stringToArray/5, arrayToString/5]).

setDataToArray(ColNumb,_,Array,_, J) when J == ColNumb->
  Array;

setDataToArray(ColNumb, RowNumb, Array, Row, J) when J < ColNumb ->
  array_2d:set(1,2 ,"XD",Array),

  Ok = string:str(lists:nth(J+1, Row), ".") > 0,
  NewArray = if Ok -> array_2d:set(RowNumb,J, list_to_float(lists:nth(J+1, Row)),Array);
   true ->  array_2d:set(RowNumb,J, list_to_integer(lists:nth(J+1, Row)),Array) end,

  setDataToArray(ColNumb, RowNumb, NewArray, Row, J+1).

stringToArray(_,RowNumb, _,Array, I) when I == RowNumb ->
  Array;

stringToArray(ColNumb, RowNumb, Array, NewArray, I) when I < RowNumb->
  Row = string:tokens(lists:nth(I+1, Array), ","),
  NewNewArray = setDataToArray(ColNumb, I, NewArray, Row, 0),
  stringToArray(ColNumb, RowNumb, Array,  NewNewArray, I+1).

arrayToRows(ColNumb, RowNumb, _, Row, J)  when J == ColNumb ->
  Comma =
    if J==RowNumb+1 -> "";
      true -> "," end,
  Row ++ "]" ++ Comma;

arrayToRows(ColNumb, RowNumb, Array, Row, J)when J < ColNumb ->
  Comma =
    if J==ColNumb-1 -> "";
      true -> "," end,

  Value = array_2d:get(RowNumb, J, Array),
  NewRow = if is_float(Value) ->
    Row ++ float_to_list(array_2d:get(RowNumb, J, Array), [{decimals, 2}]) ++ Comma;
             true ->  Row ++ integer_to_list(array_2d:get(RowNumb, J, Array)) ++ Comma end,

  arrayToRows(ColNumb, RowNumb, Array, NewRow, J+1).

arrayToString(_,RowNumb,_, Result, I) when I == RowNumb ->
  "[" ++ Result ++ "]";

arrayToString(ColNumb, RowNumb, Array, Result, I)  when I < RowNumb->
  NewResult = arrayToRows(ColNumb, I, Array, Result ++"[", 0),
  arrayToString(ColNumb, RowNumb, Array, NewResult, I+1).


