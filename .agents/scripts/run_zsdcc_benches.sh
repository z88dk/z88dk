#!/usr/bin/env bash
# Remeasure every published zsdcc TIMER row under support/benchmarks
# (classic + newlib; integer, math48, math32). Isolated workdirs.
#
# Does not rebuild newlib for pi FAST (__CLIB_OPT_IMATH=75).
# Does not run vanilla SDCC, sccz80, or 80cc.
set -u
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="${ROOT:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
export PATH="$ROOT/bin${PATH:+:$PATH}"
export ZCCCFG="${ZCCCFG:-$ROOT/lib/config}"

BENCH_ROOT="$ROOT/support/benchmarks"
WORK="${WORK:-/tmp/z88dk-zsdcc-bench-$(date +%Y%m%d)}"
JOBS_DIR="$WORK/jobs"
RESULTS="$WORK/results.tsv"
LOG="$WORK/run.log"
STATUS="$WORK/status.txt"
THREADS="${THREADS:-4}"
COUNTER=999999999999

mkdir -p "$JOBS_DIR"
: >"$LOG"
echo "started $(date -Is) threads=$THREADS zsdcc=$(z88dk-zsdcc --version 2>&1 | sed -n 's/.*Build: //p' | head -1)" >"$STATUS"

declare -a JOBS=()

add_job() {
  # id bench clib compiler cpu math srcs(comma) out_base zcc_args...
  local id="$1" bench="$2" clib="$3" compiler="$4" cpu="$5" math="$6" srcs="$7" out_base="$8"
  shift 8
  JOBS+=("$id|$bench|$clib|$compiler|$cpu|$math|$srcs|$out_base|$*")
}

# ---------- classic ----------
add_job bt_c binary-trees classic zsdcc z80 math48 \
  z88dk-classic/binary-trees.c bt \
  +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 -lmath48 -lndos -m -pragma-define:CRT_HEAP_AMALLOC=1

add_job dh_c dhrystone21 classic zsdcc z80 int \
  z88dk-classic/dhry_1.c,z88dk-classic/dhry_2.c,z88dk-classic/dhry.h dhry \
  +test -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DTIMER -D__Z88DK -m -lndos dhry_1.c dhry_2.c

add_job fk_c fannkuch classic zsdcc z80 int \
  z88dk-classic/fannkuch.c fannkuch \
  +test -vn -DSTATIC -DINLINE -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 -lndos -m

add_job fa_c fasta classic zsdcc z80 math48 \
  z88dk-classic/fasta.c fasta \
  +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc --max-allocs-per-node200000 --fsigned-char -m -lmath48 -lndos -pragma-define:CRT_HEAP_AMALLOC=1

add_job fa_c_m32 fasta classic zsdcc z80 math32 \
  z88dk-classic/fasta.c fasta \
  +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 --fsigned-char --math32 -m -lndos -pragma-define:CRT_HEAP_AMALLOC=1

add_job md_c mandelbrot classic zsdcc z80 math48 \
  z88dk-classic/mandelbrot.c mandelbrot \
  +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 -lmath48 -lndos -m

add_job md_c_m32 mandelbrot classic zsdcc z80 math32 \
  z88dk-classic/mandelbrot.c mandelbrot \
  +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 --math32 -lndos -m

add_job nb_c n-body classic zsdcc z80 math48 \
  z88dk-classic/n-body.c n-body \
  +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 -lmath48 -m -lndos

add_job nb_c_m32 n-body classic zsdcc z80 math32 \
  z88dk-classic/n-body.c n-body \
  +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 --math32 -m -lndos

add_job pi_c pi classic zsdcc z80 int \
  z88dk-classic/pi.c pi \
  +test -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -D__Z88DK -lndos -m

add_job sv_c sieve classic zsdcc z80 int \
  z88dk-classic/sieve.c sieve \
  +test -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -D__Z88DK -lndos -m

add_job sn_c_m48 spectral-norm classic zsdcc z80 math48 \
  z88dk-classic/spectral-norm.c spectral-norm \
  +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 -lmath48 -lndos -m

add_job sn_c_m32 spectral-norm classic zsdcc z80 math32 \
  z88dk-classic/spectral-norm.c spectral-norm \
  +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 --math32 -lndos -m

add_job wh_c_m48 whetstone classic zsdcc z80 math48 \
  z88dk-classic/whetstone.c whetstone \
  +test -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -D__Z88DK -lmath48 -lndos -m

add_job wh_c_m32 whetstone classic zsdcc z80 math32 \
  z88dk-classic/whetstone.c whetstone \
  +test -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -D__Z88DK --math32 -lndos -m

# classic sorting (8 TIMER binaries)
for style_name_val in ran:0 ord:1 rev:2 equ:3; do
  style_name="${style_name_val%%:*}"
  style_val="${style_name_val##*:}"
  for num in 20 5000; do
    add_job "so_c_${style_name}_${num}" sorting classic zsdcc z80 int \
      z88dk-classic/sort.c "sort-${style_name}-${num}" \
      +test -vn -DTIMER -DSTYLE="${style_val}" -DNUM="${num}" -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 -lndos -m
  done
done

# ---------- newlib ----------
add_job bt_n binary-trees new zsdcc z80 math48 \
  z88dk-new/binary-trees.c bt \
  +z80 -vn -DSTATIC -DTIMER -startup=0 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 -lm -m -pragma-include:zpragma.inc -create-app

add_job dh_n dhrystone21 new zsdcc z80 int \
  z88dk-new/dhry_1.c,z88dk-new/dhry_2.c,z88dk-new/dhry.h dhry \
  +z80 -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DTIMER -m -pragma-include:zpragma.inc -create-app dhry_1.c dhry_2.c

add_job fk_n fannkuch new zsdcc z80 int \
  z88dk-new/fannkuch.c fannkuch \
  +z80 -vn -DSTATIC -DTIMER -DINLINE -startup=0 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 -m -pragma-include:zpragma.inc -create-app

add_job fa_n fasta new zsdcc z80 math48 \
  z88dk-new/fasta.c fasta \
  +z80 -vn -DSTATIC -DTIMER -startup=0 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 --fsigned-char -lm -m -pragma-include:zpragma.inc -create-app

add_job fa_n_m32 fasta new zsdcc z80 math32 \
  z88dk-new/fasta.c fasta \
  +z80 -vn -DSTATIC -DTIMER -startup=0 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 --fsigned-char --math32 -m -pragma-include:zpragma.inc -create-app

add_job md_n mandelbrot new zsdcc z80 math48 \
  z88dk-new/mandelbrot.c mandelbrot \
  +z80 -vn -DSTATIC -DTIMER -startup=0 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 -lm -m -pragma-include:zpragma.inc -create-app

add_job md_n_m32 mandelbrot new zsdcc z80 math32 \
  z88dk-new/mandelbrot.c mandelbrot \
  +z80 -vn -DSTATIC -DTIMER -startup=0 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 --math32 -m -pragma-include:zpragma.inc -create-app

add_job nb_n n-body new zsdcc z80 math48 \
  z88dk-new/n-body.c n-body \
  +z80 -vn -DSTATIC -DTIMER -startup=0 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 -lm -m -pragma-include:zpragma.inc -create-app

add_job nb_n_m32 n-body new zsdcc z80 math32 \
  z88dk-new/n-body.c n-body \
  +z80 -vn -DSTATIC -DTIMER -startup=0 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 --math32 -m -pragma-include:zpragma.inc -create-app

add_job pi_n_small pi new zsdcc z80 int-small \
  z88dk-new/pi.c pi \
  +z80 -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -m -pragma-include:zpragma.inc -create-app

add_job pi_n_small_ldiv pi new zsdcc z80 int-small \
  z88dk-new/pi_ldiv.c pi_ldiv \
  +z80 -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -m -pragma-include:zpragma.inc -create-app

add_job sv_n sieve new zsdcc z80 int \
  z88dk-new/sieve.c sieve \
  +z80 -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -m -pragma-include:zpragma.inc -create-app

add_job sn_n spectral-norm new zsdcc z80 math48 \
  z88dk-new/spectral-norm.c spectral-norm \
  +z80 -vn -startup=0 -DSTATIC -DTIMER -SO3 -clib=sdcc_iy --max-allocs-per-node200000 -lm -m -create-app

add_job sn_n_m32 spectral-norm new zsdcc z80 math32 \
  z88dk-new/spectral-norm.c spectral-norm \
  +z80 -vn -startup=0 -DSTATIC -DTIMER -SO3 -clib=sdcc_iy --max-allocs-per-node200000 --math32 -m -create-app

add_job wh_n_m48 whetstone new zsdcc z80 math48 \
  z88dk-new/whetstone.c whetstone \
  +z80 -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -lm -m -pragma-include:zpragma.inc -create-app

add_job wh_n_m32 whetstone new zsdcc z80 math32 \
  z88dk-new/whetstone.c whetstone \
  +z80 -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER --math32 -m -pragma-include:zpragma.inc -create-app

if [[ -n "${ONLY_IDS:-}" ]]; then
  filtered=()
  for spec in "${JOBS[@]}"; do
    id="${spec%%|*}"
    if [[ " ${ONLY_IDS} " == *" ${id} "* ]]; then
      filtered+=("$spec")
    fi
  done
  JOBS=("${filtered[@]}")
fi

TOTAL=${#JOBS[@]}
echo "total_jobs=$TOTAL" | tee -a "$STATUS"
printf 'id\tbench\tclib\tcompiler\tcpu\tmath\tsize\tticks\tstatus\twall_s\n' >"$RESULTS"

run_one() {
  local spec="$1"
  IFS='|' read -r id bench clib compiler cpu math srcs out_base zcc_rest <<<"$spec"
  local jdir="$JOBS_DIR/$id"
  rm -rf "$jdir"
  mkdir -p "$jdir/tmp"
  local src
  IFS=',' read -ra src_list <<<"$srcs"
  for src in "${src_list[@]}"; do
    cp "$BENCH_ROOT/$bench/$src" "$jdir/"
  done
  if [[ "$clib" == "new" && -f "$BENCH_ROOT/$bench/z88dk-new/zpragma.inc" ]]; then
    cp "$BENCH_ROOT/$bench/z88dk-new/zpragma.inc" "$jdir/"
  fi
  local t0 t1 wall size ticks status
  status=ok
  size=""
  ticks=""
  t0=$(date +%s)
  {
    echo "==== START $id $(date -Is) ===="
    cd "$jdir" || exit 1
    export TMPDIR="$jdir/tmp"
    export TMP="$jdir/tmp"
    local out_arg
    if [[ "$clib" == "new" ]]; then
      out_arg="$out_base"
    else
      out_arg="${out_base}.bin"
    fi
    local src_args=""
    if ! grep -q '\.c' <<<"$zcc_rest"; then
      src_args=$(basename "${src_list[0]}")
    fi
    # shellcheck disable=SC2086
    if ! zcc $zcc_rest $src_args -o "$out_arg" 2>"$jdir/zcc.err"; then
      status=build_fail
      echo "BUILD FAIL $id"
      cat "$jdir/zcc.err"
    fi
    if [[ "$status" == "ok" ]]; then
      local bin_path=""
      for cand in "${out_base}.bin" "$out_base" "${out_base}_CODE.bin"; do
        if [[ -f "$cand" ]]; then
          bin_path="$cand"
          break
        fi
      done
      local map_path=""
      for mcand in "${out_base}.map" "${out_base}.bin.map"; do
        if [[ -f "$mcand" ]]; then
          map_path="$mcand"
          break
        fi
      done
      if [[ -z "$map_path" ]]; then
        map_path=$(ls -1 "$jdir"/*.map 2>/dev/null | head -1 || true)
      fi
      if [[ -z "${bin_path:-}" || ! -f "$bin_path" ]]; then
        status=no_bin
        ls -la "$jdir" || true
      else
        size=$(wc -c <"$bin_path" | tr -d ' ')
        if [[ -n "${map_path:-}" && -f "$map_path" ]]; then
          ticks=$(z88dk-ticks "$bin_path" -x "$map_path" \
            -start TIMER_START -end TIMER_STOP -counter "$COUNTER" 2>"$jdir/ticks.err" | tr -d '[:space:]')
        else
          ticks=$(z88dk-ticks "$bin_path" \
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
    printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
      "$id" "$bench" "$clib" "$compiler" "$cpu" "$math" "${size:-}" "${ticks:-}" "$status" "$wall" \
      >>"$RESULTS"
    echo "==== END $id status=$status size=${size:-} ticks=${ticks:-} wall=${wall}s ===="
  } >>"$LOG" 2>&1
}

export -f run_one
export PATH ZCCCFG ROOT BENCH_ROOT JOBS_DIR RESULTS LOG COUNTER

running=0
declare -a pids=()
idx=0

update_status() {
  local active=0
  for p in "${pids[@]:-}"; do
    if kill -0 "$p" 2>/dev/null; then active=$((active + 1)); fi
  done
  local done_count=0
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
      tail -n 12 "$RESULTS"
    fi
  } >"$STATUS"
}

while [[ $idx -lt $TOTAL || ${#pids[@]} -gt 0 ]]; do
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
