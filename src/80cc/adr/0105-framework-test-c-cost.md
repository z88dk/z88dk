# ADR 0105 — The shared framework `test.c` was costing every cell ~160 B

Status: **Accepted.** Seven changes, each with its own opt-out, listed below.

## Context

`test/framework/test.c` (132 lines) links into every bench binary, so a defect
in how 80cc compiles it is a fixed cost in all 806 80cc cells. Compiled by each
compiler (code section only, bytes):

| | before | now | sdcc | xcc -Os | xcc -Of |
|---|---|---|---|---|---|
| 80cc fp | 754 | 596 | 594 | 582 | 662 |
| 80cc sp | 793 | 622 | | | |

`suite_run` carried most of it (setjmp keeps every value in memory, a
volatile local, a switch, and printf calls with 3, 4 and 6 arguments).

Measure a file from the compiled object (`z88dk-z80nm`, section
`code_compiler`), or from a link map by module extent. Do NOT size functions
from the gap to the next symbol: the last symbol in a module gets no size. That
undercounted every compiler by about one function and inflated the first
estimate of the gap.

## Decisions

| change | opt-out | mechanism |
|---|---|---|
| `LD_STR` rematerialised, not hoisted by LICM | `remat` (shared) | A string address is an immediate. Only `LD_IMM`/`LD_SYM`/`LEA` were in `remat_def`, so every literal under pressure took a slot, and LICM hoisted loop literals into a loop-long slot. |
| dead target spill of a zero-argument indirect call | none | `op_dst_spill_is_dead` knew `src[0]` and `LD_MEM` bases but not `call->fnptr_vreg`. Limited to smallc, near, no hidden pointer. |
| control-flow call arguments built first | `arg-reorder` | `?:`, `&&`, `||` end the block, and pushes at the producer need the call in one block, so every earlier argument spilled. If all arguments are pure (at most one touches a volatile) their order is unobservable. |
| `jp X` directly above `X:` dropped | `jp-next` | The shared return block is emitted last and block layout moves code. No copt rule covered the unconditional form. Final text filter before relaxation. |
| IX saved only for calls that dispatch through it | `ix-indirect` | `frame_has_saved_ix` saved IX for any indirect call. Only fastcall, `__sdcccall(1)` and far dispatch use it. |
| BC hand-off | `bc-handoff` | A packed temp may take BC at the op where a BC tenant dies (`i2 = i << 1`). Displaces packed candidates only when worth more (reads; 0 for a remat constant). |

Evidence is in `BENCH_MATRIX.txt` (one paragraph per change) and the commit
messages. Regression cases: `long_ir/strremat.c`, `fnptrdead.c`, `argcf.c`,
`jpnext.c`, `ixind.c`, `bchand.c`.

## Tried and refused

- **Forward loads across a single-predecessor edge in the IR** (to remove the
  reload in `if (p) p();`). It wins in unpressured code and loses where the
  value cannot stay in a register across the branch: it becomes a spill or a
  stack park. `suite_run` grew 11 B (z80 sp) and 25 B (8080). Patch not kept.
  The sound shape is an address-keyed HL belief in the lowerer (HL equals
  `[sym+off]`, carried to a single-predecessor successor), which needs no
  vreg and no longer live range. The pattern is common (callbacks, optional
  hooks); the real-file census used was too small to size it.
- **Chaining the BC hand-off between packed siblings.** A second single-use
  pointer in BC costs more than the spill it avoids: +2 to +4 B on
  `localbench`.
- **First BC hand-off without the worth rule.** `localbench` 8085 +2 B and one
  cell 0.33% slower, because the packer takes the earliest-starting candidate
  and is blind to benefit.

## Consequences and known reports

- `IR_REC_VERIFY` reports "homed in spill, unrealizable" for functions shaped
  `i = n++; a[i] = x; b[i] = y;` in fp mode (two sites each). `require_slot`
  hands them to `hd_record` (home-demote), which restores the slot and
  re-renders. Final code is correct and `long_ir` covers it, but it costs a
  retry. The reports are absent with `deadframe` off. The other verifiers are
  at baseline.
- `check_options.sh` already failed before this work (`callbc`, `mulchain-de`
  missing from `OPTIONS.md`; `ivwidth` stale).
- sp mode is 26 B above fp in `test.c`. Most of it is structural: a word read is
  `ld hl,N; add hl,sp; ld a,(hl+); ld h,(hl); ld l,a` (6 B) against 3 B for
  `ld hl,(ix+d)`. `volatile` costs nothing in fp and 11 B in sp (it forbids the
  byte narrowing the non-volatile local gets).

## Left in `test.c` (about 2 B fp)

The `longjmp` cleanup (`pop bc` twice after a call that never returns) needs a
`noreturn` concept, which 80cc does not have. A few bytes in `suite_run`:
reload after a null test (3 B), `ld bc,0; ld hl,bc` (1 B).
