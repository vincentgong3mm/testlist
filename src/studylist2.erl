-module(studylist2).

%% 이렇게 import 하면 아래 에서 lists:map으로 호출 하지 않고 map으로 호출능하다
-import(lists, [map/2]).

-export([double/1]).

double(L) ->
    map(fun(X) -> X * 2 end, L).
   