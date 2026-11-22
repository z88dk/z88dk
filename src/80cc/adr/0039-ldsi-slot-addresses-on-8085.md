# ADR 0039 — LDSI slot addresses on the 8085

Status: **Accepted**, default on. `--opt-disable=ldsi-addr` opts out.

## Context

Forming the address of a stack slot on the 8085 cost `ld hl,N; add hl,sp` — 4
bytes, 20 cycles — the z80 sequence, because the lowerer had no 8085 rung for
it. The 8085 has LDSI (`ld de,sp+N`, 2 bytes, 10 cycles per
`src/ticks/i8085_inst.c`), so the same address costs `ld de,sp+N; ex de,hl`:
**3 bytes and 14 cycles**.

This came out of ADR 0038, which failed. Pricing the 8085 correctly in the cost
model made the output worse; the lowering gap it exposed on the way is what was
actually worth having.

## Decision

Rewrite the pair in the emitted-text post-pass in `ir_lower.c`, beside the
`[xor-a]` rung, which already has the per-register backward liveness fixpoint
this needs. Three conditions, each a real hazard:

* **D and E dead after the pair.** `ex de,hl` is a swap, not a copy — DE comes
  back holding the old HL. HL is being overwritten by this very sequence so
  losing it is free; DE is not.
* **F dead after the pair.** `add hl,sp` (DAD SP) **writes carry** and the LDSI
  pair does not. A consumer of that carry would read a stale flag.
* **N in 0..255.** LDSI's operand is one unsigned byte.

Belief-based tests would not be sound here — the register cache tracks whole
pairs, so a value in D or E alone is invisible to it. This is why the rung lives
in the post-pass, on real liveness, and not at the emit site. The same reasoning
is already written down in `ir_lower_regcache.inc.c`, which declined a "DE looks
unused" shortcut for exactly this reason.

## Consequences

Measured on the 720-cell size matrix and the 8085 tick matrix, both frame modes:

* **size −366 bytes**, 46 cells smaller, **0 larger**
* **ticks −0.948 %**, 46 cells faster, **0 slower**
* **no leak**: every non-8085 cell byte-identical, z80 reference 422/422
* `long_ir` **739/739 in both frame modes**; corpus 60/60 cells `fail=0`

A census over the corpus 8085 output found 1920 `ld hl,N; add hl,sp` sites, all
within LDSI range, 346 with DE dead — and the realised saving, 366 bytes, lands
just above that, since some sites the scanner called unknown were takeable.

The 1574 sites where DE is live were **left alone on purpose**. There
`ex de,hl; ld de,sp+N; ex de,hl` would preserve DE at 18 cycles against 20, but
the same 4 bytes — 2 cycles for a third form to maintain and a second flag
hazard to get right. Not worth it.

Regression test `test/suites/long_ir/ldsiaddr.c`, six targets including
`_8085_keep` (gate off) and `_8080` (a CPU with no LDSI, so a control). Its
value is the three functions where the rung must **not** fire — `de_live`,
`carry_live`, `big_frame` — each verified unchanged in the asm while `de_dead`
converts 14 sites.

**The first version of that test was decoration**: it passed, and the rung fired
nowhere in it. Array-indexed loops keep DE busy; the shape that actually
converts is several scalar members of a local struct updated in a loop, where
the values live in A/HL. Diff the asm gate-on against gate-off per function
before believing a codegen test, which is the house rule and was worth the
reminder.
