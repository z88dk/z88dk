# ADR 0103 — An 8085 word reload into BC uses LHLX

Status: **Accepted**, default on. `--opt-disable=lhlx-bc` opts out.

## Context

`emit_bc_reload` fills BC from a stack slot with the z80 byte walk. On the
8085 the post-pass then rewrites the address, and the first consumer often
copies BC straight back to HL. The rendered text is:

```
ld hl,N
add hl,sp
ld c,(hl)
inc hl
ld b,(hl)
ld hl,bc
```

`ld hl,(de)` (LHLX) already yields that word. The same bytes in BC are
the pair copy `ld bc,hl`.

## Decision

In the rendered-text backward pass, before `[ldsi-addr]`, replace that six
line run with:

```
ld de,sp+N
ld hl,(de)
ld bc,hl
```

when all of these hold:

* D and E are dead after the copy. The walk does not write DE. The rewrite
  leaves the slot address there.
* F is dead after the copy. `add hl,sp` writes carry. LDSI and LHLX do not.
* N is in 0..255, LDSI's unsigned operand.

HL and BC hold the same word afterwards. The copy is deleted because it
would reload the word LHLX just produced.

## What this is not

ADR 0038 refused correcting the 8085 rows in `g0_word_cost` /
`g0_word_bytes`. Those rows stay. ADR 0039 shipped LDSI for a dead-DE
address and left the live-DE form (`ex de,hl; ld de,sp+N; ex de,hl`, 18
cycles, same 4 bytes) alone on purpose. This rung does not retarget that
form. It only deletes the byte walk in front of `ld hl,bc`, and only when
DE is already dead.

## Gate

`lhlx-bc`, default on. `test/suites/long_ir/lhlxbc.c` runs on z80 (both
frame modes), 8085 (both frame modes), 8085 with the gate off, and 8080.
