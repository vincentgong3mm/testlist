%% charac info record
-record(characInfo, {characNo=-1, characName="", job=-1, level=-1}).

%% user info recrod
-record(userInfo, {accountId=-1, status=kNone, characInfo=#characInfo{}}).



