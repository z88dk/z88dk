#!/bin/bash
# ticks scan: build+run each bench for the given CPUs, both frame modes.
# usage: tickscan.sh <outfile>   env: GATE="IR_JR_UNCOND=1"  CPUS="z80 z80n ..."
export ZCCCFG=/workspaces/z88dk/lib/config PATH=${BIN:-/workspaces/z88dk/bin}:$PATH
cd /workspaces/z88dk/test/suites
OUT="$1"; : > "$OUT"
BENCHES="${BENCHES:-charbench crcbench intbench ptrbench sieve rle sortbench queenbench searchbench switchbench structbench vecbench recordbench maskbench strbench listbench interpbench matrixbench hashbench fixedbench histbench lexbench md5 localbench predbench divbench shiftbench callbench bitfieldbench widthbench}"
CPUS="${CPUS:-z80}"
for b in $BENCHES; do
  [ -d "$b" ] || continue
  for cpu in $CPUS; do
    case $cpu in
      z80)  clib=""; mflag="-b msx";;
      z80n) clib="-clib=z80n"; mflag="-mz80n";;
      r2ka) clib="-clib=rabbit"; mflag="-mr2ka";;
      r4k)  clib="-clib=rabbit4k"; mflag="-mr4k";;
      r6k)  clib="-clib=rabbit6k"; mflag="-mr6k";;
      z180) clib="-clib=z180"; mflag="-mz180";;
      8080) clib="-clib=8080"; mflag="-m8080";;
      8085) clib="-clib=8085"; mflag="-m8085";;
      ez80_z80) clib="-clib=ez80_z80"; mflag="-mez80_z80";;
      gbz80) clib="-clib=gbz80"; mflag="-mgbz80";;
      kc160) clib="-clib=kc160"; mflag="-mkc160";;
    esac
    for m in sp fp; do
      fpf=""; [ "$m" = fp ] && fpf="-fframe-pointer"
      bin=/tmp/tk_$$.bin
      ( cd "$b" && env $GATE zcc +test -vn -compiler=80cc $clib $fpf \
          -DNO_LOG_RUNNING -DNO_LOG_PASSED -I../../framework \
          ../../framework/*.c *.c -o $bin >/dev/null 2>&1 )
      # RUN FROM THE BENCH'S OWN DIRECTORY. md5sum.c does
      # MDFile("md5test.bin") — an open() relative to the CWD — so running the
      # binary from test/suites reads nothing, the digest mismatches, and all 8
      # md5 cells report fail=1. That is a HARNESS bug and it looks exactly like
      # a compiler regression. The build already cd'd into $b; the RUN must too.
      if [ -s "$bin" ]; then
        out=$( cd "$b" && z88dk-ticks -w 60 $mflag "$bin" 2>&1 )
        t=$(printf '%s' "$out" | grep -oE 'Ticks: [0-9]+' | grep -oE '[0-9]+')
        f=$(printf '%s' "$out" | grep -oE '[0-9]+ failed' | grep -oE '^[0-9]+')
      else t=""; f=""; fi
      [ -z "$t" ] && t=X
      [ -z "$f" ] && f=?
      echo "$b $cpu $m $t fail=$f" >> "$OUT"
      rm -f "$bin"
    done
  done
done
