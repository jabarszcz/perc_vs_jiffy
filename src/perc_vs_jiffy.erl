-module(perc_vs_jiffy).

%% API exports
-export([run_bench/0]).

%%====================================================================
%% API functions
%%====================================================================
-spec run_bench() -> ok.
run_bench() ->
    Args = init:get_plain_arguments(),
    OptSpec =
        [{file, $f, "file", string, "File"},
         {rep, $n, "repetitions", {integer, 50}, "Reps"}
         | perc:get_optspec()],
    case getopt:parse(OptSpec, Args) of
        {ok, {Opts, []}} ->
            make_perc_encoder(Opts),
            Rec = proplists:get_value(record, Opts),
            File = proplists:get_value(file, Opts),
            N = proplists:get_value(rep, Opts),
            EncodeFun =
                hd([Fun || {Fun, 1} <- perc_gen:module_info(exports),
                           Fun =/= module_info]),
            Data = get_data(File),
            Len = length(Data),
            EJsonData = [data_to_ejson(R, EncodeFun) || R <- Data],
            io:format("Running benchmarks for ~w ~s records in ~s, ~w rep~n",
                      [Len, Rec, File, N]),
            Perc = run_perc_bench(Data, N, EncodeFun),
            Jiffy = run_jiffy_bench(EJsonData, N),
            eministat:x(95.0, Jiffy, Perc);
        _ ->
            getopt:usage(OptSpec, "bench")
    end.

%%====================================================================
%% Internal functions
%%====================================================================

data_to_ejson(R, EncodeFun) ->
    Json = perc_gen:EncodeFun(R),
    jiffy:decode(Json).

get_data(Filename) ->
    {ok, Terms} = file:consult(Filename),
    Terms.

make_perc_encoder(Opts) ->
    PercOpts =
        [{erl_out, "perc_gen"}, {appname, "perc_vs_jiffy"}, load | Opts],
    perc:generate_codecs(PercOpts).

run_jiffy_bench(EJsonData, N) ->
    eministat:s(
      "jiffy",
      fun() -> [jiffy:encode(R) || R <- EJsonData] end,
      N).

run_perc_bench(Data, N, EncodeFun) ->
    eministat:s(
      "perc",
      fun() -> [perc_gen:EncodeFun(R) || R <- Data] end,
      N).
