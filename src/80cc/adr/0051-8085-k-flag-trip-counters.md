# ADR 0051 — 8085 K-flag trip counters

Status: **Accepted** (2026-09-18). Opt out with `k-trip`.

Same family as ADR 0039 (LDSI slot addresses): a CPU capability the backend
declares and never uses.

## Context

`dec rr` sets no usable zero flag on the z80, so a 16-bit counted loop ends with
a three-instruction test:

```
dec hl / ld de,sp+6 / ld (de),hl / ld a,h / or l / jp nz,L
```

The 8085 has the **K flag** (bit 5, also X5/V) and the `jp k` / `jp nk` branches
(opcodes `FD` / `DD`, 3 bytes, 10/7 T). `CPU_HAS_JP_K()` exists in `define.h` and
**no backend file consults it** — one of five declared-but-unused capability
macros, and the only one that is not KR580VM1-only.

It is an established idiom elsewhere in this tree: **172 sites** in `libsrc` use
`jp k` / `jp nk`, including the sccz80 8085 comparison helpers and the micro8085
UART and SPI drivers.

## The opportunity

The originating corpus report counted **236 raw instruction lines** for
`ld a,<hi>; or <lo>` 16-bit zero-tests. Normalised to logical tests (the two
instructions in each test, emitted in both 8085 frame modes), that is **59
tests**. The 8085 frame modes are identical, so frame duplication does not
create new candidates.

The recurring shape has a `dec rr` three lines above the test, separated only by
LDSI and SHLX — and **neither writes flags** (`i8085_ld_de_spn` and
`i8085_ld_ide_hl` in `src/ticks/i8085_inst.c` only touch registers and `st`), so
K survives from the decrement to the test.

Each conversion drops `ld a,h; or l`: **2 bytes and ~8 cycles, and it frees A**.

The emulator models the flag correctly — `DECW` sets `fk = (a&b)==0xff` and
`INCW` sets `fk = (a|b)==0`, in `src/ticks/ticks.c` — so this is testable under
`z88dk-ticks` with no emulator work first.

## Why this is not a peephole

`jp nk` cannot simply replace `jp nz`. The repo's own 8085 notes state it:
**"K after `dec rp` sets on −1, not on 0."**

Our loops test `!= 0`; K reports `== -1`. Substituting the branch runs one extra
iteration. Making it correct means shifting the counter's **initial value by
one**, which is an IR loop transform, not a text rewrite — nearer the existing
`lftr` machinery than the post-pass rungs.

## Proposed scoping

Apply only to a **pure trip counter**: decremented in the loop, never read for
its value, dead after the loop. Shifting the init is then invisible, and no
other use needs a compensating `+1`. Anything else is out of scope.

## Measurement result

The 30-benchmark corpus was rebuilt at the originating revision and scanned in
8085 output. The classification was deliberately conservative:

| class | logical tests | raw line/frame units |
| --- | ---: | ---: |
| pure trip counter | **33** | **132** |
| decrement-linked, but value/pointer/index is used | 8 | 32 |
| no qualifying decrement nearby | 18 | 72 |
| total | **59** | **236** |

The takeable fraction is therefore **33/59 = 55.9%** of logical tests (or
132/236 of the historical raw count). Pure counters include repetition loops
and finite loops whose induction variable is only a bound. Rejected examples
include array/list walkers, the N-queens row scan, the hash-table clear index,
and the VM's value-bearing countdown. No 8080, VM1, or non-counter loop was
included.

This answers the sizing question, but does not justify building the transform:
33 sites are enough to prototype, and every rewrite still needs a proof that
the initial value can shift without changing an observable value. The proposed
next step is a small IR loop prototype with negative tests for the eight
rejected decrement-linked shapes.

## Effort

Two to three times ADR 0039, which was a text rewrite gated on liveness the
post-pass already computed. This needs a loop-shape analysis and an IV edit, so
it wants the full gauntlet plus a `long_ir` case whose valuable half is the
counters that must **not** be rewritten — one read inside the body, one live
after the loop, one incrementing rather than decrementing.

## Shipped

The shape analysis this ADR called for turned out to already exist:
`AST_LOOP_COUNTDOWN` is only created by the loop-reversal pass (`ast_opt.c`),
and its own preconditions — `iv` not mentioned anywhere in `BODY`, no `break`
— already guarantee the private counter it builds is a **pure trip counter**
(decremented, never read, dead after the loop) by construction. Every negative
shape from the "Proposed scoping" section above (a value read, a pointer/index
use, an incrementing loop) simply never reaches `AST_LOOP_COUNTDOWN` in the
first place, so no separate `k-trip` shape analysis was needed beyond the
literal-positive-trip-count check.

`ir_build.c`'s `AST_LOOP_COUNTDOWN` handler seeds the counter at **N-1**
instead of N when the trip count is a compile-time positive literal
(`CPU_HAS_JP_K() && !opt_disabled("k-trip")`), and tags the latch's
`IR_BR_COND` with `IR_BRCOND_KTRIP`. `gen_br_cond` (`ir_lower_ops.inc.c`)
emits `jp nk,L` instead of rebuilding the `ld a,h; or l; jp nz,L` zero test
when it sees that tag. The initial skip-if-zero check ahead of the loop stays
`IR_BRZ_PHANTOM` (elided entirely) regardless of the shift, since a positive
literal trip count already proves the loop runs at least once.

K reaching -1 exactly after N bodies (not after 0) is confirmed against the
project's own 8085 model, not just the datasheet: `DECW`/`INCW` in
`src/ticks/ticks.c` set `fk = (a&b)==0xff` after a 16-bit decrement — K fires
only on the pair reaching -1 — which is the authority `z88dk-ticks` gates
against.

**Result**: 8085-only compile-only corpus scan (`corpus_sizescan.sh`,
`CPUS=8085`, 30 benches x 2 frame modes = 60 cells, baseline vs this change,
same installed binary otherwise) — **-156 B over 52/60 cells, 0 larger, 0
build failures** (sp and fp identical throughout, as expected: the 8085 has no
IX, so frame mode does not affect this site). `long_ir` 846/846 in both frame
modes (up from 842 — the four new `test_8085_k_trip` targets), the one
pre-existing `longshl_vm1` gap unchanged. `check_options.sh` 132 names OK
(`k-trip` added); `check_gates.sh` 43 listed live OK.

## Follow-on fix: the counter was homed in BC, and DEC didn't know it

When the allocator homes the private counter in BC (the common case — a
call-free trip counter has nothing else competing for the pair), the latch
compiled to `ld hl,bc; dec hl; ld bc,hl` before this fix: `gen_inc`
(`ir_lower_ops.inc.c`) already had an in-place fast path for a BC/DE-homed
`++` (`inc bc`/`inc de` directly, no HL round trip), but `gen_dec` never got
the mirror, so every BC/DE-homed `--` — this K-trip latch included — paid the
copy-out-and-back regardless of CPU. `ticks.c`'s `DECW(b,c)`/`DECW(d,e)` set
the 8085 K flag identically to `DECW(h,l)`, so `dec bc` is not just shorter,
it is the more direct source of the flag `jp nk` reads.

Added the missing case to `gen_dec`, verbatim mirror of `gen_inc`'s (same
`gpderef` opt-out, same `IR_VREG_CALL_SPLIT` exclusion — a call-split value's
frame slot must stay coherent, and a bare `dec bc` would update BC without
it). `ktrip_word`'s latch is now `dec bc; jp nk,L` — 1 byte instead of 5, and
K comes straight from the register that decremented instead of a shuffled
copy. Full corpus×CPU×frame-mode scan (`corpus_sizescan.sh`, 11 CPUs, 720
cells): 0 changed — no bench source happens to carry a BC/DE-homed in-place
decrement, so the win is real but unexercised by the standard corpus.
Gate-off (`IR_OFF=gpderef`) is byte-identical to the pre-fix compiler across
all 720 cells. `long_ir` 846/846 in both frame modes, same one pre-existing
`longshl_vm1` gap.

## Second follow-on: the zero-test after it still went through HL

Even with the decrement fixed to `dec bc`, the loop-back zero-test on any
non-8085, non-Rabbit4K CPU (the K-trip counter has no `jp nk` to skip it with)
still read `ld hl,bc; ld a,h; or l` — `emit_test_zero` (`ir_lower_ops.inc.c`)
only special-cased Rabbit4K's one-op `test bc`/`test hl` and a frame-slot
value read straight from memory; a BC/DE-resident value on every other CPU
was ferried through HL first regardless.

Added the missing case: when the tested value is BC- or DE-resident and HL
does not already hold it, test the two halves directly (`ld a,b; or c` /
`ld a,d; or e`) instead of copying through HL. Touches only A, so every other
cache stays exactly as valid as before. `ktrip_word`'s z80 loop back-edge is
now `dec bc; ld a,b; or c; jr nz,L` (4 bytes) instead of `dec bc; ld hl,bc;
ld a,h; or l; jr nz,L` (7 bytes).

Same gauntlet, combined with the decrement fix above: full corpus×CPU×frame
scan (720 cells) — 0 changed (the standard corpus's reversed-to-zero loops
don't currently land their counter in BC/DE either); `long_ir` 846/846 both
frame modes, same one pre-existing `longshl_vm1` gap.
