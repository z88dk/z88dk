# 80cc design index

The only file that states the current next action. Everything else in this
directory is either durable (`adr/`), a measurement (`../../test/suites/BENCH_MATRIX.txt`),
or historical.

Last swept: 2026-09-14. Keep it short: when a section stops describing what is
live, it belongs in `adr/` or in git history, not here.

## Next action

**The simplification is finished.** All four invariants hold and two of them are
enforced by a script. What remains is optimisation work, and the order matters:

1. **Resolve the `IR_TIGHT_HOMES` byte-identity failure** (ADR 0027) — stage 1 of
   the ranging arc, and possibly a latent miscompile. `md5` in fp, +29 bytes,
   reproducing identically on every CPU.
2. **Build the realised-cost ledger**, scoring each `(vreg, home, window)` claim
   and including the **opportunity cost** of the claim it displaces — see
   ADR 0035 for why two sound corrections both made the output worse without
   it. It gates ADR 0021 and ADR 0028 rather than competing with them.
3. Then stages 2 and 3 of the ranging arc (ADR 0017).

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

### In flight — the ranging arc (ADR 0017)

The remaining gates are **not** parked experiments. They are the staged
steps of one piece of work: get to ranged residency, and park a value back in
its slot when its range is interrupted.

| Stage | Gate | ADR | State |
| --- | --- | --- | --- |
| 1. truthful intervals | `IR_TIGHT_HOMES` | 0027 | byte-identity premise **refuted**; explain it first |
| 2. ranging | — | 0017 | blocked on stage 1 |
| 3. park the slot when the range breaks | `IR_RANGED` | 0029 | in flight, conservative form |
| cost correctness | — | 0032 | **done** — SLOT+BC rows shipped default-on; `IR_GBZ80_MASK` remains as the bisection tool for future gbz80 work |

Read their size numbers with that in mind. `IR_TIGHT_HOMES` at −508 B with 39
cells larger, and `IR_RANGED` at −110 B with 108 cells larger, are **not**
verdicts on whether the stages are worth doing — a stage measured alone, without
the stage it depends on, cannot show its value. The one number that IS a verdict
is the `IR_TIGHT_HOMES` byte-identity failure, because that claim was supposed to
hold on its own.

Promoted out of this list: `IR_BC_STEP_PARAM` (ADR 0031, shipped). Refused and
removed: `IR_JR_UNCOND` (ADR 0033, slower on the only CPUs it touched),
`IR_TRIPW` (ADR 0028, worse on both axes), `IR_INPLACE_MASK` and `IR_INPLACE_CMP`
(no effect / noise), `IR_OPRES` (ADR 0018), `IR_NO_A_CARRY`, `IR_FLIPCOST`,
`IR_SPINC`, `IR_SPEXCL`, `IR_REHOME`.

### The first thing to do in this arc

Resolve the `IR_TIGHT_HOMES` byte-identity failure. `md5` in fp mode, +29 bytes,
reproducing identically on every CPU. Two possible causes, needing different
fixes:

1. the lowerer accesses a value **outside its IR live range** — invisible
   residency, which stage 2 converts from harmless into a miscompile; or
2. the narrowed interval changes an allocation decision, in which case stage 1
   is not the neutral substrate it is supposed to be.

Identical behaviour across CPUs points at (2), but (1) is the one that must be
ruled out, because it is a latent correctness bug rather than a cost question.

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
