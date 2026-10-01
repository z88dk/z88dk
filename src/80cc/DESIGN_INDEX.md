# 80cc design index

The only file that states the current next action. Everything else in this
directory is either durable (`adr/`), a measurement (`../../test/suites/BENCH_MATRIX.txt`),
or historical.

Last swept: 1/10/2026. Keep it short: a list of items to tackle next, not a
narrative — when a section stops describing what is live, it belongs in
`adr/` or in git history, not here.

## Next action

**START HERE: byte-scratch packing.** Short-lived byte values spill to a
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

**Also ready, arguably ahead of the above if picked up fresh:
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

## Recently closed (ADR has the detail)

- **idx2 live-range reuse — ADR 0101.** The idx2 slot hosts non-overlapping
  live ranges instead of one whole-function owner. Measures zero today (BC's
  own multi-occupant check already claims every real disjoint-pair case
  first); kept for shapes outside the sampled corpus.
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
`IR_VERIFY` `IR_VERIFY_ABORT` `IR_VERIFY_I2`

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
