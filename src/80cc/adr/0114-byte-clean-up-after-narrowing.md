# ADR 0114 — Byte results stop reading the widened word

Status: **Accepted** (2026-10). Opt-outs: `byte-clean` (all), `byte-ext-src`,
`byte-mask-ident`, `frame-byte-trunc-sp`.

## Context

`widthbench` mixes `char`, `int` and `long`. In fp mode its three helpers cost
80cc 2782 T per iteration against sdcc's 1961,
and `mix_char` was +77 % in fp. About 190 T of its 270 T gap was frame traffic.
`s` and `u` (the two byte locals) lived in slots, and their sign- and
zero-extended words were stored to slots only so that a later byte operation
could read their low byte back (`ld (ix-2),hl` ... `ld a,(ix-2); xor 128`).
CSE had merged an extension that feeds word code with one that feeds a byte
operation, so the byte operation read the word.

## Decision

`ir_opt_byte_cleanup`, right after `ir_opt_narrow_byte`:

- A byte-result op (add, sub, and, or, xor, copy, truncation, constant shift)
  whose operand is a `CONV_ZX`/`CONV_SX` of a byte reads that byte instead. The
  byte needs a single definition so it still holds the value, and its live range
  grows to the use.
- A byte `x & 0xff`, `x | 0` or `x ^ 0` becomes a copy. It must be a `MOV`: as a
  `CONV_TRUNC` feeding a store it is fused into the store, which then forms the
  address first and has to park it.

In sp mode `load_byte_half_to_a` reads the low byte of a framed word through the
slot address (`ld hl,N; add hl,sp; ld a,(hl)`) instead of loading the word.

## Evidence

Per call, T-states, sp / fp: `mix_char` 596 / 621 -> 435 / 510, `mix_long` 939 /
897 -> 932 / 890, `mix_store` unchanged. `widthbench` 50.2M against 52.4M on
z80 sp (-4.2 %), -4.7 % on gbz80. Corpus -844 B over 168 cells, none larger;
`widthbench` -539 B of it. Test: `long_ir/bytecleanup.c`, 11 CPU/mode variants.

## Costs and what was refused

- `umchess` fp +6 B. Where the widened word is still in HL, `ld a,l` was free and
  the source byte costs a slot read. The pass cannot see residency.
- Skipping the rewrite when the widened value is used within two ops of its
  definition removes that cost and keeps 4 B of it, but `widthbench` falls from
  -539 B to -296 B. Refused.
- `CONV_TRUNC` for the identity mask: `ptrbench` 8085 +8 B (1238 against 1230) and
  the Rabbits +2 B. Refused for `MOV`.

## Not done

`mix_char` is still 510 T against sdcc's 351: the byte locals still go to frame
slots because BC is busy. That is the byte-scratch packing item.
