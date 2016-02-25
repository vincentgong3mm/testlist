-module(studylist1).

-export([call_double/0, double/1, double_recursive/1]).

%% example : call double 
call_double() ->
    L = [1,2,3,4],
    double(L).
    
%% test lists:map
double(List) ->
    lists:map(fun(X) -> X * 2 end, List).
    
%% 리스트해석
double_recursive([H|T]) ->
    [H * 2 | double_recursive(T)];
double_recursive([]) -> [].

    


 
   
 