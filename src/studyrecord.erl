-module(studyrecord).
-include("studyrecord_data.hrl").
-export([start/0]).

start() ->
    io:format("record info = ~p~n", [record_info(fields, userInfo)]),
    io:format("record info = ~p~n", [record_info(fields, characInfo)]),
    R = #userInfo{uId = 4001, accountId = 20000001},
    
    io:format("R = ~p~n", [R]),
    
    %% 상태변경
    R2 = R#userInfo{status = login},
    io:format("R2 = ~p~n", [R2]),
    
    %% 캐릭터 로그인, userInfo에서 캐릭터이름과 레벨 변경하기
    R3 = R2#userInfo{characInfo = #characInfo{characName = "vincentGong", level = 85}},
    io:format("R3 = ~p~n", [R3]),
    
    %% 캐릭터 정보를 record로 구하기 C1은 record임 
    C1 = R3#userInfo.characInfo,
    io:format("C1 = ~p~n", [C1]),
    
    %% 캐릭터 이름만 구하기
    CharacName = R3#userInfo.characInfo#characInfo.characName,
    io:format("CharacName = ~p~n", [CharacName]),
    
    
    ok.
    