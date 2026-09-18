# ADR 0075 — The Rabbit multiply costs a call, not a loop

Status: **Accepted** for the copt fold, which ships default-on. Inlining the
multiply is **REMOVED** — built, measured at −721 B / −1.568 %, and withdrawn.
This record keeps enough to re-derive it.

## Context, and the claim that was wrong

A sweep of the CPUs whose declared instructions had never been diffed against
what the lowerer emits (the method behind ADR 0039) noticed that the backend
never emits Rabbit's `mul`, and that `build_muldiv_integer` skips
constant-multiply strength reduction on Rabbit with this reasoning:

> Skipped on targets with a hardware multiply (Rabbit `mul`), which keep the
> helper.

**The first conclusion drawn from that was wrong, and it is the useful part of
this record.** `l_mult` on Rabbit *is* the hardware multiply —
`libsrc/l/sccz80/4-r2ka/l_mult.asm`, used by r2ka/r3k/r4k/r6k via `r2ka.lst`:

    l_mult:
    l_mult_u:
        ld  bc,hl
        mul             ; hlbc = bc * de
        ld  hl,bc
        ret

So the instruction was never unused, the comment was correct, and the "60
`l_mult` call sites on Rabbit against 5 elsewhere" census meant something quite
different from what it looked like. Those 5 are what survives strength
reduction on a CPU whose helper is a real loop; Rabbit's 60 were each three
instructions behind a `call`.

**The cost was never the multiply.** It was that `call l_mult` is an opaque
`IR_HCALL`, which sent the product through a frame slot at every site:

    call l_mult
    ld (sp+0),hl      ; store
    ld hl,(sp+0)      ; dead reload — 3 bytes, in histbench's hot loop

## Two candidate fixes, and what each measured

**Describing the helper's clobbers truthfully: REFUTED, and it cannot work.**
Rabbit's `l_mult` writes only HL and BC — `mul` sets no flags and nothing in it
touches DE, A or memory — where the preserves-index-alt tier charges it
`HL|DE|BC|A|F|MEM`. Making that exact measured **+0 bytes over 180 cells**,
byte-identical even on a shape built to hold a value in DE across the call.

The reason generalises to every CPU and is worth keeping: **DE is the
multiply's second argument.** The lowering loads `src1` into DE immediately
before the call, so nothing can be live in DE across an `l_mult` for a truthful
clobber set to preserve. The same holds for A and F. Do not re-attempt this.

**Eliding the dead reload: SHIPPED.** `80cc_rules.1` already folds exactly this
defect three times — `#R2` for `(hl)`, `#G1` for gbz80's `ld hl,sp+N`, `#S1`/`#S2`
for the two-instruction `ld hl,N; add hl,sp`. **None can match Rabbit's
one-instruction `ld (sp+N),hl`**, and the family simply had no Rabbit member. It
now does, in `lib/arch/rabbit/rabbit_rules.1`. sp mode only; fp mode addresses
through `(ix+d)` and is already covered by `#R4`. A volatile slot access carries
a `;volatile` stamp and so fails the literal-text match — the same protection
`#R2` relies on.

Measured on the 180-cell Rabbit size and tick matrices, both frame modes:

* **size −138 bytes**, 63 cells smaller, **0 larger**
* **ticks −0.105 %**, 63 faster, 3 slower (≤ +0.31 %, and those three benches
  are byte-identical — the movement is in framework code)
* no leak: every non-Rabbit CPU byte-identical in both frame modes
* biggest single win histbench −3.9 % sp, the hot-loop reload above

## Why inlining the multiply is opt-in and not default

Replacing the call with the three instructions inline is a much bigger win and
carries a cost the copt fold does not:

| | size | ticks | larger | slower |
|---|---|---|---|---|
| copt fold (ships) | −138 B | −0.105 % | 0 | 3, ≤0.31 % |
| inline (`IR_RABBIT_MUL=1`) | −721 B | −1.568 % | 21 | 15, listbench **+10..13 %** |
| both | −721 B | −1.568 % | 21 | 15 |

**Both is identical to inline alone**, which is the finding that ties this
together: all 23 dead reload pairs in the corpus come from `l_mult` sites, so
the two fixes address exactly the same defect. The inline additionally removes
the call, and that is where both its extra win and its regression come from —
the function becomes **call-free**, a different set of proposers runs, and
listbench loses an IY index home (`IR_HOMEMAP`: `v0 phys=IY home=[0,101]` before,
spilled after). That is the allocator capture gap of ADR 0036-0038 reacting to a
changed IR shape, not something this rung can price, and the index's standing
conclusion forbids answering it with a cost term.

### The inline was removed, not parked

It cost listbench **+10..13 %** on every Rabbit in both frame modes. The cause
was traced precisely — removing the call makes the function **call-free**, which
admits the `RC_DE_ACC` pool; that pool takes the best IY candidate
(`idxben=251`) before `ir_iy_reduction_pack` runs, the pack settles for
`idxben=46`, and DE cannot hold a whole-function value so it spills anyway.
`IR_OFF=word-resident` restores the original pick, which is the proof.

**Three fixes were built. All three failed, two only after measuring as large
size wins** — the full account is in `BENCH_MATRIX.txt` 16/9:

| | why |
|---|---|
| `iy-yield-idx2` | **size**: −1415 B against −1807 B without it; `recordbench fp` +80..98 on five CPUs. `idx_ben` is the same UNIT for both candidates but a different MODEL — plain index home vs `add iy,de` accumulation |
| `iy-late-home` | **correctness**: `long_ir` sp 718/727. The word-home pre-pick snapshot can already hold an IY home for another vreg, so the revert restores two owners of IY |
| `de-yield-iy` | **correctness**: sp 772/774 — and it does not fix listbench without the one above |

Left opt-in, the inline would still have charged the **default** build for the
copt gate below: **88000 ticks on callbench** (+0.32 % sp, +0.29 % fp), to guard
a bracket only the inline emits. Paying that for an unusable feature is the
wrong trade, so the rung came out and the gate with it.

**To re-derive**: `mul` is `F7`, `HL:BC = BC * DE`, signed 16x16 into 32, one
byte. The lowering is `ld bc,hl; mul; ld hl,bc`, placed BEFORE the width
dispatch in `gen_mul` (Rabbit has no 8x8, so narrowed byte operands must take
the 16x16 arm or the 8x8 path emits `mlt hl`, which Rabbit cannot assemble), and
bracketed with `push bc`/`pop bc` when a BC tenant is resident. **The
prerequisite is unchanged**: produce a benefit number for the IY reduction pack
comparable to `idx_ben`, and treat preserving a late home across the word-home
revert as unsound by construction.

## The copt rule this exposed

`lib/arch/rabbit/rabbit_rules.1` folded

    pop bc ; push hl   ->   ld (sp+0),hl

which is sound only when the popped BC is **dead** — the rule reads `pop bc` as
sccz80's discard-TOS idiom. With `IR_RABBIT_MUL=1` the inline's BC bracket emits
a genuine restore, and when the product then went to a stack transient the two
landed adjacent; the fold dropped the restore *and* scribbled on the parked
word. `examples/console/enigma.c` on r2ka printed nothing instead of RXSEC.

It was gated `%notcompiler 80cc` while the inline existed. **With the inline
removed the gate is removed too**: it costs 88000 ticks on callbench and the
only 80cc Rabbit shape that needs it was the inline's bracket. The one folded
site in the corpus is argument cleanup with BC genuinely dead. A comment at the
rule records what to do if a future lowering emits a real Rabbit `pop bc`
restore.

The same rule appears twice in `lib/arch/kc160/kc160_rules.1`, already gated off
sdcc. **Left alone**: gating it there costs a byte on `callbench`, where the
`pop bc` is genuine argument cleanup with BC dead, and no 80cc kc160 shape
needs it. Known latent hazard, recorded rather than paid for.

**The lesson is one the index already carried and it still cost an hour**: the
compiler's own asm was correct at every stage. Only `zcc -a` — which has been
through copt — showed the `pop bc` gone. Diff `z88dk-80cc` direct output against
`zcc -a` before opening a backend pass.

## Consequences

* `long_ir` 774/774 in both frame modes, serial. **`make -j` garbles the log**
  and under-counts nondeterministically (712 and 728 on two runs of an identical
  376-target set against a true 739); take pass counts from a serial run.
* Regression test `test/suites/long_ir/rabmul.c`, six targets across z80, the
  three Rabbits and 8080-as-control. It outlived the inline it was written for:
  its condensed-`enigma` case carries real register pressure around a multiply,
  which is the shape that caught the copt fold applying to a live BC restore.
* Its `enigma` case is a condensed `examples/console/enigma.c` because five
  smaller shapes were tried first and none reproduced the fold; each left an
  instruction between the `pop` and the `push`.

## What the sweep left behind

The sweep method still works — it is what surfaced all of the above. Diff
`src/z80asm/dev/cpu/opcodes.dat` against a corpus asm dump per CPU, not the
`CPU_HAS_*` macros. **But size a find before believing it**: read the helper the
call actually reaches, on that CPU, before concluding an instruction is unused.

| | |
|---|---|
| ez80 `lea hl,ix+d` | 196 fp-mode `ld hl,N; add hl,sp` pairs remain; 3 bytes against 4. Already used at the two `emit_*_slot_addr` sites *only* |
| 8085 `ld de,hl+n` (LDHI) | 64 `ld de,N; add hl,de` sites; 2 bytes against 4 — LDSI's sibling, same shape as ADR 0039 |
| z80n `add hl,a` / `add de,a` / `add bc,a` | 48 byte-widen-then-add pairs; 2 bytes against 5 |
| z180 / ez80 `tst` | a flag-only `and` that preserves A — not yet sized |
| kc160 `div hl,a` / `div dehl,bc` / `divs` | hardware divide, never emitted; only 6 helper-call sites in this corpus |

vm1 is **swept and clean**: its four `CPU_HAS_*` macros are all consulted.
gbz80 already emits its specials heavily.
