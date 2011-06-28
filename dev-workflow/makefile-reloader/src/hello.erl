-module(hello).

-export([say/0, msg/0]).

say() ->
    io:format("~s~n", [msg()]).

msg() -> 
    "hello".

-include_lib("eunit/include/eunit.hrl").

msg_test() ->
    ?assertEqual("hello", msg()).
