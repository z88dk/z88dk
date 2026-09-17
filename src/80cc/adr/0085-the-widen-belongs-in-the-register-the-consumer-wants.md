# ADR 0085 — the widen belongs in the register the consumer wants

Status: **Accepted**, default on. `--opt-disable=de-widen` opts out.

This ADR also closes the **zero-extension vein** the design index carried as the
next job. The rung below is what survived a full census of it; §"What the census
refused" is the more valuable half.

## Context

The design index named zero-extension as "the one *consistent* gap against
ez80clang" and therefore the next lever: per 1000 instructions, enigma 33.5
against clang's 1.3, emu 18.5 against 8.8, clisp 16 sites against zero.

A census over the emitted text answers what that ratio does not: **how many
bytes are actually recoverable.** Every `ld h,0` / `ld d,0` in a corpus asm dump
(30 benches) plus the three real files (enigma, clisp, adv_a), classified by the
line before and the line after:

* **166 sites** in bench + real, **442-499** over the whole dumped set — and the
  count barely moves with the CPU (z80 442, ez80 442, r2ka 450, gbz80 441,
  8080 499), so there is no target where it is the disease.
* The ceiling is therefore 2 bytes a site, and **most sites are already at the
  z80 encoding floor.** A zero-extended byte pushed as a word argument is
  `ld l,a; ld h,0; push hl` — 4 bytes, and nothing shorter exists; that shape
  alone is 24 of the 166. Byte-index-times-two (`ld l,a; ld h,0; add hl,hl`,
  20 sites) is likewise minimal.

One shape is not at the floor, and it is a *pipeline* defect rather than a
lowering choice.

## Decision

`ld e,S; ld d,0; ld hl,de` — a byte zero-extended into DE and then copied into
HL — becomes `ld l,S; ld h,0`. Two bytes and 8 cycles, and the copy disappears.

It exists because the widen and its consumer are chosen by **different passes**:
`load_to_de` stages the byte, and then `gen_add` takes its `add hl,bc` arm,
which wants the value in HL and finds only the DE cache. **Every** site in the
dump is followed by `add hl,bc` — 12 on z80 (9 of them inside the 30-bench
corpus), 14 on ez80, 13 on r2ka, 10 on gbz80 — so the shape has one cause, not
a family of them.

A rung in the emitted-text post-pass in `ir_lower.c`, beside `[ldsi-addr]`,
`[ldhi-addr]` and `[z80n-add-a]`, on the same backward liveness. Two conditions,
and the second one is the short list:

* **D and E dead after the copy.** That is the whole proof: the rewrite stops
  defining DE, so a later reader would see whatever DE held before. The same
  `!d_live && !e_live` the `[de-park]` and `[z80n-add-a]` rungs rest on, and
  since ADR 0084 it is no longer defeated by every `call` and every `ret`.
* **No flag condition.** All four spellings are register moves and an immediate
  load; none touches F. That is unusual here — `[ldsi-addr]`, `[ldhi-addr]` and
  `[z80n-add-a]` each need `!f_live` because they trade an `add` away.

`S` may name H or L: `ld e,h; ld d,0; ld hl,de` becomes `ld l,h; ld h,0`, which
reads H before overwriting it exactly as the original did. It may equally be
`(hl)` or `(ix+d)` — the operand rides along inside one instruction, so the
memory read happens at the same point in both spellings.

The dropped `ld hl,de` **reads** DE, so the rung `continue`s rather than folding
that read into the liveness for the lines above it: the copy is gone, and the
two rewritten lines carry their own effects when the backward walk reaches them.
Folding it anyway would only be conservative, but it would report DE live
through a region where it is not.

## Consequences

Measured on the 720-cell size matrix (30 benches × 12 CPUs × both frame modes)
and the tick matrix, with `IR_OFF=de-widen` as the baseline:

* **size −358 bytes, 43 cells smaller, 0 larger**
* **ticks 0 cells slower.** z80, 60 cells: 3 faster, −0.0760 %. Across all 11
  tick CPUs on the affected benches, 66 cells: **41 faster, 0 slower**,
  −0.4972 %. All `fail=0`. Bytes and cycles move together because the rewrite
  deletes an instruction rather than trading one for another.
* **Gate-off is byte-identical to the pre-change compiler**: 0 of 720 cells
  differ against a `git worktree` build of the parent commit — not merely
  against the same binary with the gate off, which proves less.
* `long_ir` **both frame modes**, all pass; console behavioural gates in both
  modes.

**And now the honest headline, because the total hides it: the win is three
benches.** divbench −252, shiftbench −90, widthbench −16, and **every other
bench is zero**. So are all three real files — `clisp`, `adv_a` and `enigma`
are byte-identical in both frame modes with the rung on and off. The shape
needs a `%` or a mask by a power of two feeding an accumulator that holds a BC
home, and outside those three benches the corpus does not do that.

That runs straight into the rule ADR 0078 used to refuse `add hl,nn` — *one
function's win is not a corpus win.* It is shipped default-on anyway, and the
distinction is worth stating because it is the whole argument: `add hl,nn` was
**size-neutral** and bought only DE preservation at 4 sites, so concentration
made it worthless. This is an unconditional 2 bytes and 8 cycles at every site
it fires, with **0 cells larger and 0 cells slower** — there is no trade to be
concentrated *against*. A rule that costs nothing anywhere does not need to be
spread out to earn its place; one that costs something does.

## What the census refused

Five more zero-extension shapes were sized on the same dump and **left out**.
The numbers are the decision, so they stay here:

* **A dead `ld h,0`** — the widen whose H is overwritten before it is read.
  A straight-line forward walk finds **32** in the whole dump but only **5** in
  the 30-bench corpus and **0** in enigma/clisp/adv_a; 27 of the 32 are in one
  test file (`sccz80-bitfields.asm`). **10 bytes of corpus.**
* **The fastcall byte argument whose callee declares a 1-byte parameter.**
  `ir_lower_call.inc.c` widens H deliberately, because a `char` passed to
  `int toupper_fastcall(int)` is read as the full HL; a genuine 1-byte callee
  ignores it. The prototype knows which, but it is **8 sites, 16 bytes**, against
  a rule that has to be right about every callee in the tree.
* **`ld l,a; ld h,0; push hl; pop iy` → `ld iyl,a; ld iyh,0`.** One byte, and it
  keeps HL. **7 sites**, 6 of them in enigma. One function's win is not a corpus
  win (ADR 0078 refused `add hl,nn` on the same ground).
* **The zero-extended byte against a 16-bit constant** —
  `ld l,a; ld h,0; ld de,65; and a; sbc hl,de` → an 8-bit `sub` plus
  `sbc a,a` sign fill. Four bytes each and the largest per-site prize found,
  but **12 sites** and 8 of them live in two files.
* **`ld l,n` + `ld h,m` → `ld hl,mn`**, one byte and four cycles. **19 sites**
  over the whole dump.

Together that is roughly **110 bytes spread over five separate rungs**, each
needing its own liveness proof, its own gate and its own regression test —
against `[de-park]`'s single rung for 98. **Zero-extension is not one lever; it
is five fifteen-byte ones**, and the index should stop calling it the next job.

What would reopen it: not a peephole. The ratio against clang is real, and what
produces it is that clang keeps byte values in **8-bit registers** while 80cc's
HL bus forces a 16-bit accumulator — which is vein 3 (the HL-bus problem), not
this one. A census of *emitted widens* is the wrong meter for that; the meter is
the shuffle count already measured at 1572 bytes on z80.

## The operand allowlist, and what it is really for

The rung respells `ld e,<op>` as `ld l,<op>`, and **that is not sound for every
operand.** `ld e,ixh` assembles; `ld l,ixh` does not exist, because an index
half cannot share an instruction with H or L — z80asm rejects it as a syntax
error, loudly rather than silently. `opcodes.dat` carries **49** such E/L
asymmetries: `ixh`/`ixl`/`iyh`/`iyl` on every index-half CPU, and `(hl')` and
`h'` on the KR580VM1. So `dw_operand_ok` is an **allowlist** — a plain 8-bit
register, `(hl)`, `(ix±d)`/`(iy±d)`, or a decimal immediate — and for each of
those `ld l,<op>` is real on exactly the same CPU set and a synthetic on none.

**Say what that guard is worth, which is less than it looks.** Every
parameterised `ld e,` emit site in the backend produces either
`(frame_reg()±d)` or a decimal immediate; nothing puts an index half into E
today. Checked both ways: the corpus asm diff with and without the allowlist is
**0 differing of 720 cells**, and every `ld e,` operand spelling emitted across
all of `long_ir` (75 sources × 6 CPU variants × both frame modes) is inside it —
a, `(hl)`, a decimal, c, h, d, l, `(ix±d)`. The allowlist guards a **future**
emit site, not a present one. That is worth having and is not worth claiming as
a live guard.

## Regression test

`test/suites/long_ir/dewiden.c`, seven targets: z80 sp/fp, the two
`--opt-disable=de-widen` controls, and 8080 / gbz80 / r4k. The rung fires in
**every one** — sites remaining of 8 (9 on gbz80): z80 1, r4k 2, gbz80 3,
8080 5 — so no target is decorative.

`sdiv` is the firing shape, six sites, all converted. `kmix` is divbench's own
and carries both answers: one site converts and one is declined, because there
the copy is followed by `ex de,hl ... add hl,de` and DE reads live back through
the swap.

**What that decline proves, and no more.** Built with the `!d_live && !e_live`
test deleted, this file still **passes** — the decline is conservative here, not
load-bearing. So `kmix` proves the guard is REACHED, which is what a regression
test can honestly hold; whether the guard is ever the only thing between the
corpus and a wrong answer is settled by `long_ir` and the corpus. Claiming
otherwise is what went wrong in ADR 0039 and again in ADR 0077.

`kmix` must not be `static`: made static and called with constants it is
specialised, both sites convert, and the guard is not reached at all.
