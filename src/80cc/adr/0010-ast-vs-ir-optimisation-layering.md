# ADR 0010 — AST-level and IR-level optimisation: a deliberate two-level split

Status: Accepted

## Context

Optimisation runs at two levels, which can *look* like duplication:

- **AST level** (`ast_opt.c`, via `ast_opt_run` during parsing in `declparse.c`):
  constant folding (`ast_fold_constants`), algebraic simplification
  (`ast_simplify_algebraic`: `x+0→x`, `x*1→x`, `x-x→0`), scalar strength
  reduction (`try_strength_reduce`: `x*const` → shifts/adds), and
  canonicalisation (commuting commutative operands; folding `x = x OP y` into
  `OP_A*` compound-assign nodes).
- **IR level** (`ir_opt.c`, on the lowered IR): CSE, LICM (`ir_opt_licm`), and
  induction-variable strength reduction (`ir_opt_ivsr`, ADR 0008).

Both "fold" and both have a "strength reduction," so the question is why the
split is the right design.

## Decision

Keep both levels — they are **complementary and each earns its place**; this is
a deliberate layering, not redundancy to remove.

1. **AST opts are a first-class, beneficial source-level pass.** They:
   - work with full C **type semantics** (integer promotion, signed/unsigned
     fold width, decimal/fixed-point literal folding) that are clearest on the
     typed AST and awkward to reconstruct later;
   - **shrink the IR before it is built**, so every downstream pass (analysis,
     allocation, lowering) has less to chew on;
   - **canonicalise** the tree into the shapes `ir_build` is written to consume —
     `OP_A*` compound-assign nodes and commuted operands. `ir_build` depends on
     this normalisation, so ast_opt is load-bearing, not optional.
2. **IR opts do what only the lowered form allows.** CSE across synthesised
   address arithmetic, loop-invariant motion, and induction-variable SR need the
   three-address IR + liveness + loop structure that do not exist at the AST.
3. **The apparent overlap is not the same work twice.** The two "strength
   reductions" are different transforms (scalar `x*const` at AST vs loop
   walking-pointer IVSR at IR). Constant folding legitimately happens at both
   because constants arise at both levels — source literals (AST) and the address
   arithmetic that lowering synthesises (IR).

(The classic *AST-direct code generator* was retired in favour of the IR pipeline
— see the header of `ast_codegen2.c` — but that was the codegen *walker*, not the
AST *optimiser*. `ast_opt` is independent of it and remains in active use.)

## Consequences

- **Put a new optimisation where its information lives:** type-aware folding,
  algebraic identities, and source-level canonicalisation → AST; anything needing
  liveness, live ranges, the lowered op stream, or machine addressing → IR.
- Both levels stay; there is no goal to collapse them. If a *specific* transform
  is ever found to belong at the other level, move that one transform (updating
  `ir_build`'s assumptions if it was an AST canonicaliser), verified byte-
  identical (ADR 0004) — but the two-level structure itself is the intended
  design.
