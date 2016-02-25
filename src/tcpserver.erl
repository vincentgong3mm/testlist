-module(tcpserver).
-export([start/0]).

start() ->
    {ok, LSock} = gen_tcp:listen(5678, [binary, {packet, 0}, 
                                        {active, false}, {reuseaddr, true}]),
    {ok, Sock} = gen_tcp:accept(LSock),

    %%  접속 되면 서버 메시지 보냄.     
    gen_tcp:send(Sock, "tcp server test. first message\r\n"),
    
    {ok, Bin} = recv_line(Sock, []),
    
    io:format("recv='~p'~n", [Bin]),
    
    ok = gen_tcp:close(Sock),
    gen_tcp:close(LSock).
    

start_by_length() ->
    %% {packet, 0} : 좀더 찾아봐야하지만, 일반적인 소켓인 경우 0, erlang term주고 받을 때는 별도 사이즈 정의
    %% {active, false} : acitve, passive 구분, 일반적으로 특정 길이 만큼 받을 때 passive
    %% {reuseaddr, true} : time wait 소켓을 재사옹 하기 위해서. 하지 않으면 process종료 후 다시 listen할 때 에러발생
    {ok, LSock} = gen_tcp:listen(5678, [binary, {packet, 0}, 
                                        {active, false}, {reuseaddr, true}]),
    {ok, Sock} = gen_tcp:accept(LSock),

    %%  접속 되면 서버 메시지 보냄.     
    gen_tcp:send(Sock, "tcp server test. first message\r\n"),
    
    PacketLength = 4,
    {ok, BinLength} = recv_n_length(Sock, [], PacketLength, 0),    
    
    %% 추가할 내용 : 변환후 DataLength에 에러 없는지 체크 해야함
    {DataLength, _} = string:to_integer(binary_to_list(BinLength)),
    io:format("Length : Length=~p Data='~p'~n", [PacketLength, BinLength]),
    
    {ok, BinData} = recv_n_length(Sock, [], DataLength, 0),
    io:format("Data : Length=~p Data='~p'~n", [DataLength, BinData]),
    
    ok = gen_tcp:close(Sock),
    gen_tcp:close(LSock).

recv_n_length(Sock, Bs, Length, Repeat) ->
    io:format("debug length=~p repeatcount=~p~n", [Length, Repeat+1]),
    
    %% 아래와 같이 1로 하면 1byte씩만 받게 해서 분절 테스트 가능함
    %%case gen_tcp:recv(Sock, 1) of
    case gen_tcp:recv(Sock, 1) of
        {ok, B} ->
            ReceivedSize = erlang:byte_size(B),  
            %%io:format("Rsize '~p' ? length'~p'  case '~p'~n", [ReceivedSize, Length, ReceivedSize < Length]),     
            case ReceivedSize < Length of
                true ->
                    %%io:format("recv_n_length true receivedsize=~p~n", [ReceivedSize]),
                    recv_n_length(Sock, [B|Bs], Length - ReceivedSize, Repeat+1);
                _ ->
                    %%io:format("recv_n_length __ receivedsize=~p~n", [ReceivedSize]),
                    {ok, list_to_binary(lists:reverse([B|Bs]))}
            end;
        {error, closed} ->
            {ok, list_to_binary(Bs)}
    end.

recv_line(Sock, Bs) ->
    case gen_tcp:recv(Sock, 0) of
    {ok, B} ->
        {Pos, Length} = binary:match(B, [<<"\r\n">>]),
        B2 = binary:part(B, {0, Pos}),
        io:format("remove LPCR=[~p]\n", [B2]),
        {ok, B2};
    {error, close} ->
        {ok, list_to_binary([])}
    end.


do_recv(Sock, Bs) ->
    case gen_tcp:recv(Sock, 0) of
        {ok, B} ->
            io:format("recv=~p~n", [list_to_binary([B])]),
            do_recv(Sock, [Bs, B]);
        {error, closed} ->
            {ok, list_to_binary(Bs)}
    end.
