# ADR 0036 — Charging a parameter eviction for framelessness

Status: **Rejected** (2026-09-14). Built, measured, and withdrawn.

Follows ADR 0035 (claims are priced in isolation) and ADR 0027 (truthful home
intervals), whose regression prompted it.

## The idea

When the BC packer evicts a parameter, the displaced benefit is priced as an
ordinary frame-slot read. But a parameter's slot is the **caller's** frame:
`ld hl,(ix+d)` when framed, and a five-instruction sp walk when frameless. And
`frameless_ok` requires every parameter homed in BC, so the eviction can cost
the function its frameless form entirely.

The parameter half of `frameless_ok` is a pure function of the allocation, so
the allocator can evaluate it locally. The charge: when every parameter is
BC-homed, add the dearer reads and the frame apparatus to the eviction's cost.

## Why it was withdrawn

It measured as a pure win — **−229 bytes, no cell larger**, 660 tick cells with
none slower — and that measurement was **wrong**.

The charge had no frame-mode guard, so it fired in **sp mode**, where
`frameless_ok` returns 0 immediately with the comment *"sp-mode is already
frameless"*. There is no frame apparatus to lose there and nothing to buy. The
entire −229 bytes came from charging for a saving that does not exist — it
biased the allocator towards keeping parameters in BC, which happens to help in
sp mode, but for a reason unrelated to the term's justification.

`long_ir/leaimm` caught it: **+17 bytes in sp**, a file outside the 720-cell
corpus matrix. With the correct guard added, `leaimm` returns to parity — and
the term becomes **completely inert**: 0 cells changed across the corpus, in
either configuration, with or without narrowed intervals.

So the honest result is that the term, correctly scoped, buys nothing
measurable.

## The second error, which matters more

The evidence for the idea was that `frameless` flipped 1 to 0 across the
eviction on `md5/MD5Init`. That reading was wrong.

`MD5Init` is an **sp-flip candidate**: the lowerer clones it, sets
`c_framepointer_is_ix = -1`, lowers the clone, and restores the flag — correctly
scoped, save and restore both present. The renders showing `frameless = 0` and
`-1` were the **clone's**, not the function's. `MD5Init`'s emitted code is the
sp-flipped clone, which is why it addresses through `add hl,sp`.

So the +29 bytes under narrowed intervals is not a framelessness loss at all.
It is the sp clone allocating worse — a different question, still open.

## What to keep from this

1. **A corpus matrix is not the whole test set.** 720 cells said "no cell
   larger"; a `long_ir` file was 17 bytes worse. Size claims should name the
   set they cover, and `long_ir` belongs in it.
2. **Check the frame mode before charging for frame-related costs.** sp mode has
   no frame pointer; `frameless_ok` says so in its second line.
3. **A per-function frame trial makes global state observable.** The sp-flip
   clone is allocated with the flag flipped, which is correct, but it means any
   reasoning about "what mode is this function in" during allocation must
   distinguish the real function from a trial clone. This is the concrete case
   the `BackendRenderOptions` extraction is meant to remove.
4. ADR 0035 stands unchanged: the opportunity-cost term exists in `bc-evict`,
   both its denominations agree, and both still under-price something. This
   attempt did not find what.
