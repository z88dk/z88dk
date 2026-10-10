# ADR 0120 — Stepped compares, constant long adds, frame-slot parks

Status: **Accepted** (2026-10). Opt-outs: `step-cmp`, `ret-cc-bc`, `long-add-carry`,
`slot-park-de`, `long-cmp-ixd`, `word-mem-defer`.

## Context

The items left by ADR 0119 and the next gaps in the z88dk-ext per-function
comparison against sdcc (z80, frame pointer).

## Decision

- **`x++ == K`** compares the stepped value with K+1 (`x--` with K-1), in the
  width of x: an IR pass after narrowing, `==` and `!=` only. The old value no
  longer rides BC across the step and the store.
- **Conditional returns.** The BC liveness sweep treated `ret cc` as a call, so
  a BC park before one was kept. BC is dead on the taken edge, and the
  fall-through keeps the state computed from below.
- **Long plus or minus a constant that fits 16 bits** is `add hl,bc` then a
  skipped `inc de` (`dec de` for a borrow), 3 bytes for the high word where the
  `ex de,hl; ld bc,0; adc hl,bc; ex de,hl` form took 7. A small negative constant
  added is a skipped `dec de`.
- **Frame-slot park.** In frame-pointer mode on the Z80 family a word stored to a
  slot and reloaded a few instructions later with D and E untouched, the slot
  dead after the reload, is `ld de,hl` and `ld hl,de`. The slot allocator reuses
  slots, so "dead" is the next straight-line reference being a whole-word store
  or a return, not "referenced nowhere else". The deepest frame word is excluded:
  it is read with `pop`/`push`, which the text does not show, and `delive`
  caught the first version. Skipped in a function that forms a frame address.
  Not on ez80, Rabbit or kc160.
- **Long ordered compare in frame-pointer mode** loads the left operand and
  compares it with the right operand's slot a byte at a time through `(ix+d)`,
  as the sp-mode form already did through `(hl)`; 12 bytes shorter than staging
  both operands through the stack.
- **A global read at an add** (ADR 0119) now also when pure ops sit between the
  load and the add (`mf[i] = K`: the base is read after the index is computed),
  and when the other operand is already in DE. A value homed in DE no longer
  blocks it function-wide; only one live over the window does.

## Result

Corpus: -109 B over 22 cells, none larger, none slower. Survey (z80, frame
pointer, 85 files): 118,790 -> 118,556 B, the gap to sdcc 6.4 % -> 6.2 %.
`bincomp` -32 B, `kaleido` -32 B. Tests: `stepcmp.c`, `longaddk.c`, `longcmp.c`
and extended `globaladd.c`, all CPUs and both frame modes.

## Left

- The remaining per-function gaps (`rnd_bars` +383 B, `bincomp` +278 B,
  `generate` +253 B, `select_move` +236 B, `invazion` `main` +235 B) are spread
  over many small shapes; the largest single one is a store through a computed
  pointer with the address parked on the stack.
- A byte temp gets a B home for a value read once from A (`x++ == K` on a char).

## Addendum: byte masks, constant subtracts, compares with -1

- `shr-arith-mask`, and a constant left shift: a shift of a promoted char whose only reader masks into a byte is computed in A (`(p[0]<<4)&060`, `(p[1]>>4)&017`).
- `bitop-bytes`: an OR of two byte-valued operands is byte-wide. XOR was tried and grew `localbench` (the byte temporary takes a frame slot), so it stays wide.
- `sub-as-add`: a word minus a constant is `ld de,-K; add hl,de`.
- `cmp-minus1`: `x == -1` is `ld a,h; and l; inc a`. Rabbit's value form tests HL, so only its branch form uses it.

Tests: `bytemask.c`, `cmpminus1.c`.

- `arg-pop-hl` (z80, z80n): the first stack argument of a leaf function, read as `ld hl,2; add hl,sp; ld a,(hl+); ld h,(hl); ld l,a`, is `pop de; pop hl; push hl; push de` when A and DE are dead. The liveness walk now ends at a plain `ret`. z180 is excluded (slower there). When an `ex de,hl` follows, the argument is popped straight into DE. `predbench` sp runs 0.04% slower: the old sequence left A = L, so the next `ld a,l` was dropped, and it is kept now.

Test: `argpop.c`.

- `prop-over-call`: constant propagation of locals keeps every local whose address never escapes across a call (inline asm still forgets all). `const-local`: a byte local assigned one constant and widened by a conversion becomes the constant. `byte-const-smallc`: a constant byte passed only to stacked smallc calls has no slot and is `ld hl,K; push hl`.
- `sx-arg`: a signed char argument to an int parameter or a variadic slot is sign-extended. It was zero-extended (`printf("%d", (signed char)-3)` printed 253).

Test: `constcall.c`.

- `stack-spill-base`: an array-element address is no longer parked on the stack around the byte truncation of the value stored through it. The park blocked the `ld (hl),c` store and cost `m4memory` 30-40% in ticks. A wider rule (any address used by the next load or store) made `rle` 44 B larger and was dropped.
- `printf-puts-scan`: a literal-only `printf` becomes `puts` only when the file has no other `printf`-family call, or already calls `puts`. `puts` is about 65 B of library code, and the conversion saves about 3 B per call, so a file that links `printf` anyway pays for it (`md5` +67 B).

Tests: `stkbase.c`, `printfonly.c`, `printfmixed.c`.
