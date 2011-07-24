-module(dg_http).

-include_lib("modlib/include/webapp.hrl").

-export([start/1, request/3]).

start(Port) ->
    application:start(inets),
    modlib:start([{port, Port},
                  {modules, [?MODULE]}]).

request("GET", "/resolve/" ++ Pkg, _Info) ->
    case dg_resolve:resolve(Pkg) of
        {ok, Dependencies} ->
            {ok, [[Dep, "\n"] || Dep <- Dependencies]};
        error ->
            {not_found, "Not Found"}
    end;
request("GET", _Path, _Info) ->
    {not_found, "Not Found"};
request(_Method, _Path, _Info) ->
    {error, "Unsupported Method"}.

