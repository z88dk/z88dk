# ADR 0084 — DE is not read by every `ret`, nor by every `call`

Status: **Accepted**, default on. `--opt-disable=de-ret` and
`--opt-disable=de-call` opt out, independently.

## Context

`instr_effects` answered "this line reads DE" for **every** `ret` and **every**
`call`. Both answers rest on a real ABI fact, and both are true only sometimes:

* a `ret` reads DE because the long and float result is returned in DE:HL;
* a `call` reads DE because an argument convention can pass one there.

One over-claim throttled **four** rungs at once — `[de-park]`, `[ldsi-addr]`,
`[ldhi-addr]` and `[z80n-add-a]` — because each of them puts the same question,
"are D and E dead here?", to the same backward sweep: the one ADR 0048 moved
onto the rendered text and ADR 0047 taught to follow branches. ADR 0078 measured
the cost: `[z80n-add-a]` reaches 5 of its 20 census sites and **15 are declined on a
DE that is not live in fact**, the clearest being `divbench`'s `udiv`, which
ends `add hl,de; pop af; ret` in an `int`-returning function.

The precedent is in the same file. `[bc-call]` retired the same shape of
over-claim for BC by asking, of the rendered line, whether it calls a compiled C
function (`xline_c_call`). DE needs the same treatment but cannot use the same
method, and that difference is the whole design.

## Decision

### `[de-ret]` — the return is a per-FUNCTION question

Whether a `ret` hands back DE is a property of the function being lowered, not
of the line. So it is latched at the top of `ir_lower_func`
(`xf_ret_de_static`) and read by the rendered-text passes that run inside that
same call. The answer stays the old conservative YES for:

* a **3-or-more-byte return** — 4 bytes is DE:HL, and anything else wide is
  either the memory accumulator or unmodelled, so it is refused rather than
  reasoned about;
* a **`__sdcccall(1)`** function, whose **2-byte** return is in DE;
* **`__interrupt` / `__naked`**, whose `ret` is not a C return at all;
* a function containing a raw **`__asm{}`** block, which may carry a `ret` of
  its own convention;
* a function containing the indirect-fastcall **`ret` DISPATCH**, where the
  `ret` is a JUMP to the callee with the argument sitting in DE. That one
  cannot be derived from the `Func`, so the **emitter** raises it
  (`xf_ret_dispatch`) at the one site that renders it.

### `[de-call]` — the call is a per-TARGET question the TEXT cannot answer

Whether a call takes an argument in DE depends on the **callee's** declared
convention, and `call _foo` says nothing about it. `xline_c_call`'s trick does
not transfer: a single-underscore C symbol may perfectly well be
`__z88dk_fastcall` with a `long` parameter.

So the **emitter answers**, and the text pass reads the answer back by symbol.
The polarity is **prove-clean**, as in `[gwiden]`: a symbol is DE-clean only if
every direct call to it emitted in this function placed nothing in DE. Dirty,
and therefore unchanged from before:

* a **`__sdcccall(1)`** target (2nd argument in DE; a 4-byte sole argument in
  HLDE);
* a **fastcall argument of exactly 4 bytes** (DE:HL). One of 1-2 bytes rides
  HL, one wider than 4 rides the memory accumulator — both clean;
* **`__preserves_regs(d,e)`**. This is the third way a call makes DE matter and
  it is not an argument at all: the pair *survives* the call, so a value in DE
  may be read **after** one, and the sweep must not call it dead **before** one.

A target the emitter never recorded, an operand that does not fit the table, or
a full table, all answer "reads DE" — the pre-change behaviour.

## Consequences

Figures are in `test/suites/BENCH_MATRIX.txt` (17/9/2026), per this
directory's rule. The shape of the result, which is what endures:

* **smaller everywhere it moves, and never larger.** Bytes and cycles move
  **together**, because the rungs delete instructions — there is no
  byte-for-cycle trade to weigh.
* **no leak.** Only the two CPUs whose rungs consume DE liveness change at all
  — 8085 and z80n. Every other CPU is byte-identical over the whole corpus,
  both frame modes.
* **gate-off is byte-identical** to the pre-change compiler, corpus-wide.
* the win is almost all `[de-park]` and the two 8085 address rungs;
  `[z80n-add-a]` gets the `udiv` site ADR 0078 named, and little else.
* `IR_DEPARK_SWEEP=1` had to be taught the same two facts. Its forward walk is
  an INDEPENDENT check of the backward sweep, so leaving it on the old ABI
  reading would have made it report every legitimate win as a violation — and
  a verifier that cries wolf is worse than none. With both taught, it agrees
  on every park in the 8085 corpus.

## What the regression test pins, and what it cannot

`test/suites/long_ir/delive.c`, seven targets including `_8085_keep` (both
gates off) and z80/z80n/8080 controls. The **win** direction is a size result;
what a behavioural test can pin is the **conservative** direction, so every
function there exists because a value in DE has to survive.

Mutation-tested, and the split is on the record:

* **caught** — declaring a `ret` DE-dead unconditionally. `lsum`/`lmix` return
  a `long`, and on 8085 the mutant returns a wrong high word
  (`delive_8085` fails at the first `lsum` assertion). The gate also moves this
  file for real — `delive_8085` and `delive_8085_keep` differ in ticks, so the
  keep build is a differential and not just a second copy of the same binary.
* **NOT caught, and not catchable in this tree** — declaring a call DE-clean
  unconditionally. With the fastcall-4 and `__sdcccall(1)` arms both mutated
  away, `long_ir` passes **428/428**, and the mutant's asm is **byte-identical
  to the correct compiler across all 5280 files**. No site anywhere in the tree
  has a DE-liveness question standing in front of a DE-passing call. The guard
  is therefore **inert in practice and kept on the ABI argument alone** — which
  is the honest reading of ADR 0078's and `depark.c`'s own bookkeeping, not a
  reason to drop it. `__preserves_regs(d,e)` is the same: no C definition in
  this tree honours it, so that arm rests on the emitter's flag, not a test.

## Note for whoever reads `[bc-call]` next

`[bc-call]` kills BC at a `call _sym` on the argument ABI alone. It does **not**
ask about `__preserves_regs(b,c)`, which is the same hazard this ADR had to
handle for DE: a callee that preserves the pair makes it live **across** the
call. That is a latent question, not a known bug — no in-tree callee honours
the modifier — but it is the one asymmetry left between the two rules.
