%%-module(splitter_test).
%%
%%-export([split/1]).
%%
%%%%% Split the bill using a least number of transactions algorithm
%%split(Debts) ->
%%% calculate total debt
%%  TotalDebt = sum(Debts),
%%
%%  % calculate average debt per person
%%  AverageDebt = round(TotalDebt / size(Debts)),
%%
%%% create a list of payments to be made, where the first element is the person
%%% making the payment and the second element is the amount to be paid
%%  Payments = [{Pid, Paid} || Pid <- lists:seq(1, size(Debts)), Paid <- Debts],
%%
%%% sort the payments by the amount of debt, ascending
%%  PaymentsSorted = lists:sort(Payments, fun({_, Paid1}, {_, Paid2}) -> Paid1 < Paid2 end),
%%
%%% initialize list of transactions to be empty
%%  Transactions = [],
%%
%%% iterate over the sorted payments
%%  iterate(PaymentsSorted, AverageDebt, Transactions).
%%
%%%%% Iterate over the sorted payments and calculate the transactions
%%iterate([], _, Transactions) ->
%%% return the list of transactions
%%  Transactions;
%%iterate([{Pid, Paid}|Rest], AverageDebt, Transactions) ->
%%% calculate the difference between the average debt and the current payment
%%  Diff = AverageDebt - Paid,
%%
%%  % if the difference is positive, the current person needs to receive money
%%% from another person, so we add a transaction to the list
%%  if Diff > 0 ->
%%    Transactions1 = [{Pid, Pid1, Diff}|Transactions],
%%    iterate(Rest, AverageDebt, Transactions1);
%%
%%% if the difference is zero, the current person's debt is equal to the
%%% average debt, so no transaction is needed
%%    Diff == 0 ->
%%      Transactions1 = Transactions,
%%      iterate(Rest, AverageDebt, Transactions1);
%%
%%% if the difference is negative, the current person needs to pay money
%%% to another person, so we add a transaction to the list
%%    true ->
%%      Transactions1 = [{Pid1, Pid, abs(Diff)}|Transactions],
%%      iterate(Rest, AverageDebt, Transactions1)
%%  end.
