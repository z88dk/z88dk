# ADR 0110 — BC saves cover the call they guard; f32 helper operands skip the BC stash

Status: **Accepted** (2026-10). Opt-outs: `bc-save-group`,
`f32-prepush-nostash`, `hcall-arg-nostash`.

## Context

- The BC save at a pre-pushed call's first argument was kept live for the rest
  of the block, so it was restored after calls that never touched BC.
- Every 4-byte value that went to an `l_f32_*` helper was first copied
  `ld bc,hl` so that BC held the low half (the DEHL cache invariant), then
  pushed from BC. The copy is dead when the only reader is the helper that pops
  the image, and also dead when the result is read only as the helper's
  register operand.

## Decision

- `bc-save-group`: the window of the save ends at the matching call
  (`bc_tenant_live_to_call`).
- `f32-prepush-nostash`: push `de; hl` directly for a value whose only reader
  is the helper that pops it.
- `hcall-arg-nostash`: a 4-byte result read only as the register operand of the
  immediately following HCALL skips the `ld bc,hl`.

## Evidence

`bc-save-group` -104 B over the corpus. `startrek --math32`: sp 16040 ->
15672 B, fp 16857 -> 16529 B; `fixedbench` -32 B over 8 cells; default
`double` builds unchanged (math48 never had the copies). Tests: `bcsavegrp.c`,
`prepush.c`, `f32wide.c`.

## Tried and refused

Tightening the BC save to per-op live-in sets instead of the call window:
miscompiles `enigma` in fp mode. The block-level window is what the register
allocator's belief cache can prove.
