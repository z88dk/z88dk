#!/bin/bash
# size scan: code_compiler for each bench source, per CPU, per frame mode.
# usage: sizescan.sh <outfile>   env: GATE="IR_JR_UNCOND=1"
export ZCCCFG=/workspaces/z88dk/lib/config PATH=${BIN:-/workspaces/z88dk/bin}:$PATH
cd /workspaces/z88dk/test/suites
OUT="$1"; : > "$OUT"
BENCHES="charbench crcbench intbench ptrbench sieve rle sortbench queenbench searchbench switchbench structbench vecbench recordbench maskbench strbench listbench interpbench matrixbench hashbench fixedbench histbench lexbench md5 localbench predbench divbench shiftbench callbench bitfieldbench widthbench"
CPUS="${CPUS:-z80: z80n:-clib=z80n r2ka:-clib=rabbit r4k:-clib=rabbit4k r6k:-clib=rabbit6k z180:-clib=z180 ez80_z80:-clib=ez80_z80 gbz80:-clib=gbz80 kc160:-clib=kc160 8080:-clib=8080 8085:-clib=8085 vm1:-clib=vm1}"
sec(){ z88dk-z80nm "$1" 2>/dev/null | grep -oE 'Section code_compiler: [0-9]+' | grep -oE '[0-9]+'; }
for b in $BENCHES; do
  [ -d "$b" ] || continue
  for src in "$b"/*.c; do
    [ -e "$src" ] || continue
    for cm in $CPUS; do
      cpu="${cm%%:*}"; clib="${cm#*:}"
      for m in sp fp; do
        fpf=""; [ "$m" = fp ] && fpf="-fframe-pointer"
        env $GATE zcc +test -vn -compiler=80cc $clib $fpf -DNO_LOG_RUNNING -DNO_LOG_PASSED -I../framework -c "$src" -o /tmp/ss_$$.o >/dev/null 2>&1
        v=$(sec /tmp/ss_$$.o); [ -z "$v" ] && v=X
        echo "$src $cpu $m $v" >> "$OUT"
      done
    done
  done
done
rm -f /tmp/ss_$$.o
