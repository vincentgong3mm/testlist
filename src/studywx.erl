-module(studywx).
-include("/usr/local/lib/erlang/lib/wx-1.5/include/wx.hrl").

-export([start/0, onButtonClick/2]).
    
start() ->
    Wx = wx:new(),
    Parent = wxFrame:new(Wx, -1, "button event test", [{size, {500, 500}}]),
    Panel = wxPanel:new(Parent, 1, 1, 500, 100),    
   
    B10 = wxButton:new(Panel, 10, [{label, "connect"}, {pos, {1, 1}}, {size, {100, 20}}]),
    B11 = wxButton:new(Panel, 11, [{label, "Login"}, {pos, {110, 1}}, {size, {100, 20}}]),
    B12 = wxButton:new(Panel, 12, [{label, "Logout/Disconnect"}, {pos, {210, 1}}, {size, {200, 20}}]),
    
    Range = 100,
    HpGauge = wxGauge:new(Panel, 100, Range, [{pos, {1, 50}}, {size, {200, -1}}, 
						{style, ?wxGA_HORIZONTAL}]),
   
    MpGauge = wxGauge:new(Panel, 100, Range, [{pos, {1, 70}}, {size, {200, -1}}, 
						{style, ?wxGA_HORIZONTAL}]),
   
    %%wxButton:connect(B10, command_button_clicked, [{callback, myonButtonClick}]),
    wxButton:connect(B10, command_button_clicked, [{callback, getFun_onButtonClick()}]),
    wxButton:connect(B11, command_button_clicked, [{callback, 
        fun(Event, Object) ->
            onButtonClick(Event, Object) end}]),
    wxButton:connect(B12, command_button_clicked, [{callback, 
        fun(Event, Object) ->
            onButtonClick(Event, Object) end}]),
            
   %% Setup sizers
   PanelText = wxPanel:new(Parent, 1, 101, 500, 400),    
   
   
    MainSizer = wxBoxSizer:new(?wxVERTICAL),
    Sizer = wxStaticBoxSizer:new(?wxVERTICAL, PanelText, 
				 [{label, "wxTextCtrl single line"}]),
    Sizer2 = wxStaticBoxSizer:new(?wxVERTICAL, PanelText, 
				  [{label, "wxTextCtrl single line password"}]),
    Sizer3 = wxStaticBoxSizer:new(?wxVERTICAL, PanelText, 
				  [{label, "wxTextCtrl multiline"}]),

    TextCtrl  = wxTextCtrl:new(PanelText, 1, [{value, "This is a single line wxTextCtrl"},
					 {style, ?wxDEFAULT}]),
    TextCtrl2 = wxTextCtrl:new(PanelText, 2, [{value, "password"},
					  {style, ?wxDEFAULT bor ?wxTE_PASSWORD}]),
    TextCtrl3 = wxTextCtrl:new(PanelText, 3, [{value, "This is a\nmultiline\nwxTextCtrl"},
					  {style, ?wxDEFAULT bor ?wxTE_MULTILINE}]),

    %% Add to sizers
    wxSizer:add(Sizer, TextCtrl,  [{flag, ?wxEXPAND}]),
    wxSizer:add(Sizer2, TextCtrl2, []),
    wxSizer:add(Sizer3, TextCtrl3, [{flag, ?wxEXPAND}, {proportion, 1}]),

    wxSizer:add(MainSizer, Sizer,  [{flag, ?wxEXPAND}]),
    wxSizer:addSpacer(MainSizer, 10),
    wxSizer:add(MainSizer, Sizer2, [{flag, ?wxEXPAND}]),
    wxSizer:addSpacer(MainSizer, 10),
    wxSizer:add(MainSizer, Sizer3, [{flag, ?wxEXPAND}, {proportion, 1}]),

    wxPanel:setSizer(PanelText, MainSizer),

    %%---------
    wxFrame:show(Parent).

%% 아래와 같이 함수를 fun으로 반환 하는 함수를 만들어서 일반함수를 fun으로 변환 후 
%% Fun을 인자로 받는 함수에 넘길수 있다.
getFun_onButtonClick() ->
    fun onButtonClick / 2.
     
onButtonClick(Event, Object) ->
    io:format("onButtonClick~n  event = ~p~n  obj = ~p~n", [Event, Object]),
    {_, Id, _, _, _} = Event,
    io:format("only id=~p~n", [Id]),
    
    
    ok.
    
