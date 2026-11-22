#!/bin/sh
# Measure each instruction in instructions.txt on each CPU in the z88dk-ticks emulator:
# the cycles it takes to run once, from the start of the program to the end address.
# Prints "cpu|instruction|cycles"; an instruction the CPU cannot assemble or run to the end is left out. The emulator is the reference.
# A line may be several statements separated by " ; " (a setup the model scores too); a
# statement that starts with "!" is a branch that is taken, which the assembler never sees.
# IX is 0 in these programs, so an indexed store with a small displacement writes into the
# program itself: use a displacement of 100 or more in a store that follows another instruction.
# A CPU can have extra forms of its own in instructions.<cpu>.txt, such as the eZ80's native
# word accesses, which z80asm builds from several instructions on the other CPUs.
# usage: bench.sh <cpu>...
limit=; command -v timeout > /dev/null 2>&1 && limit="timeout 20"
tmp=${TMPDIR:-/tmp}/ticks_model.$$
mkdir -p "$tmp" || exit 1
trap 'rm -rf "$tmp"' EXIT
for cpu in "$@"; do
  list="$tmp/list"; cat instructions.txt > "$list"; [ -f instructions.$cpu.txt ] && cat instructions.$cpu.txt >> "$list"
  while IFS= read -r ins; do
    body=$(printf '%s\n' "$ins" | sed 's/!//g; s/ ; /\n/g')
    { echo "org 0"; echo "$body"; echo "nop"; } > "$tmp/t.asm"
    z88dk-z80asm -m$cpu -b "$tmp/t.asm" > /dev/null 2>&1 || continue
    # A helper that z80asm calls but a bare binary does not link is a call to address 0,
    # which restarts the program: leave such an instruction out.
    od -An -v -tx1 "$tmp/t.bin" | tr -d '\n' | grep -q ' cd 00 00 ' && continue
    end=$(( $(wc -c < "$tmp/t.bin") - 1 ))
    t=$($limit z88dk-ticks -m$cpu -counter 1000000 -end $(printf '%x' $end) "$tmp/t.bin" 2>&1 | tail -1)
    case $t in ''|*[!0-9]*) continue ;; esac
    [ $t -gt 0 ] || continue
    echo "$cpu|$ins|$t"
  done < "$list"
done
