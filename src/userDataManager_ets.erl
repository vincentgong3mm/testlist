-module(userDataManager_ets).
-export([start/0, lookUp/1, update/0, select/1, match_conti/1]).
-include("userData_ets.hrl").


start() ->
    %% ets에 record를 저장하는 경우 첫번째가 record name임 그래서, fieldname명시해야 
    %% lookup 에서 검색가능함
    %% 참고
    %%{keypos, Position}
    %%As you may (and should) recall, ETS tables work by storing tuples. The Position parameter holds an integer from 1 to N telling which of each tuple's element shall act as the primary key of the database table. The default key position is set to 1. 
    %% This means you have to be careful if you're using records as each record's first element is always going to be the record's name (remember what they look like in their tuple form). 
    %% If you want to use any field as the key, use {keypos, #RecordName.FieldName}, as it will return the position of FieldName within the record's tuple %% %% representation. 
    
    ets:new(?MODULE, [set, named_table, {keypos, #userInfo.accountId}]),
    
    %% insert test record
    User1 = #userInfo{accountId = 50001, status=kLogIn},
    User2 = #userInfo{accountId = 50002, status=kLogIn, characInfo=#characInfo{level=85}},
    User3 = #userInfo{accountId = 50003, status=kInGame},
    %% 이렇게 하면안됨. 이렇게 하면 record자체가 key가 되어서 fieldname 한개로 lookup못함
    %% ets:insert(?MODULE, [{User1}, {User2}, {User3}]),
    ets:insert(?MODULE, [User1, User2, User3]),
    io:format("~p~n", [ets:match(?MODULE, '$1')]),
    
    lookUp({accountId, 50001}),
    lookUp({accountId, 50002}),
    lookUp({status, kLogIn}),
    lookUp({status, kInGame}),
    
    select({accountId, 5000}),
    
    match_conti({status, kInGame}),
    match_conti({status, kLogIn}),
    ok.
    %%io:format("start ~p~n", [M])
    
    %% . insert test record        
    

%% 키를 기준으로 찾기
%% 대부분 이것만 사용할 것 같음.
lookUp({accountId, AccountId}) ->
    case ets:lookup(?MODULE, AccountId) of
    [User] ->
        io:format("lookup accountId=~p~n", [User]),
        {true, User};
    [] ->
        {false, []}
    end;
    
%% match를 사용해서 record에서 key가 아닌 다른 field를 기준으로 검색하기 
%% 아래 예제는 잘못된 것임.데이터가 여러개 나올 수 있음 그래서, match_conti 참고 필요함
lookUp({status, Status}) ->
    case ets:match_object(?MODULE, #userInfo{status=Status, _='_'}) of
    [User] ->
        io:format("lookUp status 1 =~p~n", [User]),
        {true, User};
    [User, User2] ->
        io:format("lookUp status 2 =~p~p~n", [User, User2]),
        {true, User};
    [] ->
        {false, []}
    end.

%% match를 사용해서 record에서 key가 아닌 다른 field를 기준으로 검색하기 
%% stl map 처럼 iterator 처럼 사용하는 것임. 
match_conti({status, Status, Conti}) ->
    case ets:match_object(Conti) of
    {[User], NewConti} ->
        io:format("match_conti status 2 =~p~n", [User]),
        match_conti({status, Status, NewConti});
    '$end_of_table' ->
        {true, []};    
    [] ->
        {false, []}
    end;
match_conti({status, Status}) ->
    %% 한번에 하나씩 가져오기 
    FetchCount = 1,
    case ets:match_object(?MODULE, #userInfo{status=Status, _='_'}, FetchCount) of
    {[User], Conti} ->
        io:format("match_conti status 1 =~p~n", [User]),
        match_conti({status, Status, Conti});
    [] ->
        {false, []}
    end.

%% select 는 match에 상세 조건(guard)을 넣을 수 있는 것임
%% 좀더 봐야함. 
select({accountId, AccountId}) ->
    io:format("select-----~n"),
    %%case ets:select(?MODULE, [{{'$1', '$2', '_'}, [{'<', '$12', 50002}], ['$$']}]) of
    case ets:select(?MODULE, [{{'$1', '$2', '$3', '_'}, [], ['$$']}]) of
    [User] ->
        io:format("select status 1 =~p~n", [User]),
        {true, User};
    [User, User2] ->
        io:format("select status 2 =~p~p~n", [User, User2]),
        {true, User};
    [User, User2, User3] ->
        io:format("select status 3 =~p~p~p~n", [User, User2, User3]),
        {true, User};
    [] ->
        {false, []}
    end.


update() ->
    ok.
    

%% match   
%% ets:match(userDataManager, {'$1', '$2', kLogIn, {'$3', '$4', '$5', '$6', '$7'}}).
