-module(studymaps).
-compile(export_all).


testmaps() ->
    M = maps:new(),
    M2 = maps:put(uid1, 1111, M),
    M3 = maps:put(uid2, 2222, M2),
    print_maps(M3),
    print_maps(M3,uid1),
    print_maps(M3,uid100),
    
    %% maps에 같은 키의 값을 넣으면 바뀐다. 
    M4 = maps:put(uid2, 3333, M3),
    print_maps(M3),    
    print_maps(M4).
    
    
%% maps의 사이즈 출력, 기본적인 key value출력 
print_maps(Map) ->
    io:format("maps size = ~p~n", [maps:size(Map)]),
    io:format("maps key valye = ~p~n", [Map]).


%% maps에 key가 있으면 key value 출력없으면 없다고 출력
print_maps(Map, Key) ->    
    case maps:find(Key, Map) of
        {ok, FoundValue} -> io:format("found key=~p value=~p~n", [Key, FoundValue]);
        _ -> io:format("not found key=~p~n", [Key])
        end.
    
    
   
    
        
        