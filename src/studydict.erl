-module(studydict).
-export([testdic/0, testdic2/0, new_dict_and_store/2, double_dict/1, print_keyvalue/1]).


testdic() ->
    D = dict:new(),
    D1 = dict:store(myKey, 100, D),
    D2 = dict:store(myKey2, 200, D1), 
    D3 = dict:store(myKey2, 300, D2),
    
    %% print D3
    dict:map(fun(K, V) -> io:format("~p -> ~p~n", [K, V]) end, D3),
    
    %% double
    D4 = dict:map(fun(K, V) -> V * 2 end, D3), 
    
    %% print D4
    dict:map(fun(K, V) -> io:format("~p -> ~p~n", [K, V]) end, D4),
    
    D5 = dict:update_counter(myKey, 10, D4),
    %% print D5
    dict:map(fun(K, V) -> io:format("~p -> ~p~n", [K, V]) end, D5),
    
    
    D6 = dict:update_counter(myKey, 10, D5),
    %% print D6
    dict:map(fun(K, V) -> io:format("~p -> ~p~n", [K, V]) end, D6).
    
testdic2() ->
    D = new_dict_and_store(mykey, 100),
    print_keyvalue(D),
    D2 = double_dict(D),
    print_keyvalue(D2).
    
%% Key에 매칭되는 Value를 저장하고 새로운 dictionary를 만들기.
new_dict_and_store(Key, Value) ->
    D = dict:new(),
    dict:store(Key, Value, D).

double_dict(Dict) ->
    dict:map(fun(Key, Value) -> Value * 2 end, Dict).

print_keyvalue(Dict) ->
    dict:map(fun(Key, Value) -> io:format("~p -> ~p~n", [Key, Value]) end, Dict).
    
