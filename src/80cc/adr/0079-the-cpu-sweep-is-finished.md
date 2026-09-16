# ADR 0079 — The CPU sweep: three refusals, one re-aim, and its own lesson

Status: **Accepted**. Closes vein 1 of `DESIGN_INDEX.md`.
Item 1 is **superseded by ADR 0081**, which shipped it.

## Context

Vein 1 asked for one thing: diff each CPU's declared instruction set against
what the lowerer emits, from `src/z80asm/dev/cpu/opcodes.dat`. It paid twice
before this round (ADR 0039 LDSI, ADR 0075 the Rabbit store-reload fold) and
three more times in it (ADR 0077 LDHI, ADR 0078 `add hl,a`, ADR 0080
`inc MEM`). This ADR records the rest: what was refused, with the numbers, so
nobody re-derives it.

The method used here, and the one to repeat: for each CPU, take the mnemonics
declared real (`_`, not a synthetic `X`) for that CPU from `opcodes.dat`, take
the mnemonics actually emitted from a full-corpus asm dump for that CPU in both
frame modes, and subtract. Then **read the operands**, because a mnemonic-level
diff is blind in both directions — `add` is emitted as `add hl,de` while
`add hl,a` never is, and `ld de,sp+n` and `ldsi` are two rows for one opcode.

## Decision — three refusals and one re-aim

**1. ez80 `lea hl,ix+d`. NOT refused — re-aimed, and it is the one item of
this vein still open.** The first reading here was that `lea` cannot help,
because every `lea` form in `opcodes.dat` bases on **IX or IY** (ED 22 /
ED 23 …) and there is no SP-relative `lea`. That much is true, and so is the
observation that the IX-based formations are already done — the corpus holds
**zero** `ld hl,N; add hl,ix` or `add hl,iy` pairs, the lowerer having emitted
`lea hl,ix-114` and friends for a while.

The conclusion drawn from it was wrong, and the maintainer caught it: **in fp
mode the same address is reachable from IX, and the compiler knows the
offset.** `slot_ix_off` is literally `slot_off` minus `f->frame_size`, and
`cur_sp_adjust` does not apply because IX does not move — so
`lea hl,ix+d` (3 bytes, and no carry clobber) replaces
`ld hl,N; add hl,sp` (4) wherever the displacement fits a signed byte.

Classifying all 196 fp-mode sites on ez80 says how much is there:

| | |
|---|---|
| **101** | a **plainly framed, non-acc** function — takeable |
| 66 | the prologue's own `ld hl,-F; add hl,sp; ld sp,hl`. Also takeable, and trivially so: IX was loaded from SP two instructions earlier, so `lea hl,ix-F; ld sp,hl` saves the same byte |
| 22 | not framed (no `add ix,sp`) — IX is not a frame base, must stay sp |
| 7 | `uses_acc` — `fp_active` is FALSE there because the wide-accumulator helpers **clobber IX**; these must stay sp |

**And it is one emitter, not a hundred: 89 of the 101 are followed by
`ld (hl),de`** — the ez80 word store into a frame slot — with 8 more in the
in-place long shift (`srl (hl)`; `ir_lower_cmp.inc.c`) and the rest scattered.

The attempt made here **failed and was removed**, and the reason is the useful
part: the lea path was added to `emit_slot_addr_off`, the *general* slot-address
materialiser in `ir_lower_analysis.inc.c`, where it fired **zero** times.
Those 101 sites do not go through it. They are **hand-rolled** `emit(out,
"ld\thl,%d", slot_off(...) + L.cur_sp_adjust); emit(out, "add\thl,sp")` pairs
at a handful of emit sites that never call the materialiser. So the work is a
small refactor — one `emit_frame_addr_hl(f, canon_off)` helper carrying the
lea-or-sp decision, and the hand-rolled sites routed through it — not a new
rung. ~167 bytes on ez80, and `!L.cur_frameless` is load-bearing at every one
of them: `fp_active` returns TRUE for a frameless function.

**2. z180 / ez80 `tst`.** `tst` is 2 bytes (`tst r`) or 3 (`tst n`) against
`and`'s 1 and 2, so it can only pay where A must survive a **flag-only** test.
Of **610** `and` lines in the z180 corpus, **zero** are flag-only: 157 are
`and a`, which already preserves A, is one byte, and clears carry for the
`sbc hl,de` that follows it; every other site consumes the **result**, which
`tst` discards. There is no application, not a small one.

**3. kc160 `div hl,a` / `div dehl,bc` / `divs`. Already mined — and this is the
Rabbit `mul` trap repeating, in the same index.** The instruction is absent
from 80cc's own output, which is what the row measured, but the divide is a
helper-sized operation and **the helper uses it**:
`libsrc/math/integer/l_divs_16_16x16.asm` branches on `__CPU_KC160__` to
`l_kc160_divs_16_16x16`, which is `ld bc,de; ld a,h; rlca; sbc a; …;
divs dehl,bc`. Proven in the linked binaries, not just the source:
`vecbench` on kc160 carries `l_kc160_divs_16_16x16` in its map and **ED 7D**
(`divs dehl,bc`) once and **ED 75** twice in its bytes; `divbench` carries
`l_kc160_divu_32_32x16` and ED 75 twice. Inlining it in the compiler instead
would cost `ld de,0; div dehl,bc` = **5 bytes against a 3-byte call**, which is
the byte-for-tick trade ADR 0075 and ADR 0076 refused for the Rabbit multiply,
at 8 corpus sites.

**The general lesson, and it cost time twice now: the sweep must ask whether
the shipped CODE PATH uses an instruction, not whether the COMPILER emits it.**
A mnemonic missing from 80cc's asm may be missing because it belongs in the
library — `mlt` on z180 and `mul` on z80n are the same story, both already
inside `l_mult`.

**4. z80n `add hl,nn` and `push nn`.** Sized and refused in ADR 0078: both are
size-neutral against what the lowerer already emits, and the register
preservation they offer is unwanted (4 park deletions, all in one function, for
`add hl,nn`; zero for `push nn`).

## Consequences

Vein 1 is closed **except for item 1**, the ez80 fp-mode address formation,
which is sized (~167 bytes), located (one helper plus a handful of hand-rolled
emit sites) and left as a discrete piece of work. What the vein produced across
its lifetime: five shipped optimisations (ADR 0039, 0075, 0077, 0078, 0080) and
three documented refusals, against a method that costs about an hour per CPU.

Still un-emitted after the sweep, and deliberately: `pea` (ez80), `neg`, `rlc`
/ `rrc` and `set` (the corpus has no memory bit-set site; `res` and `bit` are
emitted), the block I/O and interrupt families, and every ADL-suffixed
(`.l`/`.lis`) form, which needs 24-bit mode 80cc does not target. The 8085
K-flag trip counter (ADR 0051, *Proposed*) stays parked with its 236 sites
unsized — it is not an instruction gap but a loop-shape change.

**The sweep's most valuable by-product is not an instruction at all.** Building
ADR 0078 showed that 15 of 20 candidate sites are refused because
`instr_effects` treats **every `call` as reading DE** (the `__sdcccall(1)`
argument ABI) and **every `ret` as reading DE** (the DE:HL result ABI). Both
are true only sometimes. That single conservatism throttles four rungs at once
— [de-park], [ldsi-addr], [ldhi-addr], [z80n-add-a] — and the fix has a
precedent in the same file: `xline_c_call` did exactly this for BC, letting
[bc-call] see that a call to compiled C code cannot read it. That is the
recommended successor to this vein.
