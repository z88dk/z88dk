# 80cc design index

The only file that states the current next action. Everything else in this
directory is either durable (`adr/`), a measurement (`../../test/suites/BENCH_MATRIX.txt`),
or historical.

Last swept: 2026-09-13, branch `80cc-simplify`.

## Next action

**Finish the gate sweep, then unify home ownership** —
see `DESIGN_REVIEW_PLAN.md` (same directory), steps 2 to 7. In progress:

| Step | State |
| --- | --- |
| 1. Bounded-buffer fixes | done — `aea4c1594f`, `a25f552397` |
| 2. Gate sweep | done — 119 gates to 58; one opt-out registry |
| 3. This index | done |
| 4. Document pass | done — archived on `80cc-docs-archive`, 9 new ADRs |
| 5. Home plan (one owner) | done — no code outside `ir_alloc` writes home state |
| 6. Query boundary | done — `check_ownership.sh` enforces it |
| 7. Lowering facts | not started |

No optimisation work starts until invariants 2 and 3 hold (see the plan).

## The four invariants

1. No code outside `ir_alloc` writes home state — **yes**
2. One opt-out mechanism, not eighteen — **yes**, one registry, two front doors
3. Every surviving gate has a row here — **yes**
4. Exactly one live next action in the tree — **yes**, this file

## Who owns the allocation

`ir_alloc` is the only writer of `vreg_to_phys`, `home_lo` and `home_hi`.
Everywhere else reads. Four writers used to exist outside it, and each was a
way for the plan to be edited behind the allocator's back:

| Was | Now |
| --- | --- |
| the lowerer assigned index-half homes after `ir_alloc` returned | `assign_idxhalf_homes` is the last step *of* `ir_alloc` |
| the lowerer took the word-home snapshot and memcpy'd it back | it calls `ir_alloc_word_home_reject`; the snapshot never leaves `ir_alloc.c` |
| the lowerer demoted an unrealizable home in place | it calls `ir_alloc_demote_home` with the vreg |
| `ir_slots.c` re-derived the backing rules | it calls `ir_home_requires_slot` |

The shape is the same in each case: **the render reports a rejection, the owner
edits the plan.** A rejection names a vreg and a reason; it never carries a
replacement decision.

That ordering also fixed a latent defect. The re-arbitration retry re-runs
`ir_alloc`, which rewrote `vreg_to_phys` wholesale — silently erasing the
index-half homes the lowerer had assigned, with nothing to put them back. It
was inert on this corpus (byte-identical before and after the move) but it was
only ever going to be inert by luck.

The reads went the same way. Nothing outside `ir_alloc.c` indexes the arrays;
it asks one of:

| Question | Accessor |
| --- | --- |
| where is v homed AT THIS POINT | `ir_home_at(f, v)` — lowerer wrapper over `ir_home_at_op(f, v, g)` |
| is v EVER homed in a register | `ir_home_assigned(f, v)` |
| does v need a frame slot | `ir_home_requires_slot(f, v)` |
| is v's home window ranged | `ir_home_is_ranged(f, v)` |
| what window does the home cover | `ir_home_window(f, v, &lo, &hi)` |

`src/80cc/check_ownership.sh` enforces both halves and is the reason this stays
true: it fails on a direct write, a `memcpy` over the arrays, or an indexed
read outside `ir_alloc.c`. It was tested against a deliberate bypass. Run it
with any change that touches residency.

The point query takes its op index as an argument rather than reading lowerer
state, so allocation, slots, the verifiers and a test can all ask exactly what
the lowerer asks.

**One question deliberately left open.** The 27 converted reads all became
`ir_home_assigned`, which ignores the interval — exactly what they did before,
so the conversion is byte-identical. Some of them are point decisions and
*should* honour the window. That is not a cleanup: while homes are
whole-function it changes nothing, and for a call-split value it would change
emitted code. Decide it per site, with a measurement, when ranged residency is
next worked on.

## Opt-outs

One registry of 114 names, **each described in `OPTIONS.md`**, with
`check_options.sh` failing if a name is undocumented or a documented name no
longer exists. Two front doors, equivalent:

    --opt-disable=name,name     a compiler flag, for a user
    IR_OFF=name,name            the same registry, for a measurement

Both accept `all`. Read it as `!opt_disabled("my-opt")`. A shipped optimisation
never gets a private `getenv` — that was the old convention and it produced four
different idioms for one concept, which is why the compiler's own default
configuration could not be determined by reading it.

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
| `IR_TRIPPROBE` | does the trip-count weight model predict real hotness? | `IR_TRIPW` is promoted or refused |
| `IR_BCVETO_PROBE` | what does the BC veto turn away? | the veto becomes a cost term |
| `IR_PREPUSH_PROBE` | which calls does the pre-push hazard cover? | — |
| `IR_CMPSIGN_PROBE` | signed-compare shapes | — |
| `IR_ALLOC_PROBE` `IR_B1_PROBE` `IR_DEADDEF_PROBE` `IR_DELIVE_PROBE` `IR_DEPARK_PROBE` `IR_FRAMEPROBE` `IR_NARROWPROBE` `IR_SHLX_PROBE` | one-line censuses inside shipped passes | on their next edit |

### Parked features — measured across 30 benches x 12 CPUs x sp/fp

4 remain, and **every one has an ADR and a number** — no parked feature is
undocumented. `IR_BC_STEP_PARAM` was promoted out of this table (ADR 0031). Baseline 820,424 bytes
over 720 cells; the bar for promotion is **no cell larger**, then ticks.

| Gate | What it is | Size, 720 cells | Verdict |
| --- | --- | --- | --- |
| ~~`IR_BC_STEP_PARAM`~~ | a stepped-pointer param may ride BC | **−514 B / −0.06 % ticks, 0 cells larger, 0 slower** | **SHIPPED default-on** as `bc-step-param` — ADR 0031 |
| ~~`IR_JR_UNCOND`~~ | relax unconditional `jr` on every CPU | −350 B, but **57 z80 + 57 z80n cells SLOWER, none faster** | **REFUSED and removed** — ADR 0033. Every other CPU already relaxes, so it only ever acted where the timing says no |
| `IR_TIGHT_HOMES` | narrow homes to the true live range (ADR 0027) | −508 B, 73 smaller, **39 larger** | **the premise is refuted** — it was meant to be byte-identical. See ADR 0027; thedifference must be explained before it lands |
| `IR_RANGED` | fail-safe DE cache fold (ADR 0029) | −110 B, 76 smaller, **108 larger** | mixed; fails the no-regression bar, as 0029 suspected |
| `IR_TRIPW` `IR_TRIPW_DEF` | trip-count weighting (ADR 0028) | **+845 B**, 48 smaller, **81 larger** | a net size LOSS. Only defensible if the tick matrix pays for it — measure ticks or refuse it |
| `IR_GBZ80_COST` | the measured gbz80 cost row | −14 B on two benches, **+10 % ticks** on another | **ADR 0032.** A correction, not a preference — gbz80 was using Z80 numbers. Blocked on a ranking near-tie, which is the opportunity-cost term ADR 0021 also wants |

Deleted after measurement: `IR_INPLACE_MASK` (fires on **zero** cells, any CPU,
either mode) and `IR_INPLACE_CMP` (−6 B: 3 smaller, 3 larger — noise). Both were
fp-only proofs of concept; source in `probes-retired/`.

Deleted earlier: `IR_OPRES` (ADR 0018 rejects the thesis), `IR_NO_A_CARRY`,
`IR_FLIPCOST`, `IR_SPINC`, `IR_SPEXCL`, and `IR_REHOME` (a private duplicate of
`home-rearb`).

### Numeric knobs — a category with no home

`IR_BCCALLCOST` `IR_BYTETIE` `IR_CS_EVICT_MIN` `IR_DEPARK_SWEEP` `IR_GBZ80_MASK`
`IR_IVACCK` `IR_IVHOT` `IR_LONG_PUSHES` `IR_SPCOST` `IR_TM_MINGAIN`

Each sets a tuning constant, so the opt-out registry cannot express them — it is
on/off only. They are parked experiments with a dial. Decide them the same way:
promote the tuned value into the code and delete the dial, or delete both.

## Retired this sweep

Twenty probes and five dead gates, about 1,800 lines. Source kept under
`probes-retired/` so a census can be re-run without re-deriving it.

`IR_LDSLOT_WHY` `IR_OPRES_WHY` `IR_OPRES_PROBE` `IR_GPHOME_PROBE`
`IR_SPLIT_PROBE` `IR_LONGPUSH_PROBE` `IR_ADDRRES_PROBE` `IR_SPILLAUDIT`
`IR_VRED` `IR_SHAREPROBE` `IR_PARAMHOME` `IR_PARAMRELOAD` `IR_GRAPH_PROBE`
`IR_ALLOC_PROBE`(fn) `IR_B1_PROBE`(fn) `IR_SPILL_WHY`(fn) `IR_DEADDEF_PROBE`
`IR_CMPSIGN_PROBE`(fn) `IR_DELIVE_PROBE` `IR_HR_CHECK` — and the gates
`IR_OPRES` `IR_NO_A_CARRY` `IR_FLIPCOST` `IR_SPINC` `IR_SPEXCL`

Deleting a probe repeatedly made a helper dead that nothing else used. Let the
compiler find those: delete, rebuild, act on `-Wunused-function`, repeat. Two
rounds found five helpers, one of them 57 lines, that no grep would have
surfaced.

## Documents

The 92 untracked plans and handovers that used to sit here are committed on the
branch **`80cc-docs-archive`** — one commit, never merged, not part of any
history you have to read. Recover one with:

    git show 80cc-docs-archive:src/80cc/WIDTH_HANDOVER.md
    git checkout 80cc-docs-archive -- src/80cc/<file>.md

What survives here is the durable layer: `adr/` (27 records), `CONTEXT.md`
(vocabulary), `AGENTS.md` (working rules), this index, `DESIGN_REVIEW_PLAN.md`
(the current work), and the retired probe sources under `probes-retired/`.

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
