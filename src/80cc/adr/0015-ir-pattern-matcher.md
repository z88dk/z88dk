# ADR 0015 — The IR pattern-matcher engine

Status: Accepted

## Context

Many back-end rewrites are *structural fusions* on the IR: fold a constant or a
symbol+offset into a load/store, recognise `*p++`, fuse a byte deref with the
compare that consumes it, fuse a mask with the store it feeds, recognise a
rotate, pack adjacent byte stores, and so on. These are CPU-aware instruction
selection, so they belong at the IR level (above copt's text peepholes, ADR
0013; distinct from the AST/IR *optimisation* split of ADR 0010).

Historically each fusion was a hand-rolled `ir_opt_*` pass that re-implemented the
same machinery: scan the block, bind the operands, test the safety side
conditions, splice the rewrite, and NOP-out / compact the consumed ops. The
recurring lesson (BUG_LOG A33–A40) was blunt: **the bugs were never in the match
— they were in the side conditions** (single-use, width, aliasing, addr-taken,
volatile), re-derived slightly differently in each pass.

## Decision

A single **declarative pattern-matcher engine** (`ir_match.c`) owns all the
mechanical parts — the scan, operand binding, the *standard* side conditions, the
rewrite plumbing, and the NOP/compact step. A rewrite is expressed as a
`PatternDef` in a production table that contributes only:

- **input templates** — the op shapes to match (with commutative-swap tried for
  binops so `a op b` and `b op a` share one entry);
- an optional **`check()` / `apply()` escape hatch** — for non-standard side
  conditions or non-generic rewrites; the generic path handles the common case;
- an **`exclude_cpus` mask** — CPU applicability tested against `f->cpu`
  (stamped by ir_build), never a direct `c_cpu` read, so the engine and its
  patterns stay CPU-portable (ADR 0006).

The engine reads only the IR (`ir.c` / `ir_analysis.c`). It runs to a bounded
fixpoint in phases at the ir_opt → lowering boundary: `early` (e.g. `*p++`),
the main `run`, `packbytes`, and `late` — ordered so earlier folds (field
offsets into loads) are visible to later ones.

## Consequences

- **Adding a fusion is adding a `PatternDef`, not a pass.** The scan/bind/rewrite/
  compaction are written once; a new rewrite supplies templates plus, if needed,
  its own `check()/apply()`. Standard side conditions (single-use via
  function-wide use counts, width, `NO_AUTO_TEMPS`, and **volatile via
  `mem.volatile_`**, ADR 0014) are shared and fixed in one place.
- **The side conditions are the bug surface** — the design deliberately
  concentrates them so each is written and fixed exactly once, per the BUG_LOG
  lesson.
- `--opt-disable=pattern:<name>` disables an individual pattern, for bisection and
  for the byte-identical-off discipline (ADR 0004).
- Layer boundaries: this is **IR-level, structural, CPU-aware** selection/fusion;
  copt (ADR 0013) is the **text-level** final peephole; the AST/IR *optimisation*
  passes (ADR 0010) are separate again. A rewrite that needs the concrete
  instruction stream or CFG layout belongs in copt / the post-render filter, not
  here; one that needs IR types or use-counts belongs here.

See ADR 0006 (CPU portability / `f->cpu`), ADR 0010 (AST vs IR optimisation),
ADR 0013 (text peepholes), ADR 0014 (volatile side condition), ADR 0004
(soundness / gating).
