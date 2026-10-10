# ADR 0119 — Word operands kept in registers: shift copy, factored multiply, global operand in place

Status: **Accepted** (2026-10). Opt-outs: `shl-copy-de`, `mult-factor`, `word-mem-rhs`,
`add-hl-de`.

## Context

The per-function comparison against sdcc (z88dk-ext survey, z80, frame pointer)
put `invazion` `main` 895 B over, `text3dmaze` `generate` 421 B and `ox3d`
`select_move` 260 B. Reading them showed one cause: an operand that is needed
twice is spilled to a frame slot and reloaded, and on the Z80 a word slot access
is two byte accesses (6 B each in frame-pointer mode, a `ld hl,N; add hl,sp`
walk in sp mode).

## Decision

- **Shift copy.** `t = x << n; t + x` and `t - x` on words (the 2^a+1 and
  2^a-1 multiplies) copy x to DE across the shift (`ld de,hl`, 2 B) instead of
  spilling and reloading it. Not where x already has a copy in BC or a register
  home, not while a value homed in DE is live, and only on CPUs where a word slot
  is two byte accesses: not the 8085, ez80, Rabbit or kc160, where it cost a home
  (`hashbench`, the trial lowering priced the slot variant too cheaply).
- **Factored multiply.** `x * (2^a +- 2^b)` with b > 0 is
  `((x << (a-b)) +- x) << b`: b fewer shifts, and the add reads x itself, which
  the shift copy serves. `x * 10` was `(x<<3) + (x<<1)`.
- **Global operand in place.** A word global read once, by the very next op, as an
  operand of a word add or subtract is not loaded; the op loads the other operand
  into HL and reads the global with `ld de,(g)`, which leaves HL alone. The
  stack-spill allocator no longer parks the first operand across that load, and a
  word add with one operand in HL and the other in DE is `add hl,de` even when one
  of them has a BC copy. `alien_y += step` was six instructions, now four. The
  long form of this is ADR 0111; this is its word counterpart. Not on the 8080
  family or gbz80 (no `ld de,(nn)`), and not in a function with a DE home.
- **Dead sign-mask pair.** The cleanup of an `ld h,a; ld l,a` whose halves are
  rewritten now also accepts `pop hl`, `ld hl,bc` and `ld hl,<immediate>` as
  the rewrite (signed `%` and `/` by 2^k in `ox3d`).

## Result

Corpus scans against the previous sweep: -3740 B over 184 cells, none larger;
87 cells faster, none slower. `divbench` -68 B on 8080. Survey, z80 with frame
pointer, 85 files both built: 123,023 -> 118,790 B (sdcc 111,633 B), the gap to
sdcc 10.2 % -> 6.4 %. `invazion`: sp 5392 -> 4568 B, fp 5272 -> 4617 B.
Tests: `long_ir/mulconst.c`, `globaladd.c` (all CPUs, both frame modes).

## Left

- `xc++ == K` on a global keeps the old value in BC and compares it; testing the
  stepped value against K+1 saves four bytes a site.
- Store through a computed pointer with the address parked on the stack and the
  value an `(ix+d)` slot (`text3dmaze` `generate`): 80 sites, 1-3 B each.
- `long + 16-bit constant` is `ld bc,K; add hl,bc; ex de,hl; ld bc,0; adc hl,bc;
  ex de,hl` (11 B); `add hl,bc; jr nc,.+3; inc de` is 7 B.
- A dead `ld bc,hl` park survives before a conditional `ret`.
- The largest remaining gaps: `kaleido` `rnd_bars` (+415 B), `pi` `main` (+316 B),
  `bincomp` (+310 B).
