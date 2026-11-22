# ADR 0112 — Differential fuzzing found about 37 miscompiles; arrays now always count as aliased

Status: **Accepted** (2026-10), with a disclosed cost.

## Context

A generator writes random C over unsigned short/char values, pointers to locals
and globals, arrays, retargeted pointers and calls that write through them,
then compares the printed result against `gcc -fwrapv`. It lives outside the
tree (`.claude-scratch/fuzz`: `gen.py`, `run.py`, `reduce.py`). The failure
rate started at 23 % of programs, fell to 1.2 % and 0.6 % after two rounds and
to about 1 in 3000 after about 37 fixes over 13 CPU targets.

## Decision

The fixes are individually small and each has a regression test (`ptrfuzz.c`,
`fuzz_*.c`, `fuzzp_*.c` with `.want` files). The recurring classes are the
useful part:

- a vreg with no slot read as if it had one (`slot_off` -1 plus `cur_sp_adjust`
  passing a `>= 0` test): use `slot_sp_off` and `require_slot`;
- a register belief dropped by `invalidate_hl_cache` when only HL changed: use
  `invalidate_hl_keep_de`;
- text sweeps and copt rules with a regex wide enough to match a register name
  or `(sp+n)` (`#DE6`, `#W1`, the `xor a,(sp+n)` case);
- liveness helpers assuming a consumer reads a register when it reads the frame;
- AST passes (`ast_cse`, LICM, `st2ld`) not treating a write through a pointer,
  a direct write to an escaped local, or an array element as a write.

The one change with a cost: **arrays and structs always count as aliased**
(`aopt_sym_aliased`). `&arr[1]` and array-to-pointer decay never marked the array
as escaped, so a load of one element was reused across a store through a
pointer to another.

## Evidence and cost

The aliasing fix makes `startrek` larger in fp mode and `m4doors` 2 to 4 %
slower. A precise array-escape analysis would recover that; the cheap
version is unsound, which is why this stays the safe choice until one exists.

## Method

Bisect order that found every one: `IR_OFF` over each `opt_disabled` name,
then a debugger break at `emit()` on the bad text, then delta-debugging the
rules in `lib/80cc_rules.1` for text made by copt. `--opt-disable=all` does not
turn off the IR passes.

## Reopen if

The generator is widened to signed types, longs, structs and function pointers;
the current one has run out of cheap finds.
