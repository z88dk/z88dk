# 80cc design index

The only file that states the current next action. Everything else in this
directory is either durable (`adr/`), a measurement (`../../test/suites/BENCH_MATRIX.txt`),
or historical.

Last swept: 2026-09-15. Keep it short: when a section stops describing what is
live, it belongs in `adr/` or in git history, not here.

## Next action

**Last swept 2026-09-15.** The simplification is finished, the residency arc is
closed, and the documentation backlog is cleared. What follows is the handover.

### What closed, and why it will not reopen

The **ranging arc (ADR 0017)** is done as far as evidence takes it. Stage 1
shipped; stages 2 and 3 are refused, each on a measurement rather than a
judgement:

| | result |
|---|---|
| stage 1, truthful intervals (`tight-homes`, ADR 0027) | **SHIPPED default-on**: 20 cells smaller, 0 larger, 20 tick cells faster, 0 slower. Two predicate bugs fixed on the way, one a latent miscompile |
| stage 2, packing order (earliest-start -> earliest-end) | **inert**: same 114 values packed, 0/720 size, 0/420 ticks |
| stage 2, clash test on the truthful window | **nothing to reclaim**: 6 of 214 BC tenants are narrower than their live range |
| stage 2, IY "one owner per function" bail | **zero**: 10 functions, 24 candidates, 0 disjoint from the owner |
| stage 3, expensive form (park the tenant) | **7 of 145 sites pay**, even though 74 have a completely idle tenant |
| stage 3, fail-safe form (`IR_RANGED`, ADR 0029) | **MISCOMPILED** — 17 cells; deleted, −114 lines |

Four separate cost-model corrections were refused before those (ADR 0036, 0037,
0038, and the ledger they served). **They share one cause**, and it is the single
most useful thing to carry forward:

> The allocator's model is not the constraint. Its **reachable set** is.
> `bc-evict` adds no residency at all — it swaps homes (+0/+1/+0/+2/+0/+0 across
> six benches). Time-sharing already works where the packers look. Where they do
> not look, sharing is not what stands in the way — **admission** is.

So: **do not add a cost term to the allocator**, and do not size an opportunity
by counting values that merely fail to interfere. Count what the allocator would
actually consider. `IR_RANGEPROBE`'s 461 was an upper bound over the wrong
population, and `IR_PAIRPROBE` taught the same lesson before it.

### The four veins worth digging, in order

**1. Sweep the remaining CPUs for un-mined instructions.** *Cheapest, and the
only thing that paid outright today.* Diff each CPU's declared capabilities
against what the lowerer actually emits. That method found LDSI on 8085 —
**−366 B and −0.95 % ticks, nothing larger or slower** (ADR 0039) — in an
afternoon. Only 8085 and gbz80 have been swept. **z180 (`mlt`), z80n (`mul`),
rabbit, ez80 (`lea`) and kc160 have never been.** Start from the `CPU_HAS_*`
macros in `define.h`: five are never consulted by the backend, four of them
KR580VM1-only.

**2. Zero-extension.** The one *consistent* gap against ez80clang. On int and
byte code 80cc is level or ahead; on 32-bit it loses to helper calls; and
zero-extension is the one thing that is reliably worse everywhere. Unlike the
residency work this is a lowering pattern with a known-better reference to diff
against, which is exactly the shape that has been working.

**3. The HL-bus 16-bit problem.** The largest single number in the notes: 80cc
emits ~3x sdcc's 16-bit ops and half its 8-bit, because HL is the only
accumulator so every 16-bit op forces an evacuate-to-DE. Measured shuffle cost
**1572 B on z80, 2830 B on gbz80**. The earlier refutation measured staging
*rate*, not emitted shuffles, so it is **not** actually closed. Big, but the
prize matches.

**4. The commutative swap in addition (ADR 0072).** `md5` gains **6 % of its
cycles** and it is blocked by one modelling gap: reading a slot in pass 1 of the
lazy spill resurrects a store pass 2 had elided (+28 B binary-trees, +75 B
emu.c). Needs a cost model over the two-pass spill decision, not a residency
test.

Still parked and still valid: **8085 K-flag trip counters** (ADR 0051,
*Proposed*) — 236 candidate sites, 2 bytes and ~8 cycles each plus a freed A,
emulator support already present. Not a peephole: K sets on −1 not 0, so the
counter's init must shift by one. Measure what fraction of the 236 are pure trip
counters before building.

### How to work here — the traps that actually bit, this session

* **`make && cp && echo BUILT` lies.** It printed BUILT on a failed build and a
  measurement then ran against a stale binary, reporting a plausible `0/0`. Use
  the `if make ...; then ... else echo FAILED; fi` form.
* **Check the units before believing a result.** Pricing a park with
  `g0_word_bytes` against a gain from `interval_benefit_x` (which is
  CYCLE-denominated) reported **145 of 145 sites paying**. In matching units it
  was 7. *A 100 % result is a symptom, not a discovery.*
* **A coarse summary can hide the answer.** The per-function realisation summary
  showed *no change* on the exact CPU that regressed, while 12 of 22 per-vreg
  rows differed. Ask for the per-item view before concluding.
* **A corpus matrix is not the whole test set.** 720 cells said "no cell larger"
  while a `long_ir` file was 17 bytes worse. Size claims must name their set.
* **Attribute before you believe.** `strbench`'s −4.5 % was reported here as the
  tight-homes flip; bisection showed it was `41d2e40dae` (BC step-param), landed
  days earlier. If a bench moves, bisect it.
* Building an old commit needs `src/config.h` and the `ext/uthash` submodule
  copied into the worktree — a fresh `git worktree` gets neither.

### Background work, when there is time

**8085 K-flag trip counters (ADR 0051).** The last declared-but-unused CPU
capability: `CPU_HAS_JP_K()` exists and no backend file consults it. 236
candidate sites in the corpus, each worth 2 bytes, ~8 cycles and a freed A, and
the emulator already models the flag. NOT a peephole — K sets on −1, not 0, so
the counter's initial value has to shift by one. Scope it to pure trip counters
and **measure what fraction of the 236 qualify before building**.

A survey of all 14 `CPU_HAS_*` macros found five the backend never consults;
the other four are KR580VM1-only. gbz80 was checked at the same time and is
**not** a candidate — it already emits its specials heavily (`ld hl,sp+N` 2897x,
`ld a,(hl+)` 1633x, `add sp,N` 890x). Sweeping the remaining CPUs the same way
is cheap and is how ADR 0039 was found.

**Give the shipped optimisations ADRs, then trim their comments — DONE.**
34 features documented (ADR 0039-0074), ~240 lines of comment removed, output
byte-identical throughout. Each comment keeps the rule, the gate spelling and any
correctness landmine; the figures live in the ADR.

**Five figure-carrying blocks remain and SHOULD**, because there the numbers are
the content rather than the justification: the two measured `g0_word_cost` /
`g0_word_bytes` cost rows in `ir_alloc.c` (ADR 0038), the C standard citation in
`ast_codegen2.c`, and two where the figures are instruction sizes being compared
(`ir_lower.c`'s pass-0c lookahead, `ir_lower_ops.inc.c`'s inc/dec break-even).

The rule that produced this, for anything added later: **write the ADR first,
then cut the comment to the rule plus a pointer.** Figures belong in commit
messages, `BENCH_MATRIX.txt` and the ADR — never in a code comment.

One step of the original simplification plan was deliberately not done:
retiring the mirror predicate pairs — a legality proof and its emitter each
encoding the same facts, so an emitter change can silently invalidate its proof.
The pairs are `op_de_clean` / `try_de_home_clean_store`,
`sp_dehome_loop_cmp_ok` / `try_sp_dehome_loop_cmp`, and
`de_home_clean_bitop_ok` with its bitop emitter. If it is picked up, do exactly
those two families and stop; "one family at a time" has no natural end.

## The standing invariants

These held when the simplification finished, and two are enforced by a script
rather than by care. Breaking one is a defect, not a style question.

| | Checked by |
| --- | --- |
| 1. Only `ir_alloc` writes or indexes allocation state (ADR 0034) | `scripts/check_ownership.sh` |
| 2. One opt-out registry, two front doors | `scripts/check_options.sh` |
| 3. Every surviving gate has a row below | this file |
| 4. Exactly one live next action in the tree | this file |

Invariant 4 decays by default. What keeps it true: a handover is **deleted**
when its work lands, and durable conclusions move to `adr/` — this file is not
where history accumulates. When a section here stops describing what is live,
promote it or delete it.

## Opt-outs

One registry of 115 names, each described in `OPTIONS.md`. Two front doors:

    --opt-disable=name,name     a compiler flag, for a user
    IR_OFF=name,name            the same registry, for a measurement

Read it as `!opt_disabled("my-opt")`; never add a private `getenv` for an
opt-out. `scripts/check_options.sh` fails if a name is undocumented or a
documented name no longer exists.

## Surviving gates

58 remain. A gate needs a row here or it is deleted.

### Verifiers — permanent, never swept

`IR_CLOB_VERIFY` `IR_HOME_VERIFY` `IR_HOME_VERIFY_ABORT` `IR_HOME_SLOT_VERIFY`
`IR_HOME_SLOT_VERIFY_ABORT` `IR_IX_VERIFY` `IR_PARK_VERIFY` `IR_REC_VERIFY`
`IR_VERIFY` `IR_VERIFY_ABORT` `IR_VERIFY_I2` `IR_HR_CHECK`

They answer no question and have no expiry. Run the relevant one for what you
touched and report the count before and after.

### Debug output — permanent developer tools

`IR_HOMEMAP` `IR_RANKDUMP` `IR_DUMP_ALLOC` `IR_EMIT_TRACE` `IR_OPT_VERBOSE`
`IR_SPILL_STATS` `IR_SPILL_WHY` `IR_TRANSIENT_WHY` `IR_IVWHY` `IR_BCFLOW_DBG`
`IR_BLAYOUT_LOG` `IR_DEADDEF_LOG` `IR_SPFLIP_LOG` `IR_CALLSPLIT_LOG`

These print; they never change emitted code. Each is one to six lines inside a
shipped feature, so they cost nothing to keep and answer "why did it do that".
`IR_HOMEMAP` is the first thing to diff when an allocation decision changes.

### Probes with a live question

| Gate | Question | Retire when |
| --- | --- | --- |
| `IR_GRAPH_PROBE` | is the capture gap in proposal or in selection? | the step A1 cost ledger answers it per claim |

| `IR_BCVETO_PROBE` | what does the BC veto turn away? | the veto becomes a cost term |
| `IR_PREPUSH_PROBE` | which calls does the pre-push hazard cover? | — |
| `IR_CMPSIGN_PROBE` | signed-compare shapes | — |
| `IR_ALLOC_PROBE` `IR_B1_PROBE` `IR_DEADDEF_PROBE` `IR_DELIVE_PROBE` `IR_DEPARK_PROBE` `IR_FRAMEPROBE` `IR_NARROWPROBE` `IR_SHLX_PROBE` | one-line censuses inside shipped passes | on their next edit |

### The ranging arc (ADR 0017) — CLOSED

Not parked: closed on evidence. The table in "What closed" above has the
results; ADR 0017 carries the reasoning and ADR 0029 the miscompile that ended
stage 3.

Promoted out: `IR_TIGHT_HOMES` -> `tight-homes`, default-on (ADR 0027);
`IR_BC_STEP_PARAM` (ADR 0031). Refused and removed: `IR_RANGED` (ADR 0029,
miscompiled), `IR_JR_UNCOND` (ADR 0033), `IR_TRIPW` (ADR 0028), `IR_INPLACE_MASK`
and `IR_INPLACE_CMP`, `IR_OPRES` (ADR 0018), `IR_NO_A_CARRY`, `IR_FLIPCOST`,
`IR_SPINC`, `IR_SPEXCL`, `IR_REHOME`. Cost correctness (ADR 0032) shipped;
`IR_GBZ80_MASK` remains as the bisection tool for future gbz80 work.

### Numeric knobs — a category with no home

`IR_BCCALLCOST` `IR_BYTETIE` `IR_CS_EVICT_MIN` `IR_DEPARK_SWEEP` `IR_GBZ80_MASK`
`IR_IVACCK` `IR_IVHOT` `IR_LONG_PUSHES` `IR_SPCOST` `IR_TM_MINGAIN`

Each sets a tuning constant, so the opt-out registry cannot express them — it is
on/off only. They are parked experiments with a dial. Decide them the same way:
promote the tuned value into the code and delete the dial, or delete both.

## Documents

The 92 untracked plans and handovers that used to sit here are committed on the
branch **`80cc-docs-archive`** — one commit, never merged, not part of any
history you have to read. Recover one with:

    git show 80cc-docs-archive:src/80cc/WIDTH_HANDOVER.md
    git checkout 80cc-docs-archive -- src/80cc/<file>.md

What survives here is the durable layer: `adr/` (27 records), `CONTEXT.md`
(vocabulary), `AGENTS.md` (working rules), this index, the validation and check
scripts under `scripts/`, and the retired probe sources under `probes-retired/`.

`DEBUG_LOCALS_PLAN.md` became **ADR 0030** and was deleted — it recorded a
shipped decision, which is what the durable layer is for.

`CONTEXT.md` is spelled in capitals. This workspace is mounted from a
case-insensitive host filesystem, so `context.md` resolves to the same file
here and would not on a case-sensitive one — always write the capitalised name.

### Refutations not yet promoted

Nine refuted theses became ADRs 0018 to 0024. These remain recorded only in the
archive branch, and are worth promoting if anyone proposes them again:

- the long/swap thesis (the gap was byte widening, not long handling)
- the in-place `(ix±d)` byte-ALU lever — no transient load feeds an in-place ALU
- counter-step cost discounts — refuted seven times over, in several forms
- `ex de,hl` as the gbz80 gap — sized and mostly refuted
- HL-staging as a density lever
- ordered byte-vs-byte compares
- the remat-LEA callless gate (worth 30 bytes or less)

Known remaining hazard: about 40 untracked `.py` and `.sh` analysis scripts are
still here and still untracked. They are not documents, so the sweep left them
alone; a `git clean -fd` would remove them. The five scripts the gauntlet
depends on are now tracked.
