# ADR 0093 — Indexed word RMW drops the BC address park

Status: **Accepted** (2026-09-18). Opt out with `idx-rmw-de`. Supersedes the
"do not change the emitter" call in ADR 0088.

## Context

ADR 0088 sized the indexed word read-modify-write shape — `bins[idx]++` and
its like — and found one site (`histbench`), 8 sp/fp cells, 5 bytes each, and
declined to change the emitter from that census alone: too small on its own,
kept as a baseline "if a later lowerer change makes the DE reader available to
more indexed word RMWs."

No such later change arrived. This is the same site, shipped anyway, as a
narrow textual rewrite rather than a lowering change — see "How" below for why
that distinction matters.

## The shape

The word load walks the value through HL itself (the A→HL reader: `ld a,(hl+);
ld h,(hl); ld l,a`), which stray the address, so the emitter parks it in BC
first and rebuilds HL from BC to store back:

    ld bc,hl        ; park address
    ld a,(hl+)      ; value load walks HL itself...
    ld h,(hl)       ;   ...stranding the address
    ld l,a
    inc hl
    ex de,hl
    ld hl,bc        ; rebuild address from BC
    ld (hl),e
    inc hl
    ld (hl),d

HL never leaves the address's value if the load goes through E/D instead of
A/H/L, and then `dec hl` recovers the address directly — no BC needed at all:

    ld e,(hl)
    inc hl
    ld d,(hl)
    dec hl
    inc de
    ld (hl),e
    inc hl
    ld (hl),d

14 bytes down to 8 (measured; ADR 0088's estimate — 5 bytes/site — was
slightly conservative, likely from static census rather than a live A/B).

## How

An exact 10-line match in `ir_lower.c`'s existing backward-liveness pass (the
same pass `inc-mem`, `de-widen` and `z80n-add-a` are written against), gated
on B, C, D and E all dead after — `ld bc,hl` clobbered BC to the address
either way, so the ORIGINAL code already broke any later BC read; DE held the
incremented value post-store in the old form and holds whatever it held
before the sequence in the new one, so a consumer expecting the former needs
the dead check. No flag condition: both forms are register loads, INC/DEC on
HL, and byte stores, and none of them reads F.

This is a **pattern match on final assembly text**, not a change to how the
word RMW is lowered — same distinction ADR 0088 drew, same reason it stayed
small: the site count is real but the surrounding lowering is unchanged.

## The z80n gate difference

The pattern text-matches identically on z80n, but the rung does not fire
there: DE is live after the sequence on z80n and dead on z80, both proven by
the same backward pass at the same site from the same source. This is a real
difference (traced live with a temporary debug probe, not assumed) — some
earlier CPU-conditional rewrite in the same function leaves DE needed across
the loop back-edge on z80n and not on z80. ADR 0088's static census counted
z80n as an affected cell; the live liveness check says otherwise, and the live
check is the one that is allowed to refuse.

## Result

`histbench`/`predbench`, z80/z180/8080 only (z80n, ez80, r2ka, r4k, kc160,
8085, gbz80, vm1 unaffected — z80n per the DE-liveness difference above, the
rest do not reach this A→HL reader shape at all). See `BENCH_MATRIX.txt` for
the dated section and both frame modes. `long_ir` 842/842 in both frame
modes (the one pre-existing `longshl_vm1` gap unchanged); `check_options.sh`
and `check_gates.sh` both pass.
