# ADR 0087 — The eZ80 prologue uses the full IX frame offset

Status: **Accepted**, default on. `--opt-disable=lea-frame-prologue` restores the old prologue.

## Context

ADR 0081 changed body addresses in framed eZ80 functions to `lea hl,ix+d`. It left frame allocation unchanged.

The prologue sets IX before it allocates the frame. A fastcall parameter can push two or four bytes after that setup. The old allocation then uses `ld hl,-alloc_size; add hl,sp; ld sp,hl`. Here, `alloc_size` excludes the pushed bytes.

After the push, SP is `IX - autopush_bytes`. The final frame base is `IX - frame_size`, where `frame_size = autopush_bytes + alloc_size`. Therefore, the IX displacement is `-frame_size`, not `-alloc_size`.

## Decision

In a framed eZ80 function, use `lea hl,<frame_reg>-frame_size; ld sp,hl` when the negative frame size fits a signed byte. Keep the old SP form for larger frames, frameless functions, and other CPUs. The existing small-frame and direct `add sp,d` paths remain ahead of this choice.

This rule has its own opt-out, `lea-frame-prologue`. The `lea-frame-addr` opt-out from ADR 0081 controls body addresses and does not control frame allocation.

## Evidence

The [dated measurement](../../../test/suites/80cc-ez80-prologue-2026-09-17.md) records the final assembly, corpus size and tick scans, and the gate-off comparison.

`test/suites/long_ir/leapro.c` checks a plain frame, the signed-byte boundary, a frame beyond that boundary, and a 4-byte auto-pushed fastcall parameter. The gate-off variant checks the old path. Z80 and 8080 variants check that other CPUs keep their existing prologues.
