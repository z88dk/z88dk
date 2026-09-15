# ADR 0050 — Stack-transient spill is an sp-mode trade

Status: **Accepted**, default on. `IR_NO_STACK_SPILL` opts out.

## Context

Below BC-pack there is a register-pressure fallback: a single-def/single-use word
transient with no register free has to go somewhere.

## Decision

Put it on the stack (push/pop) rather than in a slot — **in sp mode only**.

That restriction is a **cost decision, not a safety one**. A park trades a slot
access for a push/pop. In fp mode the slot is `(ix+d)`, cheap enough to invert
the trade: switchbench measures sp −40 B / −2.07 % ticks against fp −15 B but
**+0.72 % ticks**.

## The CPU test, and why it is not a frame-mode test

8080, 8085 and gbz80 have no index register, so `-fframe-pointer` is a no-op
there and they want the sp answer in **both** modes. Hence the gate is a CPU test
rather than a bare `c_framepointer_is_ix` one.

Note this is the *opposite* situation to ADR 0040, where a CPU test was standing
in for a property and should have been asking about the property. Here the CPU
genuinely is the question, because "has an index register" is what decides
whether fp mode means anything at all. Both are worth reading together before
adding or removing a CPU name from a gate.

## Consequences

`IR_PARK_VERIFY` checks the park's TOS invariant against the emitted text. Run it
before widening `stack_spill_span_hazard`.
