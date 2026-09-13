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
| 2. Gate sweep | in progress — 119 gates to 78; opt-outs unified |
| 3. This index | done |
| 4. Document pass | done — archived on `80cc-docs-archive`, 9 new ADRs |
| 5. Home plan (one owner) | not started |
| 6. Query boundary | not started |
| 7. Lowering facts | not started |

No optimisation work starts until invariants 2 and 3 hold (see the plan).

## The four invariants

1. No code outside `ir_alloc` writes home state — **not yet**
2. One opt-out mechanism, not eighteen — **yes**, one registry, two front doors
3. Every surviving gate has a row here — **yes**
4. Exactly one live next action in the tree — **yes**, this file

## Opt-outs

One registry of 112 names. Two front doors, equivalent:

    --opt-disable=name,name     a compiler flag, for a user
    IR_OFF=name,name            the same registry, for a measurement

Both accept `all`. Read it as `!opt_disabled("my-opt")`. A shipped optimisation
never gets a private `getenv` — that was the old convention and it produced four
different idioms for one concept, which is why the compiler's own default
configuration could not be determined by reading it.

## Surviving gates

78 remain. A gate needs a row here or it is deleted.

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

### Parked features — measured to change emitted code

These work and are off by default. Each needs a decision: promote after a
gauntlet, or delete.

| Gate | What it does | Status |
| --- | --- | --- |
| `IR_RANGED` | single-BB ranged residency | defended by DESIGN_REVIEW_PLAN 8a — needs its own review, not a sweep |
| `IR_TRIPW` `IR_TRIPW_DEF` | trip-count weighting in the cost model | under assessment; keep with `IR_TRIPPROBE` |
| `IR_OPRES` | operand residency | refuted as a design — see ADR 0018; the gate is the residue |
| `IR_JR_UNCOND` | relax unconditional jumps too | measured, unpromoted |
| `IR_TIGHT_HOMES` | tighter home intervals | measured, unpromoted |
| `IR_SPINC` `IR_SPEXCL` | sp-flip scope filters | debug scoping for `sp-flip` |
| `IR_BC_STEP_PARAM` | BC home for a stepped pointer param | worth ~1 function; fails the one-bench rule |
| `IR_NO_A_CARRY` | inverse of `a-carry` | redundant since `a-carry` joined the registry |
| `IR_GBZ80_MASK` | gbz80 mask lowering | gbz80 only |
| `IR_LONG_PUSHES` `IR_SPCOST` | numeric knobs, not booleans | — |

### Parked features — no measured effect on 4 files x 10 CPUs

`IR_BYTEPRESS` `IR_BYTETIE` `IR_CALL_BREMAT` `IR_CS_EVICT_MIN` `IR_DEAD`
`IR_DEPARK_SWEEP` `IR_FCLONG_CARRY` `IR_FLIPCOST` `IR_G0MEASURED`
`IR_GBZ80_COST` `IR_GWIDEN` `IR_IDX2BASE` `IR_IDXPRICE` `IR_INPLACE_CMP`
`IR_INPLACE_MASK` `IR_IVACC` `IR_IVACCK` `IR_IVHOT` `IR_REHOME` `IR_SHRMASK`
`IR_SHRNARROW` `IR_SHRWIDE` `IR_TM_MINGAIN` `IR_B1_SETUP` `IR_B1_TRIP`
`IR_BCCALLCOST` (numeric knob half)

Silence is not proof of death: the sample is four sources, and a gate can need
a shape it does not contain. These are the next tranche to decide, each on its
own evidence.

## Retired this sweep

Twelve probes, about 800 lines. Source kept under `probes-retired/` so a census
can be re-run without re-deriving it.

`IR_LDSLOT_WHY` `IR_OPRES_WHY` `IR_OPRES_PROBE` `IR_GPHOME_PROBE`
`IR_SPLIT_PROBE` `IR_LONGPUSH_PROBE` `IR_ADDRRES_PROBE` `IR_SPILLAUDIT`
`IR_VRED` `IR_SHAREPROBE` `IR_PARAMHOME` `IR_PARAMRELOAD`

## Documents

The 92 untracked plans and handovers that used to sit here are committed on the
branch **`80cc-docs-archive`** — one commit, never merged, not part of any
history you have to read. Recover one with:

    git show 80cc-docs-archive:src/80cc/WIDTH_HANDOVER.md
    git checkout 80cc-docs-archive -- src/80cc/<file>.md

What survives here is the durable layer: `adr/` (27 records), `CONTEXT.md`
(vocabulary), `AGENTS.md` (working rules), this index, `DESIGN_REVIEW_PLAN.md`
(the current work), and the retired probe sources under `probes-retired/`.

One more file survives on its own terms: `DEBUG_LOCALS_PLAN.md`, status
**shipped** — it records how `-debug` homes a named local in its frame slot
(the mechanism is `IR_VREG_ADDR_TAKEN`, not a new flag). It is tracked and
states no next action. Fold it into an ADR the next time debug information is
touched.

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
