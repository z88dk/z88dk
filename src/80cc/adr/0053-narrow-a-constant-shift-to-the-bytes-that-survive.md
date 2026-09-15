# ADR 0053 — Narrow a constant shift to the bytes that survive

Status: **Accepted**, default on. `IR_SHRNARROW=0` reverts, byte-identical.

## Context

A width-4 constant shift computed all four bytes even when a following
`CONV_TRUNC` threw most of them away.

## Decision

Narrow the shift to the bytes the truncation keeps.

## Consequences

Corpus **−257 B over 660 cells, 18 smaller and none larger**, every CPU
improving: gbz80 −38, z80/z80n/z180 −32, kc160 −30, ez80 −29, rabbit −24/−20.
`widthbench` −6.4 % ticks z80 sp, −7.1 % fp, −11.2 % ez80 fp, −11.1 % kc160 fp.

The validation is worth recording because a shift is cheap to get subtly wrong:
`long_ir` 673/673 sp **and** fp, with **every shift count 0..31 × 8 values ×
both result widths** checked against a reference on 6 CPUs × both frame modes.
An exhaustive sweep is affordable here and a spot check is not.
