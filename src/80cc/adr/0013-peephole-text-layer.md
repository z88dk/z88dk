# ADR 0013 — The peephole / assembly-text optimisation layer

Status: Accepted

## Context

ADR 0010 describes two optimisation levels — AST and IR. There is a third,
below them: **peephole optimisation on the emitted assembly text**. Some rewrites
are only expressible (or only safe) once instruction selection, register
allocation, and layout are final — they depend on the *concrete* instruction
stream, not the IR. Two facilities live here.

## Decision

### 1. copt — the external text peephole

z88dk ships `z88dk-copt`, a pattern-matching optimiser that rewrites runs of
assembly lines by rule files. Two properties matter for the back end:

- **80cc uses only `lib/80cc_rules.1`.** The much larger `z80rules.*` rule set is
  sccz80's; it is *not* applied to 80cc output (see zcc's compiler dispatch).
  sccz80 rules assume sccz80's label naming (`i_N`) and code shapes, so porting
  one means re-authoring it for 80cc, not referencing it. This is a recurring
  trap: a rule "already exists" in z80rules but does nothing for 80cc.
- **copt matches whole lines.** A rule pattern must match a line in full, so a
  line carrying a trailing comment does not match a comment-free pattern. This is
  exploited deliberately: the `;volatile` stamp (ADR 0014) makes volatile
  accesses invisible to every peephole. Rule-file comments use `;;`.

Store-then-reload elision and reload-across-conditional-jump elision live here as
80cc_rules.1 rules; their volatile safety rests entirely on the stamp.

### 2. The post-render text filter (in the compiler)

`ir_lower` renders each function to a scratch buffer and then copies it to the
output through a filter (`emit_dropping_dead_bb_labels`) that applies three
transforms *before* copt sees the text:

- **Dead BB-label elision** — drop `L_fN_bb_M:` labels that no jump / `defc` /
  switch-table operand names. Correct by construction (a label with zero textual
  references is unreachable by name).
- **Alias-`defc` relocation** — move the zero-byte `defc L_fN_bb_x = …` trampoline
  aliases to the end of the function.
- **Jump threading** — a jump whose target BB only does `jp Y` is retargeted
  straight to `Y`.

These are done as **text**, not IR, because the property they exploit —
*instruction adjacency* — is an emission-time artifact. A BB may be empty (or a
pure `jp`) only *after* lowering has elided its ops (e.g. a fused shift leaves a
diamond arm emitting nothing; a `CONV` narrows to a no-op). The IR still shows
those ops, so the IR can't see the adjacency. Running the filter before copt
removes the dead labels and inline `defc`s that would otherwise split
otherwise-consecutive instructions, letting copt's line-adjacent patterns fire.

### The load-bearing soundness invariant: threading is operand-rewrite, not aliasing

Jump threading **rewrites the jump operand** (`jp cc,X → jp cc,Y`) and leaves
`X`'s `jp Y` body in place. It must **never** thread by aliasing `X` to `Y`
(`defc X = Y`, dropping the body), even though that is how sccz80's z80rules
threading works.

The reason is structural and specific to 80cc: **its diamond joins are reached by
fall-through.** A ternary/if arm falls through into the join block `X`, which then
does `jp Y` (e.g. a loop back-edge). Aliasing `X` deletes that `jp Y`, so the
fall-through path runs off the end of the arm into whatever block follows — a
miscompile. sccz80's trampolines are jump-only (no fall-through predecessor), so
`defc` aliasing is safe *there* but not here. Operand rewrite keeps the body, so
it is sound whether or not `X` is reached by fall-through; the now-unreferenced
label then drops via the elision above.

## Consequences

- Peephole rewrites that need CFG/aliasing knowledge belong in the compiler-side
  text filter (which knows the layout); purely local instruction rewrites belong
  in `80cc_rules.1`. Do not reach for `z80rules.*`.
- Anything added to the filter or to copt must preserve the `;volatile` stamp
  (ADR 0014) and must not assume sccz80-style jump-only trampolines — 80cc joins
  fall through.
- The filter is gated (`IR_NO_LABEL_ELIDE` opts out to a verbatim copy), keeping
  the byte-identical-off discipline of ADR 0004 available for bisection.
- copt cannot express whole-CFG analysis (dead-label removal, general threading),
  which is precisely why those live in the compiler filter rather than as rules.

See ADR 0010 (AST/IR optimisation levels), ADR 0014 (volatile / the stamp), and
ADR 0004 (soundness and gating).
