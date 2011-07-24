-module(dg_resolve).

-behaviour(gen_server).

%% API
-export([start_link/0, resolve/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

-record(state, {cache}).

%%%===================================================================
%%% API (public interface)
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

resolve(Pkg) ->
    gen_server:call(?SERVER, {resolve, Pkg}).

%%%===================================================================
%%% gen_server callbacks ("protected" interface)
%%%===================================================================

init([]) ->
    {ok, #state{cache=dict:new()}}.

handle_call({resolve, Pkg}, _From, State) ->
    case resolve_package(Pkg, State) of
        {ok, Deps, NewState} ->
            {reply, {ok, Deps}, NewState};
        error ->
            {reply, error, State}
    end.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

resolve_package(Pkg, #state{cache=Cache}=State) ->
io:format("**** ~p~n", [State]),
    case dict:find(Pkg, Cache) of
        {ok, Deps} ->
            io:format("***** found ~p in cache!~n", [{Pkg, Deps}]),
            {ok, Deps, State};
        error ->
            io:format("***** doing work for ~p~n", [Pkg]),
            case get_deps(Pkg) of
                {ok, Deps} ->
                    NewState = State#state{cache=dict:store(Pkg, Deps, Cache)},
                    {ok, Deps, NewState};
                error -> error
            end
    end.

get_deps("sample") ->
    {ok, ["foo", "bar", "baz"]};
get_deps(_) ->
    error.
