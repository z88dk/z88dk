# 80cc design index

The only file that states the current next action. Everything else in this
directory is either durable (`adr/`), a measurement (`../../test/suites/BENCH_MATRIX.txt`),
or historical.

Last swept: 2026-09-14. Keep it short: when a section stops describing what is
live, it belongs in `adr/` or in git history, not here.

## Next action

**The simplification is finished.** All four invariants hold and two of them are
enforced by a script. What remains is optimisation work, and the order matters:

0. ~~Fix the point-query misuses~~ — **done**: a static DE-clean proof now runs
   with no ambient point, and window rejections across the corpus went 26 -> 0.

1. ~~Fix two point-query misuses~~ — `hashbench/hash_key v9` and
   `structbench/walk v2` ask a whole-function question through `ir_home_at` at
   flat index 0, before the value's live range starts. Harmless today, a
   miscompile under ranging. Small and independent of everything else.
2. **Model what an eviction CAUSES, not what the accesses cost.** The
   realised-cost ledger as ADR 0035 framed it is closed: refining the *price*
   of the eviction has now failed twice, on the incumbent's side (ADR 0036) and
   on both sides at once (ADR 0037). ADR 0037 has the evidence that retires the
   framing — `matrixbench/stencil` takes the **same** eviction to −6.2 % ticks
   on 8085 and **+12.5 % on z80 sp**, a spread no per-access price can produce.
   What is missing is the BC **reload traffic** each freed temp brings with it,
   which the `bc-evict` comment names but nothing counts.

   Do it the way this project has done every risky arc that worked: **verifier
   first.** Count emitted BC reloads per freed temp, check the count explains
   the `stencil` spread, and only then let it near a decision. Do not schedule
   a third attempt at a better price — ADR 0038 is the third failure and the
   clearest: the 8085 cost rows really are wrong (a word slot is 33 cycles, not
   the z80's 45), and **correcting them makes the output worse on both axes**,
   because a cheaper slot shrinks every register home's modelled value by 32 %.
   Accuracy in the per-access price is not what is missing.

   Earlier refusal for the record: ADR 0036 charged a param eviction for the
   framelessness it costs. Its apparent −229 bytes came from firing in **sp
   mode**, where there is no frame to save; correctly scoped it is inert. Two
   lessons carried forward — a size claim must name the file set it covers
   (`long_ir/leaimm` regressed 17 bytes *outside* the 720-cell matrix), and a
   function under an **sp-flip trial** is allocated with the frame flag
   deliberately flipped, so any "what mode is this?" test during allocation must
   distinguish the real function from a clone.
3. **Then `IR_TIGHT_HOMES`** (ADR 0027). Investigated 2026-09-14: its
   byte-identity failure is **not** a latent miscompile — it is the allocator
   taking newly-visible claims without pricing what they displace. It follows
   the ledger rather than preceding it. On the `md5` witness the worse code is
   the **sp-flip clone's** allocation, not the fp one (ADR 0036) — start there.
4. Then stages 2 and 3 of the ranging arc (ADR 0017).

**Shipped 2026-09-15** (ADR 0039): 8085 slot addresses use LDSI —
−366 bytes, −0.95 % ticks, nothing larger, nothing slower. It came out of the
*failed* 8085 pricing work (ADR 0038): the cost model could not use the chip's
cheaper slot, but the lowerer could. When a cost-model correction refuses,
check whether the fact it uncovered is actionable one stage further down.

### Background work, when there is time

**Give the shipped default-on optimisations ADRs, then trim their comments.**
Of 115 registry names only about 15 are named in an ADR. Roughly ten features —
`remat-lea`, `dead-store-share`, `trunc-res`, `fclong-carry`, `call-bremat` and
similar — carry their justification, including benchmark figures, in a long
block comment and nowhere else. 26 such blocks hold ~370 lines.

The order matters: **write the ADR first, then cut the comment to the rule plus
a pointer.** Doing it the other way loses the reasoning. Figures belong in
commit messages, `BENCH_MATRIX.txt` and the ADR's evidence link — never in a
code comment, which is this project's own rule (`adr/README.md`) and the reason
several comments here had gone stale.

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
| `IR_LEDGER` | does the BC evict decision compare the right numbers? | **answered, no** (ADR 0037): the flat unit really does misprice — 19 candidates scored as one incumbent — but correcting it is worse on size and ticks. The question was the wrong one. Keep the probe; it is how the 64 `inc=0` no-op decisions were told from the 25 real ones |

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
