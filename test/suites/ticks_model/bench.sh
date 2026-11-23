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
# z88dk-ticks starts its count again each time the program counter reaches -start, which defaults to
# 0, so a run that wraps round the address space never reaches -counter. Every run passes -start 10000,
# an address the program counter never has, so the count runs from the first instruction.
# usage: bench.sh <cpu>...
tmp=${TMPDIR:-/tmp}/ticks_model.$$
mkdir -p "$tmp" || exit 1
trap 'rm -rf "$tmp"' EXIT
for cpu in "$@"; do
  list="$tmp/list"; cat instructions.txt > "$list"; [ -f instructions.$cpu.txt ] && cat instructions.$cpu.txt >> "$list"
  # The Rabbit 4000 and later run in their own mode only once EDMR is set, as the startup code does.
  # The setup is measured on its own and taken off every result.
  pre=; base=0
  case $cpu in r4k|r5k|r6k)
    pre="ld a,0xc0
ioi ld (0x420),a"
    { echo "org 0"; echo "$pre"; echo "nop"; } > "$tmp/t.asm"
    z88dk-z80asm -m$cpu -b "$tmp/t.asm" > /dev/null 2>&1
    end=$(( $(wc -c < "$tmp/t.bin") - 1 ))
    base=$(z88dk-ticks -m$cpu -start 10000 -counter 1000000 -end $(printf '%x' $end) "$tmp/t.bin" 2>&1 | tail -1) ;;
  esac
  while IFS= read -r ins; do
    body=$(printf '%s\n' "$ins" | sed 's/!//g; s/ ; /\n/g')
    # The run ends at bench_end, the nop after the instruction. It is not the last byte of the binary:
    # z80asm puts the routine for an instruction a CPU lacks (adc hl,bc on the 8080) after the program,
    # and a path through it can return before reaching its last byte.
    { echo "org 0"; [ -n "$pre" ] && echo "$pre"; echo "$body"; echo "bench_end:"; echo "nop"; } > "$tmp/t.asm"
    z88dk-z80asm -m$cpu -b -m "$tmp/t.asm" > /dev/null 2>&1 || { echo "bench: $cpu: does not assemble: $ins" >&2; continue; }
    # A helper that z80asm calls but a bare binary does not link is a call to address 0,
    # which restarts the program: leave such an instruction out.
    od -An -v -tx1 "$tmp/t.bin" | tr -d '\n' | grep -q ' cd 00 00 ' && { echo "bench: $cpu: calls a helper that is not linked: $ins" >&2; continue; }
    end=$(awk '$1 == "bench_end" { sub(/\$/, "", $3); print $3 }' "$tmp/t.map")
    [ -n "$end" ] || { echo "bench: $cpu: no end address: $ins" >&2; continue; }
    t=$(z88dk-ticks -m$cpu -start 10000 -counter 1000000 -end $end "$tmp/t.bin" 2>&1 | tail -1)
    case $t in ''|*[!0-9]*) echo "bench: $cpu: no result: $ins" >&2; continue ;; esac
    t=$((t - base))
    [ $t -gt 0 ] || continue
    echo "$cpu|$ins|$t"
  done < "$list"
done
