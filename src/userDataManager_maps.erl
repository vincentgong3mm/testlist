-module(userDataManager_maps).
-include("userData.hrl").
-compile(export_all).

start() ->
    init().

%% module에서 userInfo, characInfo 둘다 관리하기위해서 
%% Map <- userInfoMap, characInfoMap 관리    
init() ->
    UserInfo = maps:new(),
    CharacInfo = maps:new(),
    
    %% Map userInfo, Map characInfo를 Statu Map에 저장 
    Status = maps:from_list([{userInfo, UserInfo}, {characInfo, CharacInfo}]),
    
    printData(Status),
    
    U1 = #accountInfo{accountId = 50001},
    U2 = #accountInfo{accountId = 50002, status=kLogin},
    U3 = #accountInfo{accountId = 50003, status=kInGame},
    
    {Status2, IsTrue} = put({Status, userInfo, U1#accountInfo.accountId, U1}),
    printData(Status2),
    
    {Status3, IsTrue} = put({Status2, userInfo, U2#accountInfo.accountId, U2}),
    printData(Status3),
    
    {Status4, IsTrue} = put({Status3, userInfo, U3#accountInfo.accountId, U3}),
    printData(Status4),
    ok.
    
    
    

put({Status, MapRecordType, Key, DataRecord}) ->
    %% Type(userInfo, characInfo)에 맞는 map을 구해서
    case maps:get(MapRecordType, Status) of
    Map ->
        %% 구한 Map 에 key value put
        NewMap = maps:put(Key, DataRecord, Map),
        
        %% put한 NewMap을 Status에 update 해서 return
        NewStatus = maps:update(MapRecordType, NewMap, Status),
        {NewStatus, true};
    -1 ->
        {Status, false}
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
    
