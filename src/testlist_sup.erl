-module(testlist_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

%% run command-line with application : erl -pa ./ebin -eval "application:start(testlist)" -s init stop
%% run command-line : erl -pa ./ebin/ -s testlist_sup start_link -s init stop -noshell

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    io:format("testlist_sup init()~n"),
    DataList1 = [1,2,3],
    %%DataList2 = push_list(DataList1, [4,5]),
    DataList2 = push_list(DataList1, [4]),
    io:format("DataList1=~p DataList2=~p~n", [DataList1, DataList2]),
    %%io:format("DataList2=~p~n", [DataList2]),
    
    {ok, { {one_for_one, 5, 10}, []} }.


push_list(DataList, NewData) ->
    lists:append(DataList, NewData).
    
    
    
 

