# ADR 0113 — Run copt's rule engine inside 80cc with a liveness precondition

Status: *Proposed* (2026-10). Nothing is built. Prototype first; decide on its
numbers (see Acceptance).

## Context

ADR 0013 describes two peephole layers: the external `z88dk-copt` over
`lib/80cc_rules.1`, and a set of hand-written text sweeps inside `ir_lower.c`
that run on the rendered function before copt. The sweeps exist because many
rewrites need to know a register is dead after the match, and copt has no
liveness. Each such rung is a C function: compare N lines with `strcmp`, parse
a number with `sscanf`, consult `d_live`/`e_live`/`f_live`, rewrite, mark lines
dropped.

Measured by function size in `ir_lower.c` (upper bounds, nothing converted):

| | lines of C |
|---|---|
| rung-shaped: match a run of lines, check a dead register, rewrite | about 1,320 |
| liveness helpers (`gw_a_dead_after`, `carry_dead_after`, `szph_dead_after`, `de_half_live_walk`, `byte_ret_a_dead`, ...) | about 175 |
| not rule-shaped: branch relaxation, tail merging, dead-label removal, the DE forward walk, `bc-flow`/`de-flow`, line slurping | about 730 |

The rung-shaped code is dominated by `filter_dead_bc_parks` (453 lines, holding
`idx-rmw-de`, `de-widen`, `inc-mem`, `z80n-add-a`), the twelve `fold_*` passes
(about 400) and the gbz80 rewrites (about 200). Master's `lhlx-bc` and
`byte-ret` added about 100 more, both of the same shape.

## What the engine already has

`src/copt/copt.c` (1,124 lines) supplies everything a rung needs except
liveness: regular-expression captures, `%check min <= %n <= max` for number
ranges, `%eval result = expr` and inline `%eval(...)` for arithmetic on
captures (already used in `lib/80cc_rules.1`), `%is`/`%not` for token sets,
`%notSame`, `%cpu`, `%notcompiler`, and rules applied in file order. A number
guard such as `lhlx-bc`'s `0..255` or `byte-ret`'s `1..255` is one `%check`
line; no new numeric predicate is needed.

## Proposal

1. Extract the matcher from `copt.c` so `ir_lower` can call it on its line
   array without the external process.
2. Add a precondition `%dead <reg> [<reg> ...]` (registers and `f`), answered
   from the same backward liveness the sweeps compute now (`d_live`, `e_live`,
   `f_live`, `b_live`, `c_live` and the walkers), not from the rendered text.
3. Convert rungs one at a time into `lib/80cc_rules.1`, keeping each rung's
   opt-out name working through `%notcompiler`-style gating or the existing
   `opt_disabled` check on a rule title.

## Constraints from earlier failures

- **Not as an external post-pass on rendered text.** `gwiden` was tried that
  way and miscompiled because the text carries no liveness.
- **Liveness must come from the lowerer, not be re-derived from the text.** copt
  rule `#ADDR` assumed DE dead where the belief cache reused it, and
  miscompiled Z80.
- **Rule order is behaviour.** Master's comments say `byte-ret` must run before
  `xor-a` and `lhlx-bc` before `ldsi-addr`. In C that order is code order; in a
  rule file it is file order. Converting a rung means writing its ordering
  constraint down and testing it. Other rungs probably have unwritten ones.
- **What stays hand-written regardless:** CFG-dataflow rungs (`bc-flow`,
  `de-flow`), branch relaxation, tail merging and dead-label removal.

## Acceptance

Prototype with four rungs: `byte-ret`, `lhlx-bc`, `idx-rmw-de`, `de-widen`.
The two multi-register ones are what decide it; `idx-rmw-de` needs four dead
registers and a 10-line match.

- Output **byte-identical** over the corpus, the console programs and the
  `long_ir` suite on every CPU, both frame modes. Any difference is a bug in
  the conversion or an unwritten ordering constraint, and is explained before
  anything else lands.
- Lines of C removed, counted and written here, against lines of engine glue
  added.
- Compile time not measurably worse (the sweeps already run per function).

If the four rungs together remove less C than the extraction and `%dead` add,
mark this ADR **Rejected** with those numbers inline, as the README asks.

## Reopen / extend

After the prototype, convert the remaining rung-shaped functions in the order of
lines removed per ordering constraint discovered.
