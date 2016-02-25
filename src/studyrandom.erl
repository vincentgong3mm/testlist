-module(studyrandom).
-export([start/2]).

start(Count, Max) ->
    add_randomValue(Count, Max).


add_randomValue(Count, Max) ->
    add_randomValue([], Count, Max).    
add_randomValue(List, 0, _) ->
    List;
add_randomValue(List, Count, Max) ->
    %%io:format("add_randomValue=~p~n", [random:uniform(Max)]),
    add_randomValue([random:uniform(Max)|List], Count - 1, Max).
