%% 기본적인것 된것 같음.
%% 프로세스 생성하고 프로세스에서 데이터관리(읽고/쓰기), 읽기는 아직 구현하지 않았음.
%% 멀티코어 프로그램 할려면
%%  1. 데이터관린하는 프로세스 n개 생성
%%  2. 각 프로세스별로 저장할 정보 분리 예) 13으로 나눈 몫으로 프로세스별 할당(읽고/쓰기)
%%  3. 그럼, 읽기/쓰기가 몰리더라도 분산 할 수 있음.

-module(userDataManager).
-include("userData.hrl").
%%-compile(export_all).
-export([start/0]).

start() ->
    %% spawn(?MODULE, loop, []). or spawn(fun() -> loop() end).
    spawn(fun() -> loop() end).

loop() ->
    Status = init(),
    loop({Status}).

loop({Status}) ->
    receive
        %%{put, accountInfo, AccountId, St} when AccountId > 0 ->
        {put, accountInfo, AccountId, St} ->
            AccountInfo = #accountInfo{accountId=AccountId, status=St},
            {NewStatus, IsTrue} = put({Status, accountInfo, AccountInfo#accountInfo.accountId, AccountInfo}),
            
            printData({NewStatus, IsTrue}),
            
            loop({NewStatus});
        {put, characInfo, CharacNo, CharacName} ->
            CharacInfo = #characInfo{characNo=CharacNo, characName=CharacName},
            {NewStatus, IsTrue} = put({Status, characInfo, CharacInfo#characInfo.characNo, CharacInfo}),
                        
            printData({NewStatus, IsTrue}),
            
            loop({NewStatus});
        %% 에러 테스트용 
        {put, characInfo3, CharacNo, CharacName} ->
            CharacInfo = #characInfo{characNo=CharacNo, characName=CharacName},
            {NewStatus, IsTrue} = put({Status, characInfo3, CharacInfo#characInfo.characNo, CharacInfo}),
                        
            printData({NewStatus, IsTrue}),
            
            loop({NewStatus});
            
        {get, accountInfo, AccountId} ->
            {NewStatus, Record} = getRecord({Status, accountInfo, AccountId}),
            
            printData({NewStatus, Record}),
            
            loop({NewStatus});
            
        %% 아래와 같이 정의되지 않은 메시지 처리하지 않으면 Msgs가 쌓이게됨. i().로 확인 가능
        _ ->
            io:format("unknown Message"),
            loop({Status});
        exit ->
            io:format("exit process")          
   end.
        
        
        


%% module에서 accountInfo, characInfo 둘다 관리하기위해서 
%% Map <- accountInfoMap, characInfoMap 관리    
init() ->
    AccountInfo = maps:new(),
    CharacInfo = maps:new(),
    
    %% Map accountInfo, Map characInfo를 Statu Map에 저장 
    Status = maps:from_list([{accountInfo, AccountInfo}, {characInfo, CharacInfo}]),
    
    printData(Status),
    
    U1 = #accountInfo{accountId = 50001},
    U2 = #accountInfo{accountId = 50002, status=kLogin},
    U3 = #accountInfo{accountId = 50003, status=kInGame},
    
    {Status2, IsTrue} = put({Status, accountInfo, U1#accountInfo.accountId, U1}),
    printData(Status2),
    
    {Status3, IsTrue} = put({Status2, accountInfo, U2#accountInfo.accountId, U2}),
    printData(Status3),
    
    {Status4, IsTrue} = put({Status3, accountInfo, U3#accountInfo.accountId, U3}),
    printData(Status4),
    Status4.
    

put({Status, MapRecordType, Key, DataRecord}) ->
    %% Type(accountInfo, characInfo)에 맞는 map을 구해서
    printData("put, start, catch test"),
    try maps:get(MapRecordType, Status) of
    Map -> 
        %% 구한 Map 에 key value put
        NewMap = maps:put(Key, DataRecord, Map),
    
        %% put한 NewMap을 Status에 update 해서 return
        NewStatus = maps:update(MapRecordType, NewMap, Status),
        {NewStatus, true}
    catch
    %% 모든 예외를 잡을려면 _:_  이렇게 하면됨
    _:_ ->
        printData("-----------------"),
        {Status, false}
    end.
    
put_testCatch({Status, MapRecordType, Key, DataRecord}) ->
    %% Type(accountInfo, characInfo)에 맞는 map을 구해서
    case maps:get(MapRecordType, Status) of
    Map ->
        %% 구한 Map 에 key value put
        NewMap = maps:put(Key, DataRecord, Map),
        
        %% put한 NewMap을 Status에 update 해서 return
        NewStatus = maps:update(MapRecordType, NewMap, Status),
        {NewStatus, true};
    _ ->
        {Status, false}
    end.

getRecord({Status, MapRecordType, Key}) ->
    case maps:get(MapRecordType, Status) of
    Map ->
        Record = maps:get(Key, Map),
        {Status, Record};
    _ ->
        {Status , false}
   end.
        
    


%% 아래는 그냥 테스트
start(Test) ->
    AccountInfo = maps:new(),
    U1 = #accountInfo{accountId = 50001},
    U2 = #accountInfo{accountId = 50002},
    U3 = #accountInfo{accountId = 50003},
    
    AccountInfo2 = maps:put(U1#accountInfo.accountId, U1, AccountInfo),
    AccountInfo3 = maps:put(U2#accountInfo.accountId, U2, AccountInfo2),
    AccountInfo4 = maps:put(U3#accountInfo.accountId, U3, AccountInfo3),
    
    printData(getAccountInfo(50001, AccountInfo4)),
    printData(getAccountInfo(90001, AccountInfo4)),
    
    
    printData(AccountInfo4),
    ok.
 
 getAccountInfo(AccountId, Map) ->
    maps:get(AccountId, Map, -1).
 
   
printData(Data) ->
    io:format("dbeug data=~p~n", [Data]).    
    
