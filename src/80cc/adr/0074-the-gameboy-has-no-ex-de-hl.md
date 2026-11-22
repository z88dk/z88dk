# ADR 0074 — The in-place rewrite is excluded on gbz80

Status: **Accepted**. A plain exclusion, not a cost gate.

## Reason

The in-place form this transform builds is only worth building where the DE home
can step it in `add hl,de; ex de,hl`. **The gameboy has no `ex de,hl`**, so each
step becomes `add hl,de` plus two byte moves, and the rewrite creates a shape it
cannot pay for.

## Evidence

Measured over 16 gbz80 benches: the transform fires on **two**, and **both are
better without it** — `lexbench` −27 B / −1.74 %, `divbench` −21 B / −1.58 % —
with the other fourteen byte-identical.

Nothing else on the CPU regresses, which is why this is a plain exclusion rather
than a cost gate. A gate would add a term to buy back two benches that a single
`IS_GBZ80()` already settles.
