#!/usr/bin/bash

erl -pa _build/default/lib/*/ebin \
    -pa _build/default/lib/*/test \
    -noshell \
    +K true \
    +scl false \
    -run perc_vs_jiffy run_bench \
    -run init stop \
    -extra "$@"
