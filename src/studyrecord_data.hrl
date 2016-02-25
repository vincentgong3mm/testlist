-record(characInfo, {accountId=-1, characNo=0, characName="", level=0}).
%%nested record할 때 반드시 characInfo 처럼 record명을 사용할 필요는 없다.
-record(userInfo, {uId, accountId=-1, status=0, characInfo=#characInfo{}}).
%%-record(userInfo, {uId, accountId=-1, status=0, myCharacInfo=#characInfo{}}).

-record(nrec0, {name = "nested0"}).
-record(nrec1, {name = "nested1", nrec0=#nrec0{}}).
-record(nrec2, {name = "nested2", nrec1=#nrec1{}}).
-record(nrec3, {name = "nested3", nrec0=#nrec0{}}).