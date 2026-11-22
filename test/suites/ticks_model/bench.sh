#!/bin/sh
# Measure each instruction in instructions.txt on each CPU in the z88dk-ticks emulator:
# the cycles for 100 more copies of it, divided by 100. Prints "cpu|instruction|cycles";
# an instruction the CPU cannot assemble is left out. The emulator is the reference.
# usage: bench.sh <cpu>...
tmp=${TMPDIR:-/tmp}/ticks_model.$$
mkdir -p "$tmp" || exit 1
trap 'rm -rf "$tmp"' EXIT
for cpu in "$@"; do
  while IFS= read -r ins; do
    t10= t110=
    for n in 10 110; do
      { echo "org 0"; i=0; while [ $i -lt $n ]; do echo "$ins"; i=$((i+1)); done; echo "nop"; } > "$tmp/t.asm"
      z88dk-z80asm -m$cpu -b "$tmp/t.asm" > /dev/null 2>&1 || continue 2
      end=$(( $(wc -c < "$tmp/t.bin") - 1 ))
      t=$(z88dk-ticks -m$cpu -end $(printf '%x' $end) "$tmp/t.bin" 2>&1 | tail -1)
      if [ $n -eq 10 ]; then t10=$t; else t110=$t; fi
    done
    echo "$cpu|$ins|$(( (t110 - t10) / 100 ))"
  done < instructions.txt
done
