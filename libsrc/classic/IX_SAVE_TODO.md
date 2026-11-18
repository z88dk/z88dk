# Classic-lib routines that must save/restore the caller's IX (fp-frame safety)

**Why:** 80cc's fp mode (`-Cc-frameix`) and sdcc use **IX as the frame pointer**.
Some classic-lib asm routines take a callback and load it into **IX** (via
`pop ix` / `l_setix`) — or into **IY** (`l_setiy`) — and never restore the
caller's index register. When called from fp-frame C, the caller returns with IX
clobbered → every `(ix+d)` local/param read is garbage (silent miscompile).

Found by asm-trace of a latent `stdlib/qsort` fp miscompile (2026-07-14): the
sort returned with `IX = &comparator`, so a post-sort `test->result_last` read
was garbage though memory was correct.

**Fix pattern** (per routine): save the caller's IX (and IY where the routine
uses IY) at entry, restore it before `ret`. Two proven models in-tree:
- `stdlib/qsort_sdcc_callee.asm` — `push bc; ex (sp),ix; call asm_qsort; pop ix; ret`
- `stdlib/qsort_sccz80_callee.asm` — bss slot: `ld (qsort_saved_ix),ix` at entry,
  `ld ix,(qsort_saved_ix)` before the single `ret` (guarded `!GBZ80 && !INTEL`).

The class is **callback-via-IX** routines only (they `l_setix`/`l_jpix`/`pop ix`
a function pointer). Routines that merely use IX as a work register with balanced
`push ix`/`pop ix` (e.g. stdio printf/scanf) are already safe. 48-bit math is
handled separately (callers use no frame pointer); C functions with
`__z88dk_saveframe`/`__SAVEFRAME__` auto-save IX under sccz80.

## Tier 1 — qsort / bsearch (common, C-callable) — DONE (557e4f6457)

Whole tier resolved by the closure-based rewrite: classic qsort/bsearch now share
the newlib core, and the entries (`classic/stdlib/{qsort,_qsort,bsearch,_bsearch}.asm`)
`push ix`/`pop ix`, so the caller's frame pointer is preserved by construction.
Verified fp+sp on 80cc, sccz80 (z80/z80n/z180/ez80/rabbit/kc160), sdcc z80.
The interim IX-save bodge is superseded; all of these files are now RETIRED:

- [x] `stdlib/qsort_sccz80(_callee).asm`  — retired (→ `qsort` closure entry)
- [x] `stdlib/qsort_sdcc(_callee).asm`    — retired (→ `_qsort` closure entry)
- [x] `stdlib/l_qsort_callee.asm`, `Lqsort.asm`     — retired (`l_qsort` → `qsort`)
- [x] `stdlib/l_bsearch_callee.asm`, `Lbsearch.asm` — retired (`l_bsearch` → `bsearch`)

## Tier 2 — less common callback routines

- [x] `string/memop{i,d}{,_callee}.asm` — DONE: the entries did `pop ix` to load the
      op pointer. Non-callee now `push ix`, reads the args by offset into registers,
      `call asm_memop*`, `pop ix`. Callee pops the args (af as spare storage), leaves the
      saved ix below the return address, `call`s the core, then `pop ix; ret`. The
      `asm_memop*` core keeps its `ix = op` convention. Verified on z88dk-ticks (IX
      sentinel + data check, op code and fn-pointer op); the old code fails the same test.
      Regression suite: `test/suites/ixsave` (z80/z180/z80n/ez80_z80/r2ka/r4k/r6k/kc160;
      the `ix_get()` helper checks IX around each call, locals are re-read for fp mode).
      Two pre-existing bugs fixed on the way: `memopd`'s Rabbit/Z180/KC160 builtin-op path
      tested `h` and swapped `h`/`l`; and the `memops` table assumed 2-byte entries, but the
      Rabbit 4000/6000 encode `or/xor/and/add/adc/sub/sbc (hl)` as 2-byte `7F xx` opcodes,
      so builtin ops hit the wrong entry. The table is now padded to 4 bytes per entry and
      indexed `memops + 4*op`.
- [x] `adt/linkedlist/adt_ListDeleteS_callee.asm`, `adt/queue/adt_QueueDeleteS_callee.asm`,
      `adt/stack/adt_StackDeleteS_callee.asm` — already `push ix`/`pop ix` (TODO was stale).
- [x] `algorithm/AStarSearch/astar_Search.asm` — already wraps the body in `push ix`/`pop ix`.

## Tier 3 — gfx / games (niche, low priority)

Unlike qsort, these need NO closure — the callback is an internal asm PLOT/effect
routine with a fixed register convention (no per-compiler C ABI), so the ONLY
problem is the caller's frame-pointer IX being clobbered. Fix = `push ix`/`pop ix`
at the **C-callable wrapper that loads IX** (the `ld ix,<plotfn>` site), NOT the
low-level primitive (which just consumes the incoming IX and doesn't outlive the
wrapper). `games/beeper.asm` already does exactly this (balanced push/pop ix) and
is safe — use it as the model.

- [x] gfx dispatchers that `ld ix,<plotfn>`: `gfx/gray/{g_plot,g_point,g_page,g_draw,g_drawb,g_drawr,g_circle}`
      — DONE: `push ix; ld ix,2; add ix,sp` at entry (keeps the `(ix+n)` arg offsets),
      every exit now `pop ix`, tail `jp prim` became `call prim; pop ix; ret`.
- [x] `gfx/wide/w_putsprite3.asm` — DONE: loaded the sprite pointer into IX and never
      restored it; now `push ix` at entry (arg offset 2→4) and `pop ix` before each `ret`.
- [x] The rest of `gfx/narrow` and `gfx/wide` audited: every routine either pairs
      push/pop ix or exits via `__graphics_end` (which pops IX). `narrow/dcircle`'s
      `ex (sp),ix` dispatch and `stencil_render` are also safe.
- [x] gfx primitives consuming IX via `jp (ix)` (`gfx/narrow/{liner,dcircle2,drawbox}`,
      `gfx/wide/{w_drawbox,w_area,w_dcircle,w_liner,w_dcircle_square}`) — NO change
      needed themselves; they receive IX from the wrapper.
- [x] `games/beeper.asm` — already balances push/pop ix (safe).
- video (31 files) — work-register use; `push ix`/`pop ix` if a routine loads IX
      and is C-callable from fp.

Niche: not hot fp-C paths, so do this sweep only if a concrete gfx/games fp
miscompile is observed.

## Not in scope

- stdio (printf/scanf/fputc/…) — balanced push/pop ix, preserve IX in practice.
- sdcard / debug / rect — work-register IX; same push/pop ix fix if ever needed.

## After fixing

Rebuild: `make -C libsrc`. Verify with the fp coverage matrix
(`test/suites/run-matrix.sh`, and the `FP=1` hook in `test/suites/make.config`).
