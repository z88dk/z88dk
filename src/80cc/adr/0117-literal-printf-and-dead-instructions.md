# ADR 0117 — Literal printf becomes puts, and four dead-instruction cleanups

Status: **Accepted** (2026-10). Opt-outs: `printf-puts`, `fp-de-store`,
`dead-ex-de-hl`, `dead-ld-hl-a`, `st-pop-de`.

## Context

The `z88dk-ext` survey now has an xcc column. On the 57 files all four built
(z80, frame pointer, code section only): 80cc 83,099 B, sdcc 77,436 B,
xcc `-Os` 116,724 B. On the 85 files 80cc and sdcc both built: 80cc 123,023 B
against sdcc 111,633 B (+10.2 %); against sccz80 on its 129 files, +6.1 %. A
per-function comparison against sdcc found two kinds of waste: dead
instructions left behind by cache-driven code, and call sequences sdcc folds
away. `columns.c` `main` was 175 B against sdcc's 62 B because sdcc turns
`printf("lit\n")` into `puts("lit")` and merges adjacent ones.

## Decision

- A statement `printf("text");` whose format has no `%` becomes `puts("text")`
  when the text ends in a newline (the newline is dropped, `puts` adds it).
  Adjacent such statements, `puts` included, merge into one call. The
  front end does it in `stmt.c` as each statement is parsed. The merged string
  replaces the originals only when they are the tail of the literal queue, so
  no orphan string stays in the pool. The call must be an expression statement
  (result unused), the callee the library `printf`/`puts` (not defined or
  static in the file), and `puts` must be declared.
- A word stored from DE to a frame slot within `ix` reach in frame-pointer mode
  is two `ld (ix+d),r` (one `ld (ix+d),de` on ez80), 6 B against 7 B and no HL
  clobber. A run of adjacent slot stores still prefers the HL address walk
  (`switchbench` Rabbit +2 B).
- `ld hl,N; add hl,sp` with HL and carry dead is dropped; carry-dead now looks
  through a label (only this path's reads count). An `ex de,hl` after which
  neither HL nor DE is read is dropped. An `ld h,a; ld l,a` pair whose halves
  are rewritten before use is dropped, with the `ld a,l` that follows it (the
  signed word divide by 2^k widened a sign mask and then masked it).
- A word store through a pointer in HL, with the value parked on the stack,
  pops into DE (`pop de`) instead of via HL and reloading the pointer.
- `line_reads_pair` ended an operand at a trailing `;comment`, so
  `ld (ix-2),hl ;volatile` read no register. It now stops at the comment.
  `dead-ex-de-hl` exposed this in `sdcccall.c`; the other callers of the
  liveness walk had been lucky.

## Result

Corpus size scan (832 cells): -5512 B, 6 cells larger by 1-2 B (Rabbit
`switchbench`, `strbench`, frame-pointer). Ticks: 339 cells changed, 8 slower
(under 0.2 %), `localbench` -5 % on z80 and gbz80. Survey, frame pointer:
z80 123,023 -> 120,711 B, r2ka 106,770 -> 104,599 B; the gap to sdcc is now
8.1 % on z80. `camel.c` -365 B, `bc.c` -267 B. A small text program
(`p.c`: eight literal printfs) links 53 B smaller and runs 24 % fewer T.
Tests: `long_ir/densify.c` (all CPUs, both frame modes), `printfputs.c`
(output equals the host's; `printfputs_asm` checks the calls became `puts`).

## Left

- `printf("%s\n", s)` is `puts(s)` and `printf("%c", c)` is `putchar(c)`; both
  are rare in the corpus (12 and 5 sites).
- Signed word `/2^k` is still 13 B; `bit 7,h; jr z; inc hl; sra h; rr l` is 9 B
  with a branch.
- The largest per-function gaps against sdcc are `invazion` `main`
  (+899 B), `text3dmaze` `generate` (+435 B) and `kaleido` `rnd_bars` (+415 B),
  not yet examined.
