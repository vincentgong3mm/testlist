-module(studyets).
-compile(export_all).

%% Tab = ets:new(mytabName, [ordered_set, named_table]).
%% 이렇게 named_table이라고 하면 아래와 같이 mytabName으로 ets관련호출 가능함.
%% ets:insert(mytabName, {key1, value1}). 
%% named_table 없으면 ets:insert(Tab, {key1, value1}). 로 호출 해야함.



start() ->
    Tab = ets:new(myTable, [ordered_set]),
    ets:insert(Tab, [{gong, 1111}, {seong, 2222}, {bae, 3333}]),
    
    io:format("all member=~p~n", [ets:match_object(Tab, '$1')]),
    
    IsMember = ets:member(Tab, bae),
    show_next(Tab, bae).
    
show_next(Tab, '$end_of_table') ->
    {done};
show_next(Tab, Key) ->
    NextKey = ets:next(Tab, Key),
    io:format("show_next key = ~p~n", [NextKey]),
    show_next(Tab, NextKey).
    
    
 





test_ets() ->
    %% 생성 
    Tab = ets:new(loginUser, [ordered_set]),
    
    %% 추가 
    ets:insert(Tab, [{1, a, b, 100}, {2, b, c, 200}, {3, a, a, 300}]),
    
    %% 검색 
    Value1 = ets:lookup(Tab, 1),
    ValueFirst = ets:first(Tab),
    ValueLast = ets:last(Tab),
    ValueFristNext = ets:next(Tab, ets:first(Tab)),
    TestValue = [Value1, ValueFirst, ValueFirst, ValueLast, ValueFristNext],
    io:format("ets value=~p~n", [TestValue]),
    Tab.
    
 test_match1(Tab) ->
    %% ets의 데이터 중  두번째, 세번째가같은 데이터 중 2,3,4번째 값만  추출 
    ets:match(Tab, {'_', '$1', '$1', '$2'}).
 
test_match2(Tab) ->
    %% ets의 데이터 중  두번째가 a인 데이터 중 3,4번째 값만 추출 
    ets:match(Tab, {'_', a, '$1', '$2'}).
    
test_match3(Tab) ->
    %% ets의 데이터 중  두번째, 세번째가같은 데이터의 키를 포함한 전체(object)  추출 
    ets:match_object(Tab, {'_', '$1', '$1', '$2'}).

    
%% Eshell V7.1  (abort with ^G)
%% 1> c(studyets).
%% {ok,studyets}
%% 2> Tab = studyets:test_ets().
%% ets value=[[{1,a,b,100}],1,1,3,2]
%% 16400
%% 3> studyets:test_match1(Tab).
%% [[a,300]]
%% 4> studyets:test_match2(Tab).
%% [[b,100],[a,300]]
 
