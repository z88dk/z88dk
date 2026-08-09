#!/usr/bin/env bash
# Remeasure support/benchmarks math16/math32 TIMER configs (classic + newlib).
# Parallelism: 4 workers. Isolated workdirs (zcc is not cwd-safe in parallel).
set -u
export PATH=/home/phillip/Z80/z88dk/bin:$PATH
export ZCCCFG=/home/phillip/Z80/z88dk/lib/config

ROOT=/home/phillip/Z80/z88dk
BENCH_ROOT="$ROOT/support/benchmarks"
WORK=/tmp/z88dk-bench-20260809
JOBS_DIR="$WORK/jobs"
RESULTS="$WORK/results.tsv"
LOG="$WORK/run.log"
STATUS="$WORK/status.txt"
DATE_LABEL="August 9, 2026"
THREADS=4
COUNTER=999999999999

mkdir -p "$JOBS_DIR"
: >"$RESULTS"
: >"$LOG"
echo "started $(date -Is) threads=$THREADS" >"$STATUS"

# job line format (tab-separated):
# id  bench  clib  compiler  cpu  math  src_subdir  zcc_args...
# zcc_args are everything after -o is handled by runner

declare -a JOBS=()

add_job() {
  # $1=id $2=bench $3=clib(classic|new) $4=compiler $5=cpu $6=math $7=src_rel $8...=extra zcc tokens
  local id="$1" bench="$2" clib="$3" compiler="$4" cpu="$5" math="$6" src_rel="$7"
  shift 7
  JOBS+=("$id|$bench|$clib|$compiler|$cpu|$math|$src_rel|$*")
}

# ---------- classic math32 / math16 ----------
# n-body
add_job nb_c_sccz80_z80_m32 n-body classic sccz80 z80 math32 z88dk-classic/n-body.c \
  +test -vn -DSTATIC -DTIMER -D__Z88DK -O2 --math32 -m -lndos
add_job nb_c_sccz80_8085_m32 n-body classic sccz80 8085 math32 z88dk-classic/n-body.c \
  +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O2 --math32 -m -lndos
add_job nb_c_zsdcc_z80_m32 n-body classic zsdcc z80 math32 z88dk-classic/n-body.c \
  +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 --math32 -m -lndos
add_job nb_c_sccz80_z80_m16 n-body classic sccz80 z80 math16 z88dk-classic/n-body.c \
  +test -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints --math16 -m -lndos
add_job nb_c_sccz80_8085_m16 n-body classic sccz80 8085 math16 z88dk-classic/n-body.c \
  +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints --math16 -lmath32_8085 -m -lndos
# 80cc n-body math32: known INVALID 2nd energy — still measure ticks for size/ticks revision note if published; skip publish per existing exception

# spectral-norm
add_job sn_c_sccz80_z80_m32 spectral-norm classic sccz80 z80 math32 z88dk-classic/spectral-norm.c \
  +test -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints --math32 -lndos -m
add_job sn_c_sccz80_8085_m32 spectral-norm classic sccz80 8085 math32 z88dk-classic/spectral-norm.c \
  +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints --math32 -lndos -m
add_job sn_c_zsdcc_z80_m32 spectral-norm classic zsdcc z80 math32 z88dk-classic/spectral-norm.c \
  +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 --math32 -lndos -m
add_job sn_c_80cc_z80_m32 spectral-norm classic 80cc z80 math32 z88dk-classic/spectral-norm.c \
  +test -compiler=80cc -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints --math32 -lndos -m
add_job sn_c_80cc_8085_m32 spectral-norm classic 80cc 8085 math32 z88dk-classic/spectral-norm.c \
  +test -clib=8085 -compiler=80cc -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints --math32 -lndos -m
# math16 TIMER: never --math16 --math32 (pollutes hot path with fsdiv).
# Bare 1.0 under __MATH_MATH16 needs (DOUBLE) cast in source or link fails (f48).
add_job sn_c_sccz80_z80_m16 spectral-norm classic sccz80 z80 math16 z88dk-classic/spectral-norm.c \
  +test -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints --math16 -lndos -m
add_job sn_c_sccz80_8085_m16 spectral-norm classic sccz80 8085 math16 z88dk-classic/spectral-norm.c \
  +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints --math16 -lmath32_8085 -lndos -m

# mandelbrot
add_job md_c_sccz80_z80_m32 mandelbrot classic sccz80 z80 math32 z88dk-classic/mandelbrot.c \
  +test -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints --math32 -lndos -m
add_job md_c_sccz80_8085_m32 mandelbrot classic sccz80 8085 math32 z88dk-classic/mandelbrot.c \
  +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints --math32 -lndos -m
add_job md_c_zsdcc_z80_m32 mandelbrot classic zsdcc z80 math32 z88dk-classic/mandelbrot.c \
  +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 --math32 -lndos -m
add_job md_c_80cc_z80_m32 mandelbrot classic 80cc z80 math32 z88dk-classic/mandelbrot.c \
  +test -compiler=80cc -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints --math32 -lndos -m
add_job md_c_80cc_8085_m32 mandelbrot classic 80cc 8085 math32 z88dk-classic/mandelbrot.c \
  +test -clib=8085 -compiler=80cc -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints --math32 -lndos -m
add_job md_c_sccz80_z80_m16 mandelbrot classic sccz80 z80 math16 z88dk-classic/mandelbrot.c \
  +test -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints --math16 -lndos -m
add_job md_c_sccz80_8085_m16 mandelbrot classic sccz80 8085 math16 z88dk-classic/mandelbrot.c \
  +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints --math16 -lmath32_8085 -lndos -m

# fasta
add_job fa_c_sccz80_z80_m32 fasta classic sccz80 z80 math32 z88dk-classic/fasta.c \
  +test -vn -DSTATIC -DTIMER -D__Z88DK -O2 --math32 -m -lndos -pragma-define:CRT_HEAP_AMALLOC=1
add_job fa_c_sccz80_8085_m32 fasta classic sccz80 8085 math32 z88dk-classic/fasta.c \
  +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O2 --math32 -m -lndos -pragma-define:CRT_HEAP_AMALLOC=1
add_job fa_c_zsdcc_z80_m32 fasta classic zsdcc z80 math32 z88dk-classic/fasta.c \
  +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 --fsigned-char --math32 -m -lndos -pragma-define:CRT_HEAP_AMALLOC=1
add_job fa_c_80cc_z80_m32 fasta classic 80cc z80 math32 z88dk-classic/fasta.c \
  +test -compiler=80cc -vn -DSTATIC -DTIMER -D__Z88DK -O2 --math32 -m -lndos -pragma-define:CRT_HEAP_AMALLOC=1
add_job fa_c_80cc_8085_m32 fasta classic 80cc 8085 math32 z88dk-classic/fasta.c \
  +test -clib=8085 -compiler=80cc -vn -DSTATIC -DTIMER -D__Z88DK -O2 --math32 -m -lndos -pragma-define:CRT_HEAP_AMALLOC=1

# whetstone (80cc math32 SKIP per existing note — not scheduled)
add_job wh_c_sccz80_z80_m32 whetstone classic sccz80 z80 math32 z88dk-classic/whetstone.c \
  +test -vn -O2 -DSTATIC -DTIMER -D__Z88DK --math32 -lndos -m
add_job wh_c_sccz80_8085_m32 whetstone classic sccz80 8085 math32 z88dk-classic/whetstone.c \
  +test -clib=8085 -vn -O2 -DSTATIC -DTIMER -D__Z88DK --math32 -lndos -m
add_job wh_c_zsdcc_z80_m32 whetstone classic zsdcc z80 math32 z88dk-classic/whetstone.c \
  +test -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -D__Z88DK --math32 -lndos -m

# ---------- newlib math32 / math16 ----------
# n-body
add_job nb_n_sccz80_z80_m32 n-body new sccz80 z80 math32 z88dk-new/n-body.c \
  +z80 -vn -DSTATIC -DTIMER -startup=0 -O3 --opt-code-speed=inlineints -clib=new --math32 -m -pragma-include:zpragma.inc -create-app
add_job nb_n_zsdcc_z80_m32 n-body new zsdcc z80 math32 z88dk-new/n-body.c \
  +z80 -vn -DSTATIC -DTIMER -startup=0 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 --math32 -m -pragma-include:zpragma.inc -create-app
add_job nb_n_sccz80_z80_m16 n-body new sccz80 z80 math16 z88dk-new/n-body.c \
  +z80 -vn -DSTATIC -DTIMER -startup=0 -O3 --opt-code-speed=inlineints -clib=new --math16 -m -pragma-include:zpragma.inc -create-app

# spectral-norm new (published: zsdcc math32; also try sccz80 math32 if builds)
add_job sn_n_zsdcc_z80_m32 spectral-norm new zsdcc z80 math32 z88dk-new/spectral-norm.c \
  +z80 -vn -startup=0 -DSTATIC -DTIMER -SO3 -clib=sdcc_iy --max-allocs-per-node200000 --math32 -m -create-app
add_job sn_n_sccz80_z80_m32 spectral-norm new sccz80 z80 math32 z88dk-new/spectral-norm.c \
  +z80 -vn -startup=0 -DSTATIC -DTIMER -O3 --opt-code-speed=inlineints -clib=new --math32 -m -create-app

# mandelbrot new
add_job md_n_sccz80_z80_m32 mandelbrot new sccz80 z80 math32 z88dk-new/mandelbrot.c \
  +z80 -vn -DSTATIC -DTIMER -startup=0 -O2 -clib=new --math32 -m -pragma-include:zpragma.inc -create-app
add_job md_n_zsdcc_z80_m32 mandelbrot new zsdcc z80 math32 z88dk-new/mandelbrot.c \
  +z80 -vn -DSTATIC -DTIMER -startup=0 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 --math32 -m -pragma-include:zpragma.inc -create-app
add_job md_n_sccz80_z80_m16 mandelbrot new sccz80 z80 math16 z88dk-new/mandelbrot.c \
  +z80 -vn -DSTATIC -DTIMER -startup=0 -O3 --opt-code-speed=inlineints -clib=new --math16 -m -pragma-include:zpragma.inc -create-app

# fasta new
add_job fa_n_sccz80_z80_m32 fasta new sccz80 z80 math32 z88dk-new/fasta.c \
  +z80 -vn -DSTATIC -DTIMER -startup=0 -O2 -clib=new --math32 -m -pragma-include:zpragma.inc -create-app
add_job fa_n_zsdcc_z80_m32 fasta new zsdcc z80 math32 z88dk-new/fasta.c \
  +z80 -vn -DSTATIC -DTIMER -startup=0 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 --fsigned-char --math32 -m -pragma-include:zpragma.inc -create-app

# whetstone new
add_job wh_n_sccz80_z80_m32 whetstone new sccz80 z80 math32 z88dk-new/whetstone.c \
  +z80 -vn -startup=0 -clib=new -O3 --opt-code-speed=inlineints -DSTATIC -DTIMER --math32 -m -pragma-include:zpragma.inc -create-app
add_job wh_n_zsdcc_z80_m32 whetstone new zsdcc z80 math32 z88dk-new/whetstone.c \
  +z80 -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER --math32 -m -pragma-include:zpragma.inc -create-app

TOTAL=${#JOBS[@]}
echo "total_jobs=$TOTAL" | tee -a "$STATUS"
printf 'id\tbench\tclib\tcompiler\tcpu\tmath\tsize\tticks\tstatus\twall_s\n' >"$RESULTS"

run_one() {
  local spec="$1"
  IFS='|' read -r id bench clib compiler cpu math src_rel zcc_rest <<<"$spec"
  local jdir="$JOBS_DIR/$id"
  rm -rf "$jdir"
  mkdir -p "$jdir"
  local src_abs="$BENCH_ROOT/$bench/$src_rel"
  local src_base
  src_base=$(basename "$src_abs")
  cp "$src_abs" "$jdir/"
  # newlib jobs only — classic +test must not pick up newlib zpragma.inc
  if [[ "$clib" == "new" && -f "$BENCH_ROOT/$bench/z88dk-new/zpragma.inc" ]]; then
    cp "$BENCH_ROOT/$bench/z88dk-new/zpragma.inc" "$jdir/" 2>/dev/null || true
  fi
  local out_base="${src_base%.c}"
  local bin_path map_path
  local t0 t1 wall size ticks status ticks_cpu=""
  status=ok
  size=""
  ticks=""
  t0=$(date +%s)
  {
    echo "==== START $id $(date -Is) ===="
    cd "$jdir" || exit 1
    mkdir -p "$jdir/tmp"
    export TMPDIR="$jdir/tmp"
    export TMP="$jdir/tmp"
    local out_arg
    if [[ "$clib" == "new" ]]; then
      out_arg="$out_base"
    else
      out_arg="${out_base}.bin"
    fi
    # shellcheck disable=SC2086
    if ! zcc $zcc_rest "$src_base" -o "$out_arg" 2>"$jdir/zcc.err"; then
      status=build_fail
      echo "BUILD FAIL $id"
      cat "$jdir/zcc.err"
    else
      bin_path=""
      for cand in "${out_base}.bin" "$out_base" "${out_base}_CODE.bin"; do
        if [[ -f "$cand" ]]; then
          bin_path="$cand"
          break
        fi
      done
      if [[ -z "$bin_path" ]]; then
        # any non-source file that is not map/err/inc
        bin_path=$(ls -1 "$jdir" 2>/dev/null | while read -r f; do
          case "$f" in
            *.c|*.map|*.err|*.inc|zcc*) ;;
            *) echo "$f"; break ;;
          esac
        done)
        [[ -n "$bin_path" ]] && bin_path="$jdir/$bin_path"
      fi
      map_path=""
      for mcand in "${out_base}.map" "${out_base}.bin.map"; do
        if [[ -f "$mcand" ]]; then map_path="$mcand"; break; fi
      done
      if [[ -z "$map_path" ]]; then
        map_path=$(ls -1 "$jdir"/*.map 2>/dev/null | head -1 || true)
      fi
      if [[ -z "${bin_path:-}" || ! -f "$bin_path" ]]; then
        status=no_bin
        ls -la "$jdir" || true
      else
        size=$(wc -c <"$bin_path" | tr -d ' ')
        if [[ "$cpu" == "8085" ]]; then
          ticks_cpu="-m8085"
        fi
        if [[ -n "${map_path:-}" && -f "$map_path" ]]; then
          # shellcheck disable=SC2086
          ticks=$(z88dk-ticks $ticks_cpu "$bin_path" -x "$map_path" \
            -start TIMER_START -end TIMER_STOP -counter "$COUNTER" 2>"$jdir/ticks.err" | tr -d '[:space:]')
        else
          # shellcheck disable=SC2086
          ticks=$(z88dk-ticks $ticks_cpu "$bin_path" \
            -start TIMER_START -end TIMER_STOP -counter "$COUNTER" 2>"$jdir/ticks.err" | tr -d '[:space:]')
        fi
        if [[ -z "$ticks" || ! "$ticks" =~ ^[0-9]+$ ]]; then
          status=ticks_fail
          ticks=""
          cat "$jdir/ticks.err" 2>/dev/null || true
        elif [[ "$ticks" -ge $((COUNTER - 1000)) ]]; then
          status=counter_hit
        fi
      fi
    fi
    t1=$(date +%s)
    wall=$((t1 - t0))
    printf '%s	%s	%s	%s	%s	%s	%s	%s	%s	%s
' \
      "$id" "$bench" "$clib" "$compiler" "$cpu" "$math" "${size:-}" "${ticks:-}" "$status" "$wall" \
      >>"$RESULTS"
    echo "==== END $id status=$status size=${size:-} ticks=${ticks:-} wall=${wall}s ===="
  } >>"$LOG" 2>&1
}


export -f run_one
export PATH ZCCCFG ROOT BENCH_ROOT JOBS_DIR RESULTS LOG COUNTER

# simple 4-worker pool
running=0
declare -a pids=()
declare -a pid_ids=()
idx=0
done_count=0

update_status() {
  local active=0
  for p in "${pids[@]:-}"; do
    if kill -0 "$p" 2>/dev/null; then active=$((active + 1)); fi
  done
  done_count=$(grep -c $'\t' "$RESULTS" 2>/dev/null || echo 0)
  # subtract header
  if [[ -f "$RESULTS" ]]; then
    done_count=$(($(wc -l <"$RESULTS") - 1))
  fi
  {
    echo "time=$(date -Is)"
    echo "total=$TOTAL"
    echo "completed=$done_count"
    echo "active=$active"
    echo "next_idx=$idx"
    if [[ -f "$RESULTS" ]]; then
      echo "--- last results ---"
      tail -n 8 "$RESULTS"
    fi
  } >"$STATUS"
}

while [[ $idx -lt $TOTAL || ${#pids[@]} -gt 0 ]]; do
  # reap finished
  new_pids=()
  for p in "${pids[@]:-}"; do
    if kill -0 "$p" 2>/dev/null; then
      new_pids+=("$p")
    fi
  done
  pids=("${new_pids[@]:-}")

  while [[ ${#pids[@]} -lt $THREADS && $idx -lt $TOTAL ]]; do
    run_one "${JOBS[$idx]}" &
    pids+=($!)
    idx=$((idx + 1))
  done

  update_status
  if [[ ${#pids[@]} -eq 0 && $idx -ge $TOTAL ]]; then
    break
  fi
  sleep 2
done

update_status
echo "finished $(date -Is)" | tee -a "$STATUS"
echo "Results: $RESULTS"
cat "$RESULTS"
