perc_vs_jiffy
=====

Benchmark [perc][1] vs. [jiffy][2] for json encoding

`perc` is functionally different from `jiffy` because it takes records
as input for encoding instead of ejson. For this simple benchmark, we
use a `file:consult()`-able file containing records that can be
encoded with `perc`. That data is then turned into ejson by encoding
with `perc` and decoding with `jiffy`. We compare the time it takes to
encode the records with `perc` and the ejson with `jiffy`.

[1]: https://github.com/jabarszcz/perc/tree/encoder
[2]: https://github.com/davisp/jiffy

Build
-----

    $ rebar3 compile

Run
---

    $ ./bin/bench.sh -i ./<record_definitions>.hrl --record <record_name> -f <terms_file> --cpp-flags="-O3"