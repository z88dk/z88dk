# ADR 0020 — Narrowing a byte-wide pushed argument

Status: Rejected (2026-08-10)

Relates to ADR 0007 (kind/width model).

## Context

The width-narrowing pass demotes a word value to a byte when every use fits in
one. Its largest remaining population by far is `IR_PUSH_ARG`: a `char` argument
computed as a word, widened with `ld h,0`, and pushed as a word. The callee, if
prototyped `char`, reads only the low byte, so the widening looks dead.

## Decision

Do not narrow the producer of a pushed argument. Measured, it costs
**+1789 bytes** on the corpus.

The saving is illusory because the argument must still occupy a word-sized stack
slot to satisfy the calling convention. Narrowing the producer does not remove
the push; it only moves the widening to the use, where it is paid more often and
in a worse form.

This also settles the related "dead char-arg widening" observation from the
other direction. The 64 sites of `ld h,0` before `push hl` are worth about 128
bytes, and that is the ceiling. Reaching it needs a change to the `__smallc`
convention — whether a `char` argument is guaranteed to arrive widened — not a
compiler-side transformation. `libsrc` is full of hand-written assembly callees
that read the low byte only, so the convention cannot be assumed.

Note that the `ld h,0` before a **fastcall** argument is a different thing and
must stay: it is a deliberate fix for a real miscompile.

## Reopening

Only if the `__smallc` argument convention is changed deliberately, with the
hand-written `libsrc` callees audited. A compiler-side workaround does not
exist; this is an ABI question.
