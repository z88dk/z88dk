# ADR 0016 — Two-pass lowering: cross-BB register carry and lazy spill

Status: Accepted

## Context

The register model (ADR 0002) and residency policy (ADR 0003) decide *which*
value lives in HL / DE / BC / a byte-home. Realising that across control flow is
the lowerer's job, and a naïve per-BB, store-eagerly lowering leaves two large
inefficiencies — both expensive on the CPUs where slot access is dear (ADR 0012):

1. A value produced and immediately consumed still round-trips through its frame
   slot (store, then reload).
2. A value already sitting in a register at a predecessor's exit is reloaded
   again at the successor's entry.

The lowerer keeps a **register cache** (which vreg is currently in HL/DE/BC/A and
the byte/word-home belief) so within a block these are avoided. The hard part is
making the cache correct — and the deferral decisions sound — *across* basic
blocks.

## Decision

Three cooperating mechanisms, all in `ir_lower`:

- **Cross-BB register carry.** Record per BB which vreg each tracked register
  holds at exit: `bb_hl_out` for HL, `bb_byte_out` (+ a dirty flag) for the
  slot-backed byte-home (E/D) and the word DE-home. At a BB's entry, if **every
  already-lowered predecessor agrees** on the same tenant **and** that vreg is
  **live-in**, keep the cache (no reload); otherwise invalidate. Trampoline
  aliases (ADR 0013) pass the carry straight through. The agreement + live-in
  test is what makes the carry sound at merges and back-edges.

- **Lazy spill (store-on-clobber) with deferral.** A width-2 result can ride in
  HL with its slot store *deferred*: `pending_spill_v` names it, under the
  invariant *pending ⇒ HL holds it*. The store is emitted only when HL is about
  to be clobbered (`pending_spill_resolve` from `hl_about_to_change`) or when a
  successor needs a coherent slot. Spill stores whose slot is never subsequently
  read are dropped entirely (`ss_compute_dead`, a backward slot-liveness pass).
  Combined with the carry above, a value can ride HL across a BB boundary and
  never touch its slot.

- **Two passes make the forward-looking deferral sound.** Whether HL may carry a
  pending value *into* a successor depends on what every block leaves in HL —
  known only after a full render. So pass 1 renders to a **scratch sink**
  (text discarded) with deferral **off**, purely to compute the complete
  `bb_hl_out` tenant map and record the spill store/reload sites; pass 2 renders
  for real with deferral **on**, its cross-BB defer decisions consulting that
  complete map and skipping the dead stores. `--opt-disable=lazy-spill` collapses this to
  a single deferral-off pass — correct, just without the lazy win — preserving
  the byte-identical-off discipline of ADR 0004.

A companion reload-avoider shares this area: **rematerialisation** — a width-2
vreg with exactly one `LD_IMM`/`LD_SYM` def (a loop-invariant constant) is
re-emitted on a cache miss instead of reloaded from its slot (`--opt-disable=remat`).

## Consequences

- The register cache must stay **honest through every emit and every BB
  boundary**; its invariants (pending ⇒ HL holds it; carry only when all lowered
  preds agree and the vreg is live-in; inherited dirtiness for a slot-backed
  home) are load-bearing — a stale belief miscompiles, not just deoptimises.
  Historically this is where the subtle residency bugs lived, so new lowering
  paths must maintain the cache and the carry maps, not just emit instructions.
- This mechanism is what lets ADR 0003's residency *policy* actually pay off
  across control flow: residency picks the home, this render carries it and
  elides the spills.
- The two-pass path costs one extra (discarded) render; it is gated for
  bisection.
- **Boundary:** only HL and the byte/word-home currently carry across BBs — the
  DE / DEHL caches are reset at every BB entry (no `bb_de_out`). That limit is
  why keeping a *long* resident across a loop needs new carry infrastructure (see
  the LONG_DEBC residency work); recording it here so the gap is deliberate, not
  forgotten.

See ADR 0002 (register model), ADR 0003 (residency policy), ADR 0004 (soundness /
gating), ADR 0012 (why slot access cost drives this), ADR 0013 (trampoline
aliases the carry threads through).
