# ADR 0080 — A memory increment is one instruction

Status: **Accepted**, default on. `--opt-disable=inc-mem` opts out.

## Context

A byte read-modify-write through a pointer was emitted as the three
instructions the IR describes:

    ld a,(hl)      ; 1 byte        ld a,(ix+d)    ; 3 bytes
    inc a          ; 1 byte        inc a          ; 1 byte
    ld (hl),a      ; 1 byte        ld (ix+d),a    ; 3 bytes

Every CPU in `src/z80asm/dev/cpu/opcodes.dat` does that in one — `inc (hl)`
is native on the **8080**, the **gbz80** and the **KR580VM1** as well as the
whole z80 family, and `inc (ix+d)` on everything that has an index register.
So the (hl) form goes from 3 bytes and 18 cycles to **1 and 11**, and the
(ix+d) form from 7 bytes and 42 cycles to **3 and 23**.

This is the largest find of the CPU sweep (ADR 0079) and it was missed by the
sweep's own first pass, because a mnemonic-level diff sees `inc` in the emitted
set — `inc hl`, `inc a` — and reports nothing. **Only the operand form was
missing.** That is the third time in this vein that the mnemonic diff was too
coarse, and the reason the ADR 0079 method now says to read the operands.

## Decision

A rung in the emitted-text post-pass in `ir_lower.c`. `im_rmw_triple`
recognises the triple and returns the increment mnemonic plus the operand text;
the rewrite replaces the store with `inc MEM` and drops the other two lines.

* **Operand form.** `(hl)`, `(ix±d)` and `(iy±d)` only. There is no
  `inc (bc)` and no `inc (nn)`, so a pointer that took a BC home, or a global
  accessed by symbol, is not a candidate however similar the text looks.
* **A dead after.** The rewrite stops leaving the new value in A. This is the
  only condition.
* **Flags are NOT a condition, deliberately.** `inc a` and `inc (hl)` are the
  same 8-bit INC: both set S/Z/H and leave carry alone, on every CPU in the
  table. Nothing is gained by asking, and asking would have cost most of the
  sites, because an increment is usually followed by the loop's own compare.
* **No CPU gate**, because there is no CPU without the instruction.

**The A-liveness walk is a new one, `im_a_live_walk`, and that choice is the
difference between a small win and this one.** The existing `gw_a_dead_after`
stops at the first branch and answers "live", and a counter incremented in a
loop body is followed by the back-edge `jp L_head` — so the straight-line
walker refuses exactly the sites worth having. `im_a_live_walk` follows
branches instead, memoising visited lines so a loop terminates, modelled on
`de_fwd_walk` which has done the same for DE for some time. A `djnz` is
conditional despite carrying no comma, and is treated as such; a `ret`, a
`call` and a branch out of the buffer all answer LIVE, because A is both a
return register and a fastcall byte-argument register.

It is a **separate** walker rather than a widening of `gw_a_dead_after` on
purpose: that one is shared with the `[gwiden]` fold, and widening it would
change a second rung's output for reasons having nothing to do with this one.
That is the "gate the call sites, not a shared helper" rule from the index,
applied to an analysis rather than a gate.

## Consequences

Measured on the 720-cell size matrix, both frame modes, all 12 CPUs:

* **size −606 bytes**, and **0 cells larger**
* it pays on **every CPU in the matrix** — this is the only rung in the sweep
  that is not CPU-specific
* `long_ir` **789/789 in both frame modes**
* behavioural gates green both modes: `enigma` RXSEC (158603 sp / 146010 fp,
  both *faster* than before), `clisp` 6 then 42, `adv_a`, `sorter`

Regression test `test/suites/long_ir/incmem.c`, eight targets: both frame
modes, both gate-off controls, and 8080 / gbz80 / 8085 / r4k, which are here to
prove the rung is safe on the CPUs whose `inc (hl)` is the *only* form they
have. `bump_member` fires; `bump_stat`, `use_post` and `use_pre` must not
change, and `bump_stat` is a **real** guard rather than a tripwire — its
stepped pointer takes a BC home, so the RMW reads `(bc)`, which no CPU can
increment in place.

The global form `ld a,(_g); inc a; ld (_g),a` is **not** handled. There is no
`inc (nn)`; `ld hl,_g; inc (hl)` would be 4 bytes against 7 but spends HL, and
the shape occurs **zero** times in the corpus, so the omission costs nothing
measurable.
