# ADR 0052 — Fold an offset into a rematerialised `&symbol`

Status: **Accepted**, default on. `--opt-disable=symaddr-deref` opts out.

## Context

`gen_ld_sym` already folds its own offset, so `&g.field` is one `ld hl,_g+K`.
The **deref** of a struct-member address did not: the base materialised bare and
the field offset became a separate add.

```
ld hl,_suite / ld de,206 / add hl,de     7 bytes
ld hl,_suite+206                         3 bytes
```

## Decision

When loading a base for a deref at constant offset, fold the offset into the
symbol where the base is a rematerialisable `&symbol`. Same fold and the same
rematerialisation licence as `gen_ld_sym`: the address is a link-time constant,
so folding a constant into it is free.

## Where it deliberately does not fire

* **Only where the base would otherwise be rematerialised** (`hl_load_takes_remat`).
  A base already sitting in a register is cheaper to copy than to re-emit, and
  folding there trades 2 bytes for 3.
* **`LD_IMM` bases are not folded.** A `NO_SLOT` immediate had its own
  miscompile (see the remat marking in `ir_lower.c`), and the address-of case is
  where the offsets are anyway.
* **Negative or zero totals fall through** to the plain load. `_sym+-4` is a
  formatting question rather than a codegen one, and the small-offset case is
  already an inc/dec chain.
