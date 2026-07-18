# ADR 0004 — Soundness: `op_clobbers`, `IR_VERIFY`, revert-to-slot, and gating

Status: Accepted

## Context

Residency is where back-end bugs breed: if the allocator believes a value stays
in register R across some op, but the op's lowering actually clobbers R, the
value is silently corrupted. 80cc accumulated a history of exactly this
("residency whack-a-mole"). The design answer is a small set of invariants that
make a wrong residency decision cost *a spill or a loud abort, never a wrong
answer*.

## Decision

### `op_clobbers(f, op) → RegMask` — the verified effect model

A single function (`ir_lower.c`) classifies which value-registers an op's
lowering may write. Opaque ops (`CALL`, `ASM`, memset/memcpy, wide helpers)
return `IR_R_ALL`; `HCALL` consults the helper table (ADR 0005); the default is
HL + A + DE (staging) + flags + the result/operand homes, plus BC for wide
(DEHL) ops. A value in register R survives op O **iff R ∉ op_clobbers(O)**. This
is the one predicate every residency decision rests on.

`op_clobbers_relaxed` is the same model under the hypothesis that ADD/SUB/CMP
stage their second operand through BC instead of DE (the `hl,bc` forms) — used to
reason about whether DE could be freed.

### `IR_VERIFY` — cross-check the model against reality

With `IR_VERIFY` set, each op's *emitted assembly* is parsed and the registers it
actually writes are asserted to be a subset of `op_clobbers`. A `push R … pop R`
pair is recognised as preserving R. This catches model/emitter drift — the
classic source of residency miscompiles — across the whole corpus, before it
becomes a wrong answer. (It cannot see inside a called helper; that is the
helper table's job, ADR 0005.)

### Revert-to-slot + `require_slot` — fail safe, not wrong

- A residency decision that cannot be realised **falls back to a frame slot**
  rather than being forced. A bad decision costs a spill.
- If the lowerer is ever asked to read a value that is in no live register and
  has no slot, `require_slot` **aborts loudly** with a `file:line:` message,
  rather than emitting a below-frame read. A loud abort is a bug report; a wrong
  answer is a silent field failure.
- Any not-yet-implemented residency path fails the same way (a marked op with no
  emitter support aborts, it does not fall through to a clobbering path).

### Byte-identical-off gating

Every residency feature is behind a gate (`IR_NO_*` to opt a default-on feature
out; `IR_LRA` to opt an in-progress one in). The invariant: **with the feature
off, codegen is byte-identical** to before it existed, verified by an asm diff
across the CPU matrix (normalising only the compile-timestamp / temp-filename
header noise). A new feature is landed *inert* first, proven byte-identical, then
turned on. This makes every change bisectable and makes "does this feature cause
regression X" answerable by flipping one env var.

## Consequences

- The soundness argument for a register surviving an op is the **same predicate**
  (`op_clobbers`-clean over the span) whether the home is whole-region or a short
  live range — one invariant, applied at different granularities.
- New allocation work follows a fixed discipline: model it in `op_clobbers`,
  land it gated + inert + byte-identical, validate with `IR_VERIFY` and the
  correctness suites (ADR references the `test/suites` matrix), then measure.
- Because a bad decision degrades to a slot or a loud abort, the allocator can be
  *aggressive* without being *dangerous* — the cost of an over-reach is
  performance, not correctness.
