# 80cc design index

The only file that states the current next action. Everything else in this
directory is either durable (`adr/`), a measurement (`../../test/suites/BENCH_MATRIX.txt`),
or historical.

Last swept: 3/10/2026. Keep it short: a list of items to tackle next, not a
narrative — when a section stops describing what is live, it belongs in
`adr/` or in git history, not here.

## Next action

**START HERE: ptrbench, init_data's struct loop.** z80 `code_compiler`, from
the objects, 4/10/2026: 80cc fp 1381 B / sp 1458 B against sdcc 1160 B and
xcc -Os 1074 B (3/10: 1418 / 1523). Size only; 80cc is the fastest of the
three. Two changes on 4/10 (uncommitted at the time of writing):
- `smax0`: LFTR's signed-bound `max(0,n)` is one op, `bit 7,h; jr z; ld hl,0`
  (8080: `ld a,h; add a,a; jp nc`). Corpus -1090 B, 34 cells, 0 larger,
  0 slower. Only ptrbench and backgammon take it in the corpus and examples.
- `de-rearb`: a word DE-home pick the render rejects used to revert to the
  allocator's snapshot, but packs made after the pick had seen the pair it
  vacated as free and get demoted, so the function came out worse than
  without the proposal (ptrbench `init_data` sp: 443 B against 418 B). The
  function is lowered again from a clone with no DE-class home, and that
  render is kept when a byte estimate puts it more than 3% smaller. 12 CPUs:
  -2385 B, 123 cells, 0 larger. Always keeping it is -1638 B with 47 larger:
  the margin covers what copt does after the estimate.

ticks undercharged ez80 `ld rr,(ix+d)` / `ld (ix+d),rr` (1 cycle, not 5) until
e67c93926d: any ez80 tick result before that favours frame-slot code. Three
ez80 exclusions resting on it are lifted (`idx2-call-ez80`,
`ivsr-suppress-ez80`, `remat-lea-ez80fp`): ez80 sp -681 B / -1.51% ticks, fp
-155 B / -0.40%, 0 slower except fixedbench fp (+7 B, +1.28%). That loss
was IVSR suppression against a byte-bounded counter, which lives in a slot:
ez80 steps a slot pointer natively, so there the pointer is kept
(`ivsr-ez80-byte`, -41 B, fixedbench -1.0% fp / -1.8% sp, nothing else moves;
on the Z80 family the same exception loses). ez80 word reads
through HL use `ld hl,(hl)` (`ez80-hl-ihl`) and a stack-top read-modify-write
drops its `push hl`/`pop de` pair (`tos-rmw`, after mulchain-de so it never
takes a chain reload): together -1797 B over 229 cells, 0 larger, 254 faster,
1 slower (maskbench gbz80 +0.08%). Still open on ez80: the allocator's fp
slot costs (2/2/2/4, real 5/5/7/11) move cells both ways when corrected;
reading the deepest word local with `pop hl; push hl` (fp_tos_slot) is a
further -1263 B fp but 8 cells 0.6-3.3% slower (1 B saved per isolated access
for 1 cycle). The word immediate-store fold stays excluded (+111/+153 B).
Y/W/P landed (`yield-total`, `deref-width`, `de-keep-hl`): -56 B, 22 cells
faster, 11 slower (callbench fp +0.3-0.6% from de-keep-hl, matrixbench sp up
to +0.38% from deref-width). With them the corrected ez80 fp slot costs
still lose on matrixbench (IY reduction eviction), callbench (the model
charges every read of a value the lowerer keeps in a register) and
localbench; those come before the cost change.

localbench against sdcc on z80 (5/10/2026): the gap was `escaped` (frame
addresses kept in slots in a function with calls: remat-lea is off there and
lifting it still miscompiles sortbench), `scratch` (dead word stores) and
`record`. Fixed: `ds-fp-store` (a word stored straight to `(ix+d)` was counted
as a slot READ, so word dead-store never fired in fp; a dead spill reaching
that path was then stored below the frame) and `dead-sp-addr` (unused
`ld hl,N; add hl,sp`). -1561 B over 109 cells, 0 larger, 113 faster, 0
slower; localbench z80 fp 277.5M -> 265.5M.

`escaped` fixed (5/10/2026): `remat-lea-call` (a frame address rebuilt while
call arguments are being pushed ignored the words already pushed: sortbench's
`cmp(&v[j],&pivot)`) and `lea-call-args` (any call made every frame address
look needed, so an address whose uses all fold to `(ix+d)` was parked with a
push nothing popped; `IR_PARK_VERIFY` now counts these as `orphan`). -2324 B
over 66 cells, 0 larger; ticks 72 faster, 0 slower once Rabbit `add hl,sp` was
costed 2 cycles, not 11. Next on localbench: `record`.

Real code (5/10/2026): examples/console mm.c aborted in sp mode and the same
shape miscompiled silently (long_ir prestrad: `say("x", ++n); return n;`
returned the old n). BC is saved at a pre-pushed group's FIRST push, so a BC
home written inside the group is undone by the restore after the call.
`prepush-straddle` demotes just those values from BC/B/C; the bench corpus is
byte-identical. Real-code size: console +20% vs sccz80, emu.c +9% vs sdcc
(startrek float temps through slots is the largest single item).

Wide accumulator (5/10/2026), double and long long: a result the next op reads
straight from FA / __i64_acc and that dies there is no longer stored
(`acc-drop-wide`; conversions, moves, returns, stores, a stacked call's only
wide argument, which is now pushed from the accumulator; not a fastcall's,
which is loaded by its own path); an integer literal operand becomes a pool
constant (`acc-int-literal`) and a pool constant is read by address rather
than through a vreg and slot (`acc-pool-operand`). startrek 20044 -> 18342 B
fp, console +17% vs sccz80; bench corpus byte-identical. `IR_ACCDROP_VERIFY`
reports a slot read after a dropped store. Still open: the dead slots stay in
the frame, and a non-commutative op whose left operand is in a slot reloads
the right one.

Lead 2 as it was written (a slotless multi-tenant byte packer) is parked: a
census of the final z80 fp asm finds 15 byte temps inside one straight run,
10 with a free register, about 48 B. The 183-site sizing from September has
been absorbed by later work.

Next, `init_data` loop 4 (fp body 174 B): `arr[i*4+k]` and `recs[i].k` are
both `base + 8i + 2k`, but the loaded value is parked in a slot because the
value and the store address both want HL. The general route is to rewrite
`(x+c)<<s` as `(x<<s)+(c<<s)` and let CSE share `8i`. Count the shape first.
Traps from 3/10: `HANDOVER_2026-10-03_s2.md`. sdcc's z180 column is not a
parity signal: at the default `--max-allocs-per-node 3000` sdcc's z180
ptrbench is 1435 B, against 1153 B at 100000.

Other large gaps to sdcc on z80, for after ptrbench: `bitfieldbench`
+260 B (7%), `localbench` +225 B (6%), `widthbench` +224 B (5%),
`matrixbench` +182 B, `listbench` +156 B. gbz80 has the widest whole-table gap
(+3.9%, sdcc smaller in 28 of 29).

Trap: `md5` is a huge outlier (sdcc 28824 B, 80cc 17324 B); leave it out of any
total or the table looks 80cc-favourable.

**Parked 4/10/2026: byte-scratch packing.** Re-sized on the final asm: about
48 B on z80 fp (15 single-run byte temps, 10 with a free register), see
the next action above. The original plan follows. Short-lived byte values spill to a
frame slot while B or D might be available. Add the verifier first (B
availability against BC tenants, D availability against DE clobbers), size
the two lanes separately, and only promote to a gated prototype + full
gauntlet on a positive, pressure-aware result. `IR_BYTEPRESS=2`'s existing
upper bound (46/720 accesses retainable, ~92 B z80) is not a B/D forecast —
`reg_set`/`reg_step` hold `IR_PR_BC` throughout their hot bodies, so B isn't
concurrently available there; size B and D separately over disjoint ranges.
`home-swap`/`idx-deref`/the duplicate-mask copt rule already cover the
pointer/index and adjacent-mask portions — do not reopen them. Relaxing
`byte_home_realizable` is refuted (+307 B, 49 larger cells at use-count 1).

**Also ready, and the likely answer to ptrbench against xcc:
single-call-site static inlining.** Confirmed missing (xcc does it, 80cc
doesn't) across 6+ benches: `widthbench` (`mix_char`/`mix_long`/`mix_store`),
`divbench` (`udiv`/`sdiv`/`kmix`), `vecbench` (`dot`/`saxpy`), `fixedbench`
(`iir`/`fxdot`), `bitfieldbench` (`reg_step`), `ptrbench` (six helpers folded
by xcc), `queenbench` (`safe` into `place`). Zero duplication by construction
— a function with exactly one call site can't cost anything to fold in, no
heuristic needed. The strongest remaining lever with actual evidence behind
it.

**Queued: byte-into-word carry-conditional add.** xcc folds a byte into a
16-bit accumulator via `add a,l; ld l,a; jr nc,skip; inc h` instead of a full
16-bit ALU op — general shape (`word += (unsigned char)byte_expr`, found in
`hashbench`'s djb2 loop but not Horner-specific), not just one bench. Needs a
single new fused IR op (`word = word + zx(byte)`, via an `ir_match` pattern
like the `shr8trunc`/`IR_CONV_TRUNC_HI` precedent), not a `gen_add` change.
Size across the corpus before implementing.

**Not queued, size permitting later:**
- Multi-call-site duplicating inlining with a real profitability model
  (`fixedbench`'s `qmul`, 73% slower than xcc -Of — xcc duplicates at 3 call
  sites and exposes 2 literal-first-arg calls to constant-multiply strength
  reduction). Bigger than single-call-site inlining above; needs a cost
  model, not a blanket policy.
- Full unrolling of a compile-time-constant trip-count loop (md5's
  Transform, crcbench's bit loop, hashbench) — a straight code-size trade;
  not pursued unless a future profitability model ends up covering it too.
- Embedding copt's matching engine inside 80cc, with a liveness precondition
  fed by 80cc's own backward pass, so the hand-written backward-liveness
  rungs (`inc-mem`, `de-widen`, `idx-rmw-de`, …) could be copt-DSL rules
  instead of one-off C blocks. A genuine mid-size project (engine extraction
  + a new `%dead <reg>` precondition) — prototype on 2-3 existing rungs
  first. Do NOT do this as an external `z88dk-copt` post-pass on rendered
  text: tried once (`gwiden`), miscompiled with no liveness view. CFG-dataflow
  rungs (`bc-flow`/`de-flow`) stay hand-written regardless.
- Retiring the mirror predicate pairs (a legality proof and its emitter each
  encoding the same facts): `op_de_clean`/`try_de_home_clean_store`,
  `sp_dehome_loop_cmp_ok`/`try_sp_dehome_loop_cmp`,
  `de_home_clean_bitop_ok`/its bitop emitter. If picked up, do exactly those
  two families and stop.
- A `%CPU_HAS_*` macro survey found 5 of 14 never consulted (the other 4
  VM1-only) — not itself the CPU sweep (ADR 0079), which already closed.
- Redundant signed-compare overflow correction: once a dominating branch
  establishes a signed value's sign (e.g. surviving an `if (v<0)` clamp), a
  later `v < K` / `v > K` against a same-sign constant still pays the full
  `jp po,.../xor 0x80/rla` correction it no longer needs. Confirmed real in
  `predbench`'s `classify` (a range-check ladder: 7 of 7 later compares
  redundant) and `sat` (2 of 3) — ~45 B, but that is the WHOLE corpus
  footprint today; the corpus has only one ladder-shaped function.
  `sortbench`'s 9 occurrences looked like the same pattern on a `grep
  jp.*po` census but are not: 3-way comparators and partition bounds, each a
  genuinely distinct operand pair. Needs a real dominance check (does a
  provably-reached prior branch fix this operand's sign?), not a textual
  count — likely bigger on real range-check/classification code than on
  this corpus. Not sized further.
- `mix_char`/`mix_long`/`mix_store`-style over-spilling (several
  independently-computed sub-expressions, each needing its own sign/zero
  extension, combined into one accumulator, no loop, no call): genuine and
  80cc-specific where it occurs — sdcc keeps the whole working set in
  registers, 80cc round-trips 4 values through frame slots that trivially
  fit the register file. Checked whether this generalizes and it does NOT:
  `queenbench`'s `place` (recursive, can't be inlined) showed xcc *also*
  spilling heavily and sdcc *also* reloading params from the frame inside
  the loop; `predbench`'s `sat` (straight-line, no loop) showed both
  compilers reloading the parameter on every compare — not a residency gap
  there at all; `fixedbench`'s `qmul` (leaf, 2 params) showed no difference.
  So this is a narrow, shape-specific finding (independent-sub-expressions
  with no loop/call), not a general allocator weakness — do not reopen the
  broader "80cc's allocator under-captures its own model" theory on this
  evidence alone; the capture-gap finding predates this session and stands
  on its own measurement.

## Recently closed (ADR has the detail)

- **Framework `test.c` cost — ADR 0103.** Six changes (string-literal remat,
  dead indirect-call target spill, control-flow call arguments first,
  jump-to-next, IX save only when used, BC hand-off). `test.c` 754 -> 596 B fp;
  all 682 80cc matrix cells smaller, -85735 B. Left: the `longjmp` cleanup
  (needs a `noreturn` concept) and the `if (p) p();` reload (needs an
  address-keyed HL belief; an IR-level forward was tried and refused, see the
  ADR).
- **frame-byte-trunc — shipped, default-on.** A width-2 value truncated to
  one byte (`gen_conv_trunc`, `gen_mov`, `gen_sar16`'s sign-extend cases, the
  `gen_shr`/`gen_shl` partial-load fastpath) now reads just that byte from
  the frame instead of materialising the whole word through HL first. Also
  fixed: the partial-load fastpath missed every in-place PARAM (no SPILL
  slot, so `vreg_spill_slot` alone didn't see it — same PARAM_IN_PLACE gap
  `hlde_belief_droppable` already named), and briefly regressed
  r2ka/r4k/r6k/kc160 until guarded to defer to their native `ld hl,(sp+N)`
  word read when the slot is in range. `BENCH_MATRIX.txt` 80cc columns:
  66 cells changed, 0 grown, -295 B total.
- **IR_IVWIDTH — REVERTED IN ENTIRETY.** A loop counter proven to hold only
  byte values throughout one specific loop (constant start in 0..255, step
  +1, constant exit bound ≤255) got an 8-bit loop-exit compare and increment
  instead of 16-bit. The shipped version's -254 B/14-bench figure was WRONG —
  it marked `IR_VREG_BYTE_RANGE` per-vreg, not per-loop, so a non-SSA vreg
  reused for a SECOND, differently-ranged loop elsewhere in the function
  (`searchbench`'s `r`, bound-512 and bound-6) silently got its big loop's
  increment narrowed too, wrapping into an infinite loop — caught only by
  the tick scan (emulator timeout), not `long_ir` or any size scan. A fix
  was written (reject the vreg if referenced outside the one loop's
  preheader+body) but the real yield after it was only -24 B (z80/z80n/z180),
  -20 B (ez80/kc160/rabbit4k), 0 B elsewhere, across 8 of 31 benches, for
  ~260 lines of new allocator+lowering code — not worth the complexity, so
  the whole feature was reverted rather than fixed. `git revert
  74c3fd3e0f` applied clean; gauntlet confirmed byte-identical to the
  pre-feature baseline on corpus scan, long_ir (931/931 both frame modes),
  and all deterministic behavioural gates.
- **Constant-multiply strength reduction doesn't cache its own operand under
  register pressure.** A concrete, reproducible instance of the standing
  allocator-capture-gap finding, found chasing `matrix_compute` (+106 B vs
  sdcc, the single largest per-function gap in a 148-function/23-bench
  census this session ran). The corpus-wide LCG (`seed = seed*25173+13849`,
  textually present in 22 of ~30 bench files) shows TWO different outcomes:
  in `bitfieldbench` the multiply loads `seed` once into BC and keeps it
  resident through the whole shift-add decomposition (matches sdcc exactly);
  in `matrixbench::matrix_compute` the SAME decomposition reloads `seed`
  from its frame slot six separate times. The difference is register
  pressure: `matrix_compute`'s loop counter `i` pins BC for indexing
  `gridA[i]`/`gridB[i]`, leaving no spare pair — sdcc handles this by
  temporarily borrowing DE (push/pop it around the computation) to hold the
  original multiplicand for the chain's repeated references; 80cc's
  strength-reduction codegen just re-emits `load_to_hl` on every reference
  instead of caching the value it already loaded moments earlier. Likely
  fixable LOCALLY in whichever `ir_lower*.inc.c` function lowers a constant
  multiply's shift-add decomposition (cache the operand in a free register —
  or stack-park it — for the chain's duration), not a full allocator
  rewrite. Not sized: next step is a corpus census of the signature (a
  `load_to_hl`-equivalent for the SAME vreg repeated within one straight-line
  shift-add chain, no intervening clobber) to find how often the pressure
  condition actually triggers it — `bitfieldbench`'s clean case shows it
  does NOT fire universally just because the LCG is present.
- **idx2 live-range reuse — ADR 0101.** The idx2 slot hosts non-overlapping
  live ranges instead of one whole-function owner. Measures zero today (BC's
  own multi-occupant check already claims every real disjoint-pair case
  first); kept for shapes outside the sampled corpus.
- **IVSR induction pointer in idx2 — ADR 0102.** ez80/kc160/rabbit only:
  −495 B/−9.94M ticks over 44 cells. One disclosed regression
  (`interpbench`/ez80/sp), root-caused to that feature's own cost pricing,
  not contention — recosting attempted and reverted, see the ADR.
- **switchbench vs xcc — not a lever.** `vm_run`'s dense switch is a linear
  scan (sccz80-style) vs xcc's jump table, but the full z80 row shows
  80cc-sp already beating xcc `-Of`. No measured deficiency.
- **Cross-BB redundant-global-load elimination via merge-point phi — closed,
  do not re-attempt a third time.** gbz80-only opportunity, real ceiling
  ~1 B/read; net −45 B but inconsistent per-file. `IR_PROBE_XBB=1` stays as
  an inert sizing tool.
- **Loop-carried scalar residency — refuted, ADR 0100.** Do not reopen
  without a different, pressure-aware cost model.
- **`[bc-call]` vs `__preserves_regs(b,c)` — closed.** Real gap, inert bug:
  no `ld bc,hl` park in the tree today sits before a call with its read
  after. Nothing to pick up.
- **Constant byte arguments to `__z88dk_sdccdecl` — closed, ADR 0095.**
- **8085 K-flag trip counter — shipped, ADR 0051.**
- **Byte scratch packing (B/D lanes) — shipped.** `byte-pack` /
  `byte-pack-de` opt outs; `IR_BYTEPACK_VERIFY=1/2` keeps the sizing report.
  (Not the same item as "START HERE" above, which is the next B/D
  extension.)
- **R800 CPU target + hardware multiply — shipped.** See
  `src/80cc/R800_TARGET_PLAN.md` for the full arc.
- **Local copy-paste housekeeping (six behaviour-neutral refactors) —
  complete.** Do not merge `load_to_hl` with `load_to_de`, `gen_add` with
  `gen_sub`, or the whole of `gen_cmp_lt_ge` with `gen_cmp_gt_le`.
- **ADRs for the shipped optimisations, trimmed comments — mostly done.**
  34 features documented (ADR 0039-0074). ~15 more registry names
  (`remat-lea`, `dead-store-share`, `trunc-res`, `fclong-carry`,
  `call-bremat`, …) still carry their justification in a long code comment
  instead of an ADR — write the ADR, then cut the comment to the rule plus a
  pointer. Figures belong in commit messages, `BENCH_MATRIX.txt` and the
  ADR, never in a code comment. Five figure-carrying comments are exempt
  because the figures ARE the content: the two `g0_word_cost`/`g0_word_bytes`
  rows (ADR 0038), the C standard citation in `ast_codegen2.c`, and two
  instruction-size comparisons (`ir_lower.c`'s pass-0c lookahead,
  `ir_lower_ops.inc.c`'s inc/dec break-even).

### The CPU-instruction-selection veins — all closed, see their ADRs

1. CPU sweep (ADR 0079, 0081) — method: real-corpus mnemonic+operand diff
   against `opcodes.dat`, not a mnemonic-only diff (blind in both
   directions). Swept: vm1, gbz80, rabbit, 8085, 8080, z80, z80n, z180, ez80,
   kc160.
2. Zero-extension (ADR 0085) — a per-instruction ratio against another
   compiler sizes a difference, not a recoverable one; count the bytes a
   rung could actually delete first.
3. Commutative swap in addition (ADR 0089, 0072) — pass-order-dependent, no
   useful scalar gate.
4. Indexed RMW address restoration (ADR 0093, supersedes 0088) — shipped
   `[idx-rmw-de]`; the remaining base-address rung (18 cycles/5 bytes a
   site) is sized, not queued.
5. Masked word right-shift, Z80 only (ADR 0090) — accepted.
6. Variable-count promoted byte shifts (ADR 0095) — accepted on
   z80/z180/ez80_z80/gbz80/kc160; z80n/Rabbit excluded by tick regressions.
7. Frame-local word-array RMW stack route (ADR 0098) — accepted on every
   measured CPU except 8085 (grew 3 B).
8. r6k instruction utilisation — word ALU against `(ix+d)` is done
   (`try_binop_r6k_ixd`); `(sp+n)` forms were tested and rejected (+97 B
   smaller but +1.4M ticks slower). Revisit only with a profitability
   condition passing both axes.

**Binop route note (background, not reopening ADR 0018):** a width-2 binop
has three operand routes — a pair op with RHS in DE/BC, a byte-direct carry
chain through A reading an eligible frame operand in place
(`try_binop_ixd_fold`), or an already-resident byte-half operand. Sizing an
extension is a per-binop, per-CPU choice, never a new permanent DE home.

## How to work here — the traps that actually bit

- **`long_ir` first, size second.** A size scan on a miscompiling compiler
  is noise that looks like a result, and persuades precisely because it's
  large. Never quote a corpus delta before both frame modes are green.
- **`make && cp && echo BUILT` lies.** Use `if make ...; then … else echo
  FAILED; fi`, and run from the repo root (`PREFIX=$(pwd)` makes cwd
  load-bearing). `md5sum bin/z88dk-80cc` before a scan and compare it to the
  build you think you're measuring.
- **Gate the call site, not a shared helper** — a shared helper's opt-out can
  silently disable an unrelated pre-existing use too.
- **Check the units before believing a result** — a byte-denominated price
  against a cycle-denominated gain reported 145/145 sites paying; in
  matching units it was 7. A 100% result is a symptom, not a discovery.
- **A coarse summary can hide the answer** — ask for the per-item view
  before concluding.
- **A corpus matrix is not the whole test set** — state which set a size
  claim covers.
- **Attribute before you believe** — if a bench moves, bisect it; don't
  assume today's change caused it.
- **`make -j` on `long_ir` garbles the log** — the summed run count
  under-counts nondeterministically. Take the pass count from a serial run.
- **A failed compile in a size scan reports its neighbour's size** if the
  scan reuses one output path. A doubled figure is a symptom, not a
  discovery.
- **copt is invisible to every dump you have** — diff direct `z88dk-80cc`
  output against `zcc -a` before opening a backend pass.
- Building an old commit needs `src/config.h` and the `ext/uthash` submodule
  copied into the worktree — a fresh `git worktree` gets neither.
- Untracked junk in this directory (not compiled): `*.bak`, `*.orig`,
  `md5_fp_push.map`, `sp_ungated.map`. Delete when convenient. About 40
  untracked `.py`/`.sh` analysis scripts remain too; the five the gauntlet
  depends on are tracked.

## The standing invariants

These held when the simplification finished, and two are enforced by a script
rather than by care. Breaking one is a defect, not a style question.

| | Checked by |
| --- | --- |
| 1. Only `ir_alloc` writes or indexes allocation state (ADR 0034) | `scripts/check_ownership.sh` |
| 2. One opt-out registry, two front doors | `scripts/check_options.sh` |
| 3. Every surviving gate has a row below, and every row a gate | `scripts/check_gates.sh` |
| 4. Exactly one live next action in the tree | this file |

Invariant 4 decays by default. What keeps it true: a handover is **deleted**
when its work lands, and durable conclusions move to `adr/` — this file is not
where history accumulates. When a section here stops describing what is live,
promote it or delete it.

## Opt-outs

One registry, each name described in `OPTIONS.md`. Two front doors:

    --opt-disable=name,name     a compiler flag, for a user
    IR_OFF=name,name            the same registry, for a measurement

Read it as `!opt_disabled("my-opt")`; never add a private `getenv` for an
opt-out. `scripts/check_options.sh` fails if a name is undocumented or a
documented name no longer exists.

## Surviving gates

A gate needs a row below **and** a row needs a gate; `scripts/check_gates.sh`
enforces both directions.

### Verifiers — permanent, never swept

`IR_CLOB_VERIFY` `IR_HOME_VERIFY` `IR_HOME_VERIFY_ABORT` `IR_HOME_SLOT_VERIFY`
`IR_HOME_SLOT_VERIFY_ABORT` `IR_IX_VERIFY` `IR_PARK_VERIFY` `IR_REC_VERIFY`
`IR_VERIFY` `IR_VERIFY_ABORT` `IR_VERIFY_I2` `IR_DEFASSIGN_VERIFY` `IR_ACCDROP_VERIFY`

They answer no question and have no expiry. Run the relevant one for what you
touched and report the count before and after.

### Debug output — permanent developer tools

`IR_HOMEMAP` `IR_RANKDUMP` `IR_DUMP_ALLOC` `IR_EMIT_TRACE` `IR_OPT_VERBOSE`
`IR_SPILL_STATS` `IR_IVWHY`
`IR_DEADDEF_LOG` `IR_SPFLIP_LOG` `IR_CALLSPLIT_LOG`

These print; they never change emitted code. `IR_HOMEMAP` is the first thing
to diff when an allocation decision changes.

### Probes with a live question

| Gate | Question | Retire when |
| --- | --- | --- |
| `IR_ALLOC_PROBE` `IR_FRAMEPROBE` `IR_SHLX_PROBE` | one-line censuses inside shipped passes | on their next edit |
| `IR_BYTEPRESS` `IR_RANGEPROBE` | inert sizings: the byte-pair opportunity by pressure, and the ranging population | they are quoted in an ADR |
| `IR_LIVEPROBE` | liveness census; `=2` gives the verbose form | — |
| `IR_BYTEPACK` `IR_BYTEPACK_VERIFY` `IR_SLOTWHY` `IR_WIDENOSLOT` | opt-in allocator/lowering diagnostics and sizing probes | when the associated investigation is closed |
| `IR_CALLBC_PROBE` | how many multi-read, hazard-free word values stay spilled after every placement pass (`=2`: any producer, not only call results) | when the opt-in `callbc` home is decided |
| `IR_BC_STEP_CALL` `IR_BC_STEP_SCALAR` | retained diagnostic probes for the rejected ADR 0100 experiment; not optimisation options | if the probe code is removed |

`IR_RANGEPROBE`'s 461 was an upper bound over the wrong population — do not
size an opportunity by counting values that merely fail to interfere.

### Developer switches, not optimisations

| Gate | What it does |
| --- | --- |
| `IR_DUMP` | dump the IR through the compiler-glue bridge |
| `IR_DEAD` | report orphan vregs removed by `ir_compact_vregs` |
| `IR_CLONE_TEST` | lower a pristine deep CLONE instead of `f` — the `ir_clone_func` self-test. Output must stay byte-identical |
| `IR_STORDER` | `=0` restores the previous store-dispatch order (default on) |
| `IR_NO_BOOL_RET_BRANCH` | keep `return <a && b>` as a value rather than a branch |
| `IR_NO_NOTNOT_FOLD` | keep `!!x` as two coercions instead of folding to `x != 0` |

`IR_OFF` is deliberately absent from these tables: it is the opt-out registry's
front door, documented under **Opt-outs** above.

### The ranging arc (ADR 0017) — closed

Promoted out: `IR_TIGHT_HOMES` -> `tight-homes`, default-on (ADR 0027);
`IR_BC_STEP_PARAM` (ADR 0031). Refused and removed: `IR_RANGED` (ADR 0029,
miscompiled), `IR_JR_UNCOND` (ADR 0033), `IR_TRIPW` (ADR 0028),
`IR_INPLACE_MASK`/`IR_INPLACE_CMP`, `IR_OPRES` (ADR 0018), `IR_NO_A_CARRY`,
`IR_FLIPCOST`, `IR_SPINC`, `IR_SPEXCL`, `IR_REHOME`. `IR_GBZ80_MASK` remains
the bisection tool for future gbz80 work.

### Numeric knobs — a category with no home

`IR_BCCALLCOST` `IR_BYTETIE` `IR_CS_EVICT_MIN` `IR_DEPARK_SWEEP` `IR_GBZ80_MASK`
`IR_IVACCK` `IR_IVHOT` `IR_LONG_PUSHES` `IR_SPCOST` `IR_TM_MINGAIN`

Each sets a tuning constant, so the opt-out registry can't express it — on/off
only. Parked experiments with a dial: promote the tuned value into the code
and delete the dial, or delete both.

## Documents

The 92 untracked plans and handovers that used to sit here are committed on
the branch **`80cc-docs-archive`** (one commit, never merged):

    git show 80cc-docs-archive:src/80cc/WIDTH_HANDOVER.md
    git checkout 80cc-docs-archive -- src/80cc/<file>.md

What survives here is the durable layer: `adr/` (102 records), `CONTEXT.md`
(vocabulary), `AGENTS.md` (working rules), this index, the validation and
check scripts under `scripts/`, and the retired probe sources under
`probes-retired/`.

`CONTEXT.md` is spelled in capitals: this workspace mounts from a
case-insensitive host filesystem, so `context.md` resolves to the same file
here and would not on a case-sensitive one.

Nine refuted theses (ADRs 0018-0024) remain recorded only in the archive
branch — worth promoting if anyone proposes them again: the long/swap
thesis, the in-place `(ix±d)` byte-ALU lever, counter-step cost discounts
(refuted seven times; the call-containing attempt is durable in ADR 0100),
`ex de,hl` as the gbz80 gap, HL-staging as a density lever, ordered
byte-vs-byte compares, the remat-LEA callless gate.
