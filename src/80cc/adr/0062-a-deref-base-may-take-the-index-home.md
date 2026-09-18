# ADR 0062 — A deref base may take the index home

Status: **Accepted**, default on. `IR_IDX2BASE=0` opts out.

## Context

A deref base was rejected outright at this gate, so a struct pointer could never
reach the index home however well it scored — while a scalar parameter read back
through `push iy; pop hl` could.

## Why admitting it wins, which is NOT the obvious reason

At the time this landed, 80cc's index home was a **value carrier, not an
addressing mode**: `emit_idx_word_to_reg` read it with `push iy; pop hl`, and
the corpus contained **zero** `(iy+d)` accesses against sdcc's 47. So the
pointer does **not** gain a cheaper deref by moving to IY.

What it gains is **eviction**. The scalar that held IY was paying 4 bytes
(`push iy; pop hl; ld a,l`) at every read, where reading it in place from its
parameter slot costs 3 (`ld a,(ix+4)`). Measured **−13 B on bitfieldbench**, and
the pointer's own accesses are unchanged.

This is worth reading carefully before extending the gate: the win is the
*displaced* value getting cheaper, not the admitted one.

## What this is not

The real xcc-parity win — a pointer dereferenced **as** `(iy+d)` — needed a
lowering 80cc did not have. That arrived later as the `idx-deref` rung, which is
what made the index home an addressing mode at last.

Admit only the shape that measured positive and leave the rest rejected; the
assignment site's grounded `idx_ben` gate then prices it as usual.
