# ADR 0076 — The IY reduction pack cannot be arbitrated against the register pools

Status: **Refused**, three times, on measurement. Nothing shipped. Read this
before touching `RC_DE_ACC`, `RC_IDX2` or `ir_iy_reduction_pack`.

## Context

ADR 0075's inline Rabbit multiply cost `listbench` +10..13 % on every Rabbit in
both frame modes. The cause was traced exactly, and the diagnosis still holds:

Removing a call makes a function **call-free**, `idx2_home_available()` then
returns 1, and that admits the `RC_DE_ACC` pool. The pool takes the function's
best IY candidate (`idxben=251`) before `ir_iy_reduction_pack` runs; the pack
skips anything already placed (`if (v == exclude) continue;`) and settles for
`idxben=46`. DE is the `ex de,hl` binop scratch and cannot hold a value live
across a whole function, so the value it took is **spilled anyway**. The pool
claimed what it could not realise and denied it to the register that could.

`IR_OFF=word-resident` restores the original pick, which is the proof. The
diagnostic route is `IR_RANKDUMP` for the pool's inputs, `IR_ALLOC_PROBE` for
the pack's `IY_ACC` line, and `IR_HOMEMAP` for the outcome.

## Decision: three fixes, all refused

**Two of them measured as large size wins before failing.** That is the
substance of this record — the size scan was not the thing that decided it.

| | outcome |
|---|---|
| `iy-yield-idx2` — in fp mode idx2 IS IY, so the pool and the pack contend for one register; yield when the pack's candidate has the higher `idx_ben` | **refused on size**: −1415 B against −1807 B without it, 13 cells larger against 8. `recordbench fp` +80..+98 on five CPUs (z80 353 -> 433) |
| `iy-late-home` — make the pack's home survive `ir_alloc_word_home_reject`, via the existing `alloc_note_late_home` | **refused on correctness**: `long_ir` sp 718/727, fp 714/727 — `callsplit`, `idxbase`, `idxderef`, `slotaddr`, `test.bin`. It had measured −1807 B over 720 cells and fixed sp `listbench` outright |
| `de-yield-iy` — the DE pool yields a candidate the pack wants when the pack's fallback is strictly worse | **refused on correctness**: sp 772/774, fp 768/774. And it does not fix `listbench` without the one above — with the inline on, sp returns to 18668129, the original +10.3 % |

### Why each failed, which is the part worth keeping

**`idx_ben` is the same unit but a different model.** Both candidates are priced
by `interval_benefit(..., GR_IX)`, so the numbers are commensurable in
*dimension* — and still not comparable, because the idx2 pool wants IY as a
plain index home while the pack wants it for `add iy,de` accumulation. It was
right for `listbench` and wrong for `recordbench`. **Matching units is necessary
and not sufficient** — ADR 0038's trap wearing a new face. The pack's gain has
**no number comparable to `idx_ben`**, and producing one is the prerequisite for
any future attempt in this area.

**A late pass cannot keep its home across the word-home revert.**
`ir_alloc_word_home_reject` restores a whole-array snapshot of `vreg_to_phys`
taken at DE-pick time. That looks like a blunt instrument and is not: its job is
to restore a **consistent plan**. The snapshot can already hold an IY home for
another vreg, so mirroring the pack's IY into it leaves *two* owners of IY after
the restore. Treat "preserve a decision made after the snapshot" as unsound by
construction, not as a bug to be patched. `alloc_note_late_home` exists for the
call-split's ranged BC home and is sound *there* because that home is chosen
before the classes it could collide with.

## Consequences

Nothing shipped. `ir_alloc.c` is untouched. ADR 0075's copt fold is unaffected —
it is a rules-file change and never depended on any of this.

Two process notes, because they cost more than the code did:

* **Run `long_ir` before quoting any size figure.** −1807 B was reported as a
  13x improvement on the day's shipped work and was a miscompile. A size scan on
  a compiler that miscompiles is not a weak measurement, it is noise that looks
  like a result — and it is persuasive precisely because it is large.
* **Gate the call sites, not a shared helper.** Putting `opt_disabled()` inside
  `alloc_note_late_home` also disabled the call-split's pre-existing use, so the
  opt-out did not restore any previous compiler — it broke a working fix. It
  showed as `histbench` 385 -> 431, the *wrong direction*, which is what exposed
  it. An opt-out that does not reproduce the old compiler is worse than no
  opt-out, because it is trusted.

`BENCH_MATRIX.txt`, 16/9/2026, carries the full measurement trail.
