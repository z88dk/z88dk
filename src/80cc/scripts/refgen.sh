#!/bin/bash
# refgen.sh <outdir> — emit asm for a wide source set, for byte-identical
# refactor gating. Covers float/fixed/long-long shapes as well as the corpus.
export ZCCCFG=/workspaces/z88dk/lib/config PATH=${BIN:-/workspaces/z88dk/bin}:$PATH
O="$1"; mkdir -p "$O"; rm -f "$O"/*.asm
cd /workspaces/z88dk/test/suites
for src in */*.c ../../examples/console/enigma.c; do
  [ -e "$src" ] || continue
  case "$src" in framework/*) continue;; esac
  for m in sp fp; do
    fpf=""; [ "$m" = fp ] && fpf="-fframe-pointer"
    n=$(echo "$src" | tr '/.' '__')_$m
    zcc +test -vn -compiler=80cc $fpf -DNO_LOG_RUNNING -DNO_LOG_PASSED \
        -I../framework -a "$src" -o "$O/$n.asm" >/dev/null 2>&1
  done
done
ls "$O" | wc -l
