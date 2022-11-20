-module(splitter).

-export([splitBill/3]).

split1(Array, N, M, J, X)  when J < N ->
  Y=J,
  V1=array_2d:get(X,Y,Array),
  V2=array_2d:get(Y,X,Array),
  Diff = V1-V2,
  Array2 = if
             Diff<0 ->
               Array1 = array_2d:set(X,Y,0,Array),
               array_2d:set(Y,X,abs(Diff),Array1);
             Diff>0 ->
               Array1 = array_2d:set(X,Y,Diff,Array),
               array_2d:set(Y,X,0,Array1);
             Diff==0 ->
               Array
           end,
  split1(Array2, N, M, J+1, X);

split1(Array, _,_,_,_) ->
  Array.

split(Array, N, M, I) when I /= N-1 ->
  X=I,
  NewArray=split1(Array, N, M, I+1, X),
  split(NewArray, N, M, I+1);

split(Array,_,_,_) ->
  Array.

splitBill(Array, N, M) ->
  split(Array,N,M,0).


