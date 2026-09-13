# 80cc design review and simplification plan

Status: Agreed, 2026-09-13. Revised twice on that date: first after a source
review of the claims (bounded-buffer fixes promoted to their own step, the
`ir_op_uses` mechanism corrected, a deletion balance added), then after a design
grilling that set the order of work, the gate policy, and the done test. The
decisions are recorded in `Recommended work`.

## Purpose

The goal is a smaller back end that one reader can hold in their head. This plan
reduces duplicate ownership in the IR back end, and it deletes state and code
that no longer answers a live question. It does not propose a new general
register allocator. It also separates current performance work from the
architectural migration.

Smaller is the measurable objective, not a side effect. Every step below must
therefore state what it deletes. A step that only adds an interface over the
present state has failed, even if the interface is correct. The `Deletion
balance` section records this for the plan as a whole.

The review used the accepted ADRs, the active handovers, and the current source.
The most important finding is an ownership split. `ir_alloc.c` chooses homes, but
`ir_lower.c` can add, remove, and restore homes after that choice. This split is
the source of both duplicate state and difficult retry paths.

## Findings

### 1. Allocation has more than one owner

ADR 0001 assigns register and slot decisions to `ir_alloc.c`. The implementation
has four lowerer writes to allocation state:

- `assign_idxhalf_homes` writes `vreg_to_phys` in `ir_lower.c`.
- The recovery path changes `vreg_to_phys`, `home_lo`, and `home_hi`.
- The word-DE-home retry restores a saved allocation array from the lowerer.
- `ir_slots.c` repeats special backing-slot rules for E/D byte homes, the word
  DE home, call-split homes, parameters, and no-slot values.

The retry mechanism also needs global mutable state in `ir_alloc.c`:
`word_home_prepick` and the `alloc_veto` list. A late call-split home already
needed `alloc_note_late_home` so the lowerer restore would not erase it. This is
evidence that the allocation result is not a single object with one owner.

### 2. The home interface remains partly bypassed

ADR 0017 defines a home-per-interval table as the single source of truth.
`ir_home_at` gives the lowerer a useful point-query seam. However, the data still
uses parallel `vreg_to_phys`, `home_lo`, and `home_hi` arrays. Home mode also
leaks through vreg flags and special scalar fields such as `word_home_vreg`.

Many direct reads are legitimate whole-function scans. Others are point decisions
in lowering and call handling. The distinction is only documented in comments.
It cannot prevent a new point decision from bypassing the interval bounds.

The present representation supports one resident window per vreg. It is not yet
the general interval table described by ADR 0017. This is acceptable for the
current call-split feature, but the code and documents must name that limit.

### 3. The arbiter successfully centralised region selection

The picker-retirement work was successful. `collect_home_candidates` now
generates the region candidates and `unified_arbitrate` is the sole default
ranker and selector for them. The retired proposer wrappers were reproduced
byte-for-byte before removal, and the current path has the associated corpus and
long-IR validation history.

`ir_bc_pack`, `ir_iy_reduction_pack`, `ir_iy_temp_pack`, `ir_stack_spill`, and
`ir_callsplit` are not failed remnants of the old picker design. They solve
different problems after region selection: tight call-free intervals, a local
spill transient, or a bounded call split. The HL/A belief cache is lowerer-local
reuse, not allocation. Do not fold these mechanisms into the arbiter without a
measured case that needs it.

What remains centralisation work is narrower. The arbiter has class-specific
cost repairs and eligibility rules because its candidate scores do not always
describe the exact lowerer sequence. Improve those inputs and document the
intentional class ordering. Do not replace the arbiter or revive a parallel
picker path.

### 4. Lowering proofs duplicate lowering selection

The DE-home proof has several paired predicates and emitters. Examples include
`op_de_clean` with `try_de_home_clean_store`, and
`sp_dehome_loop_cmp_ok` with `try_sp_dehome_loop_cmp`. Comments identify several
of these as mirrors. The static and run-time DE-clean checks add another copy of
the same facts.

This duplication is understandable because allocation must prove that lowering
can preserve a home. It is still risky. An emitter change can alter the proof
without changing the predicate, or the predicate can admit a form that no longer
matches the emitter.

### 5. Cost ties hide a missing realised-cost term

The current cost tables correctly vary by CPU, but a candidate score can still
tie when its actual lowering differs. Pass order then resolves a cost-model tie.
That is an implementation accident, not a policy.

A home cost includes more than its direct load or store. It also includes the
entry reload, exit store, pair or byte-half conversion, call preservation,
frame-mode cost, and the claim it displaces. A BC value that must move to HL for
each arithmetic use is not equivalent to a BC dereference base. An index home
can also cost a push/pop pair where a frame displacement costs one instruction.

The source already contains compensating rules for these omitted costs. They
prove that the model is only partly specialised:

- `g0_index_benefit` prices accesses but not index-home setup. The VM1 parameter
  rejection and the `idx_keep` rule add that term outside the model.
- `ir_iy_temp_pack` adds an IY open cost per return. It also rejects dereference
  bases, memory-defined values, and spans without an HL clobber. Each rejection
  supplies a cost that the generic index score cannot represent.
- `g0_word_cost` prices DE like BC. Its own comment says a DE read can need a
  destructive swap and a recovery. The present row does not price that sequence.
- `rank_benefit` scores the best permitted register class. The resolver then
  applies class-specific rules and may choose another class or reject the home.
- BC call charges, byte tie-breaking, counter yielding, and the DE upper-bound
  score all repair a different tie after candidate ranking.

These rules are useful evidence. Do not delete them first. Turn each into a
named cost term, then remove its special gate only when the shared term chooses
the same result.

Start with the `g0_word_cost` DE row. It is the clearest case: the table prices
DE as a copy, the emitted form is a destructive `ex de,hl` that can need a
recovery, and the discrepancy is already written down in the source comment.
Use it as the first witness for the cost ledger in step A1.

### 6. The document set has no current-state control

`src/80cc` has 95 top-level Markdown files with about 25,829 lines. There are
also 18 ADR files. 17 top-level files contain a literal `START HERE`, and
several more carry an equivalent next action in other words. (Counts taken on
2026-09-13 with `ls -1 *.md`, `ls adr`, and `grep -lri 'START HERE' *.md`. State
the command with the count; this finding is about current-state control, so an
unreproducible number would be self-defeating.) The latest handover makes per-function frame-mode selection the current
high-value action. Older documents still present allocator or residency work as
the starting point.

The ADRs are the right durable layer. The problem is the lack of one current
roadmap and an explicit status for every plan or handover. This causes repeated
investigation and makes refuted work appear live.

### 7. Source audit: home-cost specialisation is concentrated and explainable

This audit traced the candidate score through allocation and the matching
lowering paths. It found several distinct kinds of special case. They must not
all be treated as bad duplication. Some are missing realised-cost terms, some
are valid byte-versus-tick policy choices, and some are conservative legality
proofs that must remain outside a cost score.

| Source area | Gap in the generic score | Current specialisation | Classification and action |
| --- | --- | --- | --- |
| `g0_index_benefit` and VM1 index-parameter handling in `ir_alloc.c` | The index score prices accesses but not the caller-slot read and pair setup needed to enter an index home. | The VM1 parameter rule rejects the home; `idx_keep` adds a separate benefit. | Missing entry term. Add setup to the claim ledger before removing either rule. Priority P0. |
| `ir_iy_temp_pack` in `ir_alloc.c` | A generic index row cannot see IY save/restore at each return edge. It also cannot see that a cached HL value avoids a reload until an actual HL clobber occurs. | The pack charges an IY open cost, then rejects dereference bases, memory-defined values, and spans without an HL clobber. | Missing return-edge and cache-state terms. Record real return edges and cache-served accesses. Priority P0. |
| Index access direction in `interval_benefit_x` and `idx2_counter_hostile_use` | The cost differs when lowering needs the value in HL, DE, or as a dereference base. The base `GK_READ`/`WRITE`/`DEREF` categories do not identify that form. | Index-specific scans add operand-direction and HL-contention rules. | Missing access-form term. Make lowering report the form; do not infer it from the register class. Priority P0. |
| `g0_word_cost` DE row | The table prices DE like BC. A DE read can require `ex de,hl`; this is a destructive swap, not a copy, and may need recovery. | Comments describe the discrepancy, but the generic row remains shared. | Unmeasured transfer term. First measure emitted DE sequences by CPU and frame mode; do not retune the row from the comment alone. Priority P0. |
| `bc_call_save_charge`, `IR_BCCALLCOST`, and call lowering | A live range alone cannot price a call: preservation depends on the callee contract and whether argument setup clobbers BC. | Separate BC call charge and call-specific guards. | Missing call-transition term. Move the data into a per-call fact supplied by lowering. Priority P1. |
| `b1_hotness_probe` | The normal loop weight distinguishes only in-loop from out-of-loop. It cannot represent nesting depth, trip count, and one-time home setup together. | A probe has a richer hotness calculation, but it is not the normal score. | Incomplete execution-frequency term. Validate the probe against emitted code before wiring it into ranking. Priority P1. |
| `IR_BYTETIE` byte arbitration | Equal ticks can still have different byte counts. Neither result is intrinsically wrong without an optimisation policy. | CPU/mode-specific tie rule chooses the desired result. | Genuine two-objective policy, not a missing scalar term. Keep bytes and ticks as a vector and state the policy explicitly. |
| `de_upper_bound_score`, `counter_yields_bc_to_index`, and BC-pressure rules | A candidate score does not include the value of the alternative claim it blocks, or operation-specific add/sub effects. | Ordered repairs run after an apparent tie or conflict. | Missing opportunity and operation-form terms. Compare exact competing claims in the resolver; retain the old order as the initial stable priority. Priority P1. |
| Byte, EXX, and other fallback candidates in `rank_benefit` | These candidates still use the older `cost_benefit` path while interval and index homes use more detailed scoring. | A rank can therefore compare costs computed at different levels of detail. | Partial specialisation. Add the same ledger categories incrementally, starting with observed wrong selections. Priority P2. |
| Slot placement in `ir_slots.c` | A spill slot has no fixed access price until slot layout chooses its offset. Slot zero and nearby offsets can have different lowering forms. | Slot assignment applies its own hot-placement and fast-path decisions after home ranking. | Late layout term. Measure it separately; do not make early allocation pretend it knows a final offset. Priority P2. |
| GBZ80 home re-arbitration | A previous GBZ80 regression was attributed to an access-cost row, but the later analysis found an unrealizable-home retry problem. | The recovery and re-arbitration path now handles it. | Closed diagnostic. Keep it as a regression witness; it is evidence that cost and realizability must be reported separately. |
| `op_de_clean` and similar lowerer guards | These determine whether an instruction sequence is legal and preserves a promised home. | Conservative predicates and matching emitters protect the choice. | Legality fact, not cost. Share the facts as in step 7, but never turn an uncertain proof into a large penalty. |

The central defect is therefore not that homes are CPU-specialised. That is
appropriate for the Z80 family. The defect is that the same physical home is
priced by several incompatible models, while `rank_benefit` can rank a vreg by
its best allowed class and a later resolver chooses a different class.

The first implementation should be observational. Add a ledger for the exact
claim that the resolver considers: `(vreg, physical home, resident window)`.
For every term that is unavailable, report `unknown` rather than silently
reusing a generic cost. Compare the ledger with the present rule and with the
actual lowerer sequence on the existing corpus. Migrate a gate only when the
ledger agrees with the old decision on its witnesses and explains at least one
additional selection.

### 8. The IR is large in source lines, but not anomalous in executable code

A like-for-like `cloc` count of the in-tree sources gives the following result.
The 80cc IR set includes every `ir*` C, header, and lowering include file. The
XCC and SDCC rows include their Z80-specific back-end sources and headers.

| Area | Code | Comments | Physical lines |
| --- | ---: | ---: | ---: |
| 80cc IR | 33,705 | 14,153 | 50,072 |
| XCC Z80 back end | 27,260 | 1,719 | 30,943 |
| SDCC Z80 back end | 29,088 | 2,251 | 34,588 |

80cc therefore has about 16--24 percent more executable code in this boundary,
not the apparent 50--60 percent raw-line excess. Much of the physical-line gap
is explanatory comments around measurements and safeguards. A broader check
also finds 48,299 code lines in all 80cc C sources versus 58,990 in the whole
XCC compiler source. These are approximate comparisons: SDCC and XCC place
some optimisation and IR machinery outside their Z80-specific directories.

The size is defensible for an in-development compiler that owns a C front end,
IR construction, optimisation, lowering, eleven CPU variants, and both frame
modes. It is not a reason to accept indefinite growth. In particular,
`ir_alloc.c` has accumulated cost experiments, probes, and environment-gated
policy beside the shipped arbiter. This is useful evidence while a choice is
open, but it becomes a maintenance cost once the choice is accepted or refuted.

Set a code-size rule for future allocator work:

- New optimisation work starts as an off-by-default probe with one stated
  decision it can answer.
- When the decision is accepted or refuted, retain the measurement in its plan
  and delete the probe, its environment switch, and its duplicate tally unless
  it is a permanent correctness verifier.
- A default-on special case must either become a named term in the arbiter's
  cost evidence or be recorded as a deliberate byte/tick policy or a legality
  fact. It must not remain an unexplained historical gate.
- Do not split files merely to reduce a line count. Move code only when it
  gives a stable ownership boundary, such as a cost-evidence or lowering-fact
  interface.

This rule preserves the successful arbiter migration. It targets the genuine
source of ongoing size growth without replacing the arbiter or hiding its
evidence in another layer.

### 8a. Probe retirement audit: seven probes have closed questions

The following source probes can be deleted now, after their reported totals are
retained in their named handover or decision document. This removes the helper,
its `getenv` switch, call site, and probe-only comments; it does not remove a
shipping optimisation or its regression tests.

| Delete | Why the question is closed |
| --- | --- |
| `IR_OPRES_WHY` and `IR_OPRES_PROBE` | `ALLOCATION_DECISIONS.md` records the answer as refuted both for single-BB DE caching and cross-BB carry, with an explicit "never, without a new idea" re-run condition. |
| `IR_GPHOME_PROBE` and `IR_SPLIT_PROBE` | Their call-bounded-splitting question has a shipped answer: `IR_CALLSPLIT`. The decision record identifies the remaining values as the distinct DE-home/deref-base colouring problem, not an unanswered split census. |
| `IR_LDSLOT_WHY` | The long-load-to-slot thesis was refuted: opaque endian-swap calls explain the apparent sites but cannot explain the compiler gap. The handover contains the exact 43-site breakdown. Its statement that the probe "stays as the record" should mean the handover stays, not that inert production code remains. |
| `IR_LONGPUSH_PROBE` | The original long-push census contains a known misleading `usecount>1` bucket. The extension that corrected it was already reverted, and the later handover calls that line of investigation a dead end. Preserve the corrected interpretation in the handover rather than retaining a probe that invites the old reading. |
| `IR_ADDRRES_PROBE` | The address-residency population is documented as thin and not the cause of the outlier. It has no active successor beyond the recorded census. |

Before deleting a probe, save it as a patch file beside its handover, as
`src/80cc/PAIRPROBE.patch.txt` already does. This costs nothing, keeps the
census re-runnable, and removes the only real objection to deleting the
evidence. The probes are individually small (two to five references each), so
the gain is not the line count alone: it is one less inert path that a reader
must classify while following the live one.

This is deliberately not a wholesale diagnostic purge. Keep `IR_GRAPH_PROBE`,
`IR_TRIPPROBE`, `IR_RANGED_PROBE`, `IR_BCVETO_PROBE`, `IR_PREPUSH_PROBE`,
`IR_CALLSPLIT_LOG`, `IR_CMPSIGN_PROBE`, `IR_MWBC_PROBE`, `IR_RANKDUMP`, and the
home/clobber/park/recovery verifiers. They either measure a live cost-model or
allocation question, tune a shipping feature, or check correctness. In
particular, `IR_TRIPPROBE` remains useful while the opt-in `IR_TRIPW` model is
being assessed, and `IR_RANGED_PROBE` is evidence for the still-open residency
contract work.

`IR_OPRES`, `IR_RANGED`, and `IR_TRIPW` are feature gates rather than probes.
Their separate removal or promotion needs a normal behaviour and corpus review;
do not smuggle that decision into probe cleanup.

### 9. Other source smells, separate from home selection

| Priority | Smell and evidence | Recommended change |
| --- | --- | --- |
| P0 | The region-candidate pool is allocated as `n_vregs * 6`, while `collect_home_candidates` has ten independent proposal paths. `add_cand` has no capacity argument or assertion. The current predicates may keep real functions below that limit, but the contract is neither encoded nor checked; a future overlapping predicate can overwrite the heap. | Give the pool a capacity and make `add_cand` check it. Prefer a growable vector, or calculate and assert a documented worst-case bound from the enabled proposal kinds. Fix all four `collect_home_candidates` call sites (`ir_alloc.c:6180`, `:6185`, `:6239`, `:6290`), not only the `bc_region_ok` one. Add a synthetic overlap test. |
| P0 | `ir_op_uses` deliberately returns the full number of uses even when its output buffer is too small. `add_unique` (`ir_analysis.c:125`) does respect `max` on the write, so the helper never overruns its own output; the defect is on the caller side. About 25 allocator, slot, optimiser, and lowerer callers pass a fixed buffer and then iterate the returned count, so they read uninitialised stack and use the result as a vreg index (`ir_alloc.c:117`, `ir_slots.c:170`). The out-of-range index is where the real access happens. The threshold is not sixteen: `ir_opt.c:811`, `:827`, `:839`, and `:993` pass `uses[8]`, and `IR_HCALL` enumerates every `n_args`, so a call with more than eight distinct argument vregs is enough. | Prefer the small fix over an API rewrite: return `min(n, max)` and report truncation separately (an out-parameter, or a companion `ir_op_uses_count`), then update only the liveness builder that genuinely wants the true count. This removes the hazard at every existing call site without editing 25 of them. Test a call with more than eight, and more than sixteen, distinct live arguments. |
| P1 | Render recovery has implicit fixed limits: the allocator veto list holds 64 values, home-demotion holds 32, and dead-store discovery holds 512. The overflow behaviour is inconsistent: a veto is silently ignored, a bad home loses recovery, and a dead-store optimisation is dropped. These arrays also bridge lowering back into allocation. | Put retry data in a dynamically sized per-function allocation context or bitset. Report a bounded-retry failure explicitly. This is part of the allocation-ownership work, not a reason to remove the arbiter. |
| P1 | Allocator CFG discovery passes a fixed 64-entry successor scratch buffer to `alloc_bb_succ`. A switch with more targets is silently truncated before predecessor and loop analysis. | Enumerate successors through a callback or size the temporary list from the switch. Add a large-switch regression before relying on loop depth for allocation policy. |
| P1 | Backend experimentation is configured through many direct environment reads and function-static caches: `ir_alloc.c`, `ir_lower.c`, and `ir_opt.c` contain 142 `getenv` calls between them, each with its own static cache. A compile result is not described by a single options object, and a probe can remain in the shipping path after its decision is known. | Parse IR options once into an immutable `IrOptions` snapshot, log it with a diagnostic run, and retire accepted/refuted probes under the rule in finding 8. Preserve permanent correctness verifiers. |
| P1 | The BC pre-pushed-call save stack is file-static, has a hard depth of eight, and is not part of `LowerState`. At the cap, `gen_push_arg` does not push an entry, but the matching call can still pop the previous nested entry. | Use the per-call save token, not a deeper stack. The depth is mirrored across translation units as `BC_ARGS_SAVE_MAX_PROBE` in `ir_alloc.c:3228`, and `ir_alloc.c:6151` deliberately simulates the emitter including its cap, so growing the stack silently makes the allocator's simulation unfaithful. A token makes `gen_call` pop only when its own `gen_push_arg` pushed, which removes the mispairing without changing the emitter model that the allocator mirrors. Move the state into the lowerer context at the same time. Add a deeply nested pre-pushed-call regression. |
| P2 | `ir_lower.c` keeps the active lowerer, home context, retry state, diagnostics, and several probes in file-static state. `ast_opt.c` also uses file-static temporary-name counters and propagation state. This makes the compiler intentionally single-threaded and makes nested or parallel compilation unsafe. | Do not refactor solely for hypothetical parallelism. If an embedding or parallel build is required, move this state into `LowerState`, `Builder`, and an AST-pass context before exposing that use case. |
| P2 | `ast_opt.c` contains a long ordered sequence of independently gated AST passes. The order is documented in comments but is an implicit protocol in one large file; temporary-symbol creation and pass-local analysis sit beside the scheduler. | Keep the order, but describe it as a pass table with dependencies and per-pass tests. Split only at those stable pass boundaries; do not make a mechanical file split. |
| P2 | On failure to allocate candidate-analysis scratch arrays, `collect_home_candidates` returns an empty pool without a diagnostic. Other allocation paths abort. The output remains correct but can silently lose all region homes. | Choose one policy for compiler-memory failure. Prefer a clear diagnostic and controlled compilation failure over an unexplained code-quality collapse. |

The first two items are API and memory-safety issues. They should be fixed before
any further allocator tuning. The remaining items are maintainability limits;
they should be addressed only when the listed boundary is otherwise being
changed.

### 10. Restrict state-object work to the IR back end

`data.c` and the legacy front end are deliberately out of scope. Their close
alignment with sccz80 is valuable. Do not wrap, rename, or migrate that state as
part of 80cc back-end work.

Within the IR back end, `ir_lower.c` already has a `LowerState`, but related
per-render state remains outside it: `HomeCtx`, lazy-spill context, source
location, recovery lists, BC-call save state, and several per-render probes.
`ir_alloc.c` likewise keeps a word-home snapshot, vetoes, and probe pointers as
file statics.

Use only these back-end-scoped objects:

| Object | Lifetime and contents | First safe extraction |
| --- | --- | --- |
| `BackendRenderOptions` | An immutable snapshot used by one lowering attempt: frame mode and the derived available register set. It reads the existing front-end options but does not replace them. | Stop a per-function frame trial from changing `c_framepointer_is_ix` globally. Pass its frame mode explicitly to the cloned render. |
| `LowerContext` | One render: `LowerState`, `HomeCtx`, current op/BB, lazy-spill state, source location, call-save stack, recovery lists, and render probes. | Move the BC-call stack, `g_hc`, and `cur_lazy_*` into the existing `LowerState` first. Replace fixed arrays with vectors owned by this context. |
| `AllocContext` | One allocation/retry: candidate pool, veto bitset, tentative snapshot, trip weights, and allocation probes. | Replace `word_home_prepick`, `alloc_veto`, `g_pool_member`, and `g_bb_tripw` file statics. Pass the context through allocation and recovery. |

Do the lowerer extraction first. It has an existing state type and it removes a
real fixed-depth correctness hazard. Do the allocation extraction with the
home-ownership change. Leave the front-end state untouched.

## Recommended work

The order below is the result of a design grilling on 2026-09-13. The decisions
it records are what makes this a finite piece of work rather than an open-ended
refactor.

| Decision | Choice |
| --- | --- |
| The pain to fix | Orientation cost per change, not raw volume. |
| Constraint | Byte-identity is absolute for cleanup. An emitted-byte change is a separate, measured commit. |
| Gate policy | A behaviour gate is deleted unless it is defended. |
| Opt-outs | One mechanism for the whole back end, not eighteen bespoke ones. |
| Order | Delete first, refactor second. |
| "Defended" | It earns a row in `DESIGN_INDEX.md`. The index is the sweep's output, not its prerequisite. |
| Documents | Decisions and refutations become ADRs; the ADR status set widens to include `Rejected`. |
| Residue | One archive commit on a side branch, then deleted from the working tree. |
| File splits | Only at a boundary the work itself creates. Never for line count. |
| Done test | Four checkable invariants, below. |
| Optimisation work | Paused until invariants 2 and 3 hold. |
| Audience | Three readers, one artefact each, no fact written in two of them. |
| `ast_opt.c` | Its gates are in scope; its structure is not. |
| Cost ledger | Not this effort. It opens the resumed optimisation programme. |

### The four invariants

The work is done when all four hold, and each is checkable rather than a matter
of judgement:

1. No code outside `ir_alloc` writes home state. The named witnesses are
   `ir_lower.c:6222`, `:7100`, `:7105`, and the prepick restore at `:6893`.
2. There is one opt-out mechanism, not eighteen.
3. Every surviving gate has an index row.
4. There is exactly one live next action in the tree.

Invariant 4 decays by default. The rule that keeps it true is that a handover is
*deleted* when its work lands, not archived beside the next one.

### The sequence

```
1. Two bounded-buffer fixes      ir_op_uses, candidate pool
2. Gate sweep                    119 gates -> survivors; one IR_OFF mechanism
3. DESIGN_INDEX.md               written as the sweep's output
4. Document pass                 ADRs + archive branch + delete residue
5. Home plan                     one owner for allocation state
6. Query boundary                raw arrays renamed so bypasses cannot compile
7. Lowering facts                retire mirror predicates, one family at a time
   ---- invariants hold; optimisation work resumes ----
```

Steps 1 to 7 are all byte-identical. That is what makes them cheap: no bench
argument is needed, and one validation matrix run covers a batch.

### The audience rule

Three readers are served, and each gets exactly one artefact:

| Reader | Artefact | Holds |
| --- | --- | --- |
| An outside z88dk developer | the ADRs | How the back end works and why. No figures. |
| A fresh session with no context | `DESIGN_INDEX.md` | What is live, and the single next action. |
| The maintainer | the memory index | Cross-session pointers and standing lessons. |

If a fact appears in two of these layers, one of them is wrong. This is what
keeps "three audiences" from meaning three documentation surfaces to maintain.

### 1. Fix the two bounded-buffer defects first


The two P0 items in finding 9 are API and memory-safety defects, not
maintainability preferences. Do them first, as one small change each, before the
ownership work moves any of the surrounding code.

- Give the candidate pool a capacity and make `add_cand` check it, at all four
  `collect_home_candidates` call sites. The present safety argument is that at
  most six of the ten proposal paths can fire for one vreg. Nobody has written
  that down and no assertion checks it.
- Make `ir_op_uses` report a count its callers can iterate safely, and fix the
  one caller that needs the true count.

Each fix carries a regression test that fails against the unfixed code. Neither
fix may change emitted code: both must be byte-identical across the validation
matrix.

### 2. Sweep the gates

`ir_alloc.c`, `ir_lower.c`, `ir_opt.c`, `ir_slots.c`, the lowering includes, and
`ast_opt.c` hold 119 distinct environment gates: 81 behaviour gates and 38
diagnostics, each with its own `getenv` and static cache. This is the largest
single contributor to orientation cost, because no path can be reasoned about
until the reader has worked out which switches govern it.

Walk the list once and give every gate one of four fates, using the vocabulary
in `CONTEXT.md`:

- A **probe** whose question is answered is deleted: helper, `getenv`, call site,
  probe-only comments, and duplicate tallies. Save it as a patch file beside its
  handover first, as `PAIRPROBE.patch.txt` already does. Finding 8a names seven
  that qualify today.
- A **parked feature** is deleted unless it earns an index row. The row must name
  a status, a date, and the next experiment it serves. Deleting one is
  byte-identical on the default path: it removes a parked behaviour, not a
  shipped one.
- An **opt-out** keeps its capability but loses its implementation. Replace the
  eighteen bespoke switches with one parsed list (`IR_OFF=deadstore,jr`) held in
  the `BackendRenderOptions` snapshot, so bisecting still means flipping one
  thing, and the live set can be printed by a diagnostic run.
- A **verifier** is never swept. It answers no question and has no expiry.

Batch the deletions by area and run one validation matrix per batch. Nothing in
this step may change the default path's output.

Acceptance criteria:

- Every surviving gate has an index row, and every deleted one has either a
  patch file or an ADR.
- One opt-out mechanism remains; `getenv` reads in the back end fall well below
  the present 142.
- The whole sweep is byte-identical on the default path across the matrix.

### 3. Write DESIGN_INDEX.md as the output of the sweep


Add `src/80cc/DESIGN_INDEX.md`. Make it the only file that states the current
next action. The rows it contains are the ones the gate sweep decided to keep:
this file is written as the sweep's output, so its first version is short by
construction. Give each surviving item an owner area, status, last checked
revision, evidence link, and successor or retirement link.

Use these statuses: `active`, `parked`, `refuted`, `shipped`, and `historical`.
Keep ADRs for accepted architecture and refutations only. Keep measurements in
`BENCH_MATRIX.txt` and commit messages. The document pass in step 4 acts on this
index; nothing is moved or deleted before it exists.

List per-function frame-mode selection as an isolated active optimisation. It
has a measured size opportunity, but it must not share a change with allocator
or lowerer cleanup. This keeps its byte and tick trade-off measurable.

State the dependency between the two tracks explicitly. `BackendRenderOptions`
exists to stop a frame trial from changing `c_framepointer_is_ix` globally, so
that extraction is a prerequisite for per-function frame-mode selection, not a
competitor to it. Do that one extraction first, land the optimisation on top of
it as its own change, and keep the rest of the cleanup off that critical path.

### 4. Promote the durable content, archive the rest

93 of the 95 top-level documents in `src/80cc` are untracked. Only `CONTEXT.md`
and `DEBUG_LOCALS_PLAN.md` are in git, alongside the 18 ADRs. There is therefore
no history to fall back on: a stray `git clean -fd` already destroys the whole
design record, and deletion is irreversible. (`src/80cc/context.md` looks like
an untracked duplicate of `CONTEXT.md`, but the workspace is mounted from a
case-insensitive host filesystem: they are one file under two spellings. The
hazard is a reference to the lowercase form, which breaks on a case-sensitive
filesystem, not a duplicate to delete.)

The ADR README already sets the policy: ADRs hold durable design, plans hold
transient working notes, and figures never appear in an ADR. The 93 files hold
four kinds of content, and only two of them are durable:

- **Architectural decisions** — promote to an ADR where one does not already
  cover them.
- **Refutations** — a lever measured and rejected. Durable, and currently
  homeless: this is why refuted work is scattered across handovers and
  duplicated into the maintainer's memory. Widen the ADR status set to
  `Accepted` / `Superseded` / `Proposed` / `Rejected`, and write each refuted
  lever as a short `Rejected` ADR: what was tried, why it fails, what would have
  to change to reopen it. No figures; link `BENCH_MATRIX.txt`.
- **Measurements** — stay in `BENCH_MATRIX.txt` and commit messages.
- **Work-in-progress state** — handovers and `START HERE` markers. These are
  replaced by the index and deleted when their work lands.

Expect roughly 25 to 35 ADRs in total. Promoting all 93 would dilute the one
layer that currently works.

Order matters, because deletion is irreversible here:

1. Commit all 93 files as-is on a throwaway branch (`80cc-docs-archive`), never
   merged. This costs one commit nobody has to read and makes every later
   deletion reversible.
2. Promote the decisions and refutations.
3. Delete the residue from the working tree in one reviewed pass.

The archive commit lands *before* any deletion, not alongside it.

Acceptance criteria:

- The tracked set is the ADRs, `CONTEXT.md`, and `DESIGN_INDEX.md`.
- No `START HERE` survives outside the index.
- Root `CLAUDE.md` points at the tracked `CONTEXT.md`.

### 5. Make allocation output one explicit plan


Create an allocation-result type owned by `ir_alloc`. It must contain a vreg's
home, resident window, backing requirement, and home mode. The initial storage
can wrap the current arrays. Call it `HomePlan` or another single stable name.

Add accessors for these questions:

- `home_at(v, op_index)` for a lowering point.
- `home_assigned(v)` for whole-function scans.
- `home_requires_slot(v)` for `ir_slots`.
- `home_mode(v)` for call-split, byte-home, and transient behaviour.

Move the E/D, word-DE, call-split, parameter, and no-slot backing decisions into
`home_requires_slot`. Then make `ir_slots.c` consume that one predicate.

Move index-half selection out of `ir_lower.c`. If its eligibility needs lowering
facts, expose those facts as an analysis query. Do not let the lowerer write the
allocation result.

Replace the mutable pre-pick snapshot and fixed global veto list with an
allocation context passed through a retry. A lowerer rejection must contain a
typed reason and a vreg number. The driver can then re-run allocation with that
vreg forbidden. The lowerer must never restore or edit the previous plan.

Acceptance criteria:

- No code outside allocation creates, changes, or restores a home assignment.
  The named witnesses are `ir_lower.c:6222`, `:7100`, `:7105`, and the prepick
  restore at `:6893`; all four must be gone, not wrapped.
- `ir_slots.c` decides no backing requirement of its own. It keeps its own
  slot-placement decisions: finding 7 classifies slot layout as a separate late
  term, so "no special cases" here means backing, not placement.
- A failed home causes a typed allocation retry or a loud error.
- The no-change path remains byte-identical.
- The change is net line-negative in `ir_lower.c`, because the second owner is
  deleted rather than redirected.

The target contracts are deliberately small:

| Boundary | Producer | Consumer | Contract |
| --- | --- | --- | --- |
| Allocation facts | analysis plus declarative lowering facts | candidate generators and cost ledger | Immutable per-function facts: liveness, calls, access forms, clobbers, legal resident windows. |
| Home claims | arbiter and specialised packers | one resolver | A claim is `(vreg, physical home, window, backing, mode, cost evidence)`. A packer may propose or displace a claim, but must not write a final array directly. |
| Home plan | resolver in `ir_alloc` only | lowering, slots, verifiers | One final plan answers point residency, whole-function assignment, backing, and mode. It replaces the parallel `vreg_to_phys`, `home_lo`, `home_hi`, and decision flags as the public contract. |
| Lowering feedback | lowerer | allocation driver | A lowerer can return `unrealisable(vreg, reason)` from a dry feasibility check. The driver retries allocation from a clean plan; lowering never restores or mutates allocation state. |

`ir_bc_pack`, the IY packers, stack parking, and call splitting remain
specialised claim producers. This preserves their useful Z80-specific shapes
while removing their accidental dependence on pass order and raw array writes.
Initially the resolver can preserve the present order exactly; the contract
change is about ownership and observability, not a new allocator.

### 6. Complete the home query boundary


Make the point query a pure helper that accepts an explicit flat op index. Keep
a small lowerer wrapper that obtains the current index from `LowerState`.
This lets allocation, slot assignment, verifiers, and tests ask the same
question without using lowerer-global state.

Audit every direct `vreg_to_phys` read. Mark it as either an assignment scan or
a point query. Convert every point query to `home_at`.

Make the audit stick mechanically: rename the raw array, or move it behind the
plan structure, so that every remaining direct read is a compile error until it
is re-declared as a whole-function scan. A comment or a review rule cannot
prevent the next point decision from bypassing the interval bounds; a rename
can. This is the only part of step 6 that changes the future cost of the file.

Keep one resident window per vreg in this step. Rename the implementation
comments to say this clearly. Add a list-based interval representation only when
a measured feature needs two disjoint windows for the same vreg. At that point,
extend the same accessor instead of adding another side table.

Acceptance criteria:

- Call-split accesses outside their window always use a backing slot.
- The interval verifier reads the same accessor as lowering.
- No point query can silently ignore `home_lo` and `home_hi`.

### 7. Share lowering capability facts with allocation


Define a small, declarative lowering-fact interface. For each relevant op, it
must report the registers that the selected lowering may preserve, clobber, or
need as fixed operands. Start with the DE-home forms only.

Use this interface in both the DE region proof and the matching emitter guard.
Retire paired mirror predicates only after the shared fact produces identical
choices. Keep `op_clobbers` as the conservative effect contract. Keep the
emitted-assembly verifier until the declarative facts have covered all current
DE-home forms.

Do not attempt to describe all instruction selection at once. Add one fact family
per emitter family. The first targets are the indexed compare and the clean-store
paths because each already has an explicit proof/emitter pair.

This step needs its own stopping rule, because "one family at a time" has no
natural end and would otherwise keep the effort open indefinitely. Do exactly
the two families named above, then stop and re-assess against the four
invariants. Further families are justified by a specific mirror-predicate defect,
not by completeness.

Acceptance criteria:

- A DE-clean proof calls shared lowering facts, not a copied emitter condition.
- `IR_CLOB_VERIFY` and the interval verifier report no new failures.
- Each migrated form has a positive and negative regression case.

## After: the resumed optimisation programme

These steps are not part of the simplification. They change allocator policy and
need bench evidence, so they belong to the optimisation work that resumes once
invariants 2 and 3 hold. They are kept here because the analysis that motivates
them is in findings 5 and 7, and because the new probe rule governs them: a probe
states the one decision it answers and is deleted when answered.

### A1. Measure realised cost before changing allocator policy


Add an inert, per-candidate-and-home cost probe before any new resolver policy.
Do not score a vreg by its best allowed class. Score each legal `(vreg, home)`
claim, because the chosen home defines the emitted sequence.

For each claim, report these terms separately:

- Access cost for the actual lowering form at each use and definition. Record
  direct dereference, copy-to-HL, copy-to-DE, in-place step, and destructive
  swap as distinct forms.
- Entry reload and exit-store cost for the resident window.
- Register-transfer cost, such as BC-to-HL or index-to-HL materialisation.
- Call-save and argument-setup cost across the candidate window.
- Frame-mode and CPU-specific addressing cost.
- Opportunity cost for each displaced overlapping claim.

Include index-register save and restore at every real return edge. Include the
slot store and reload that occur only after an HL-clobbering gap. This makes the
current IY open-cost and HL-pressure exceptions normal ledger entries.

Weight execution costs with the existing loop and trip-count data. Keep static
bytes and dynamic ticks as separate values. A resolver can use a stable policy
only when those values remain tied after all known terms apply.

Use the probe to explain one wrong selection before changing a weight. Start
with the known index setup, IY return-edge, DE-copy, and BC call cases. Add a
missing term only when it predicts the winning choice across more than one
function and CPU class. Do not replace the model with one global fitted number.

Make the lowering-fact interface from step 7 provide the access form. The
allocator must not infer it again from a vreg kind or a register class. Keep the
legacy special rule as a comparison oracle until the new claim score matches it.

Bound that duality. Two cost models in the shipping path is the exact pattern
finding 8 forbids, so an oracle is deleted together with the repair it validated,
in the same change. If the ledger has not replaced any repair after the first
two attempts, the ledger is refuted: record the measurements and delete it,
rather than keeping a second model that explains nothing.

Acceptance criteria:

- Each reported tie identifies the term that remains unknown or equal.
- A changed term improves the selected claim on its witnesses.
- The change does not hide byte regressions behind tick gains, or the reverse.
- The selected claim and its score always name the same physical home.

### A2. Keep the arbiter; make its cost evidence uniform


Keep `collect_home_candidates` and `unified_arbitrate` as the one generator and
selector for region homes. Add the realised-cost ledger from step A1 as candidate
evidence at that boundary. A ledger entry names one vreg, one physical home, and
one resident window, but it is not a new placement engine.

Migrate one cost repair at a time. For each one, preserve the current condition
as a comparison oracle, show that the new ledger picks the same winner on its
existing witnesses, then remove only that repair. Keep byte and tick values
separate. State every remaining cross-class ordering rule as policy and support
it with a measurement.

Leave BC packing, IY packing, stack parks, and call splitting in their present
passes. Revisit one only if a probe shows that a region candidate and that pass
compete for the same physical home over the same interval and a unified decision
improves real code. General graph colouring and live-range splitting remain out
of scope; the recorded range probes did not justify either.

Acceptance criteria:

- `collect_home_candidates` remains the only generator for region-home candidates.
- `unified_arbitrate` remains the only selector for those candidates.
- A migrated repair reduces a special-case branch without changing gate-off output.
- No packing or call-split pass moves without a measured overlap witness.

### A3. Retire state only after the replacement proves itself


After each proven scoring transition, delete only the retired repair, its flags,
and its duplicate measurement code. Do not delete a packing or call-split pass
because it resembles region selection. Update ADR 0017 only when a default-on
architectural invariant changes. Do not update it for an experiment.

Use the document index to point historical plans at the replacement. Preserve
the measurements and refutations. They stop repeated work and remain useful when
the cost model changes.

The documents need the same discipline as the code, for the same reason: 95
top-level files with 17 competing next actions cost a reader more than the
source does. Retiring a plan does not mean deleting it. Give it a `refuted`,
`shipped`, or `historical` status and a successor link, and remove its
`START HERE`. The target is one live next action in the index and none
anywhere else.

## Validation for every behaviour change

Use a baseline compiler built in a separate directory. Compare gate-off output
with that baseline after filtering the compile-time stamp. Do not swap binaries
inside a corpus loop.

"Byte-identical" needs a named matrix, because these files hold many gates and a
refactor can preserve the default path while moving a gated one. It means: the
whole bench corpus, across the eleven CPU variants, in both SP and frame-pointer
mode, at default gate settings; plus a gate-off run for every gate the change
touches. A change that is byte-identical only at default settings must say so.

Run `long_ir` in both SP and frame-pointer modes. Run the cross-CPU size scan,
the relevant tick scan, and the real-file gates in both modes. Run the home,
clobber, park, and index verifiers for changes that affect their model.

Add a reduced `long_ir` case for every new transition or rejection path. First
run the test against a deliberately broken form. An unchanged gate-on/gate-off
listing means the test does not cover the change.

Treat a result as ready only when it has all of these properties:

- The opt-out is byte-identical to the baseline.
- The requested mode has no correctness regression.
- The size report names every larger cell.
- The tick report names every slower valid-tick cell.
- The document index records the decision and its evidence.

## Deletion balance

The plan is judged on whether the back end gets smaller and easier to follow,
so each change records two numbers in its commit evidence: net lines, and net
owners removed for the state it touched.

| Step | What is deleted | What is added |
| --- | --- | --- |
| 1 | Two unchecked-bound hazards. | Two checks and two tests. |
| 2 | Answered probes, undefended parked features, and 18 bespoke opt-out mechanisms; `getenv` reads fall well below the present 142. | One parsed opt-out list in the options snapshot, and patch files beside the handovers. |
| 3 | Nothing yet. The index is what makes steps 2 and 4 decidable. | One index file. |
| 4 | Up to 93 untracked documents. | Roughly 10 to 20 new ADRs, one archive branch. |
| 5 | The lowerer's four writes into allocation state, the prepick restore, the global veto list, and the backing special cases in `ir_slots.c`. | One plan type with four accessors. |
| 6 | Every direct point read of the parallel home arrays. | One pure point query and a thin lowerer wrapper. |
| 7 | Paired mirror predicates, one emitter family at a time. | One declarative fact family per emitter family. |
| A1 | Nothing yet; the ledger is inert while it is being validated. | One probe with an explicit retirement condition. |
| A2 | One cost repair and its flag per migration, with its oracle. | Ledger entries as candidate evidence. |

Steps 5 to 7 are only worth doing if the old owner is deleted in the same
change. If a step ends with both the new interface and the old state in the
tree, it has made the codebase larger and harder to read, which is the opposite
of the stated goal. Revert it rather than leaving it half-migrated.

## Stop conditions

Do not fold `ir_bc_pack`, the IY packers, stack parking, or call splitting into
the arbiter without a measured case that needs it. They solve different problems
after region selection, and merging them would make the allocator larger, not
smaller.

Stop a migration if it only adds an abstraction, preserves all old state, and
does not remove a second owner or unlock a measured case.

No optimisation work starts until invariants 2 and 3 hold. After that, a new
probe arrives with its index row and the one decision it will answer, and is
deleted when that decision is reached. Stop general ranging
if a fresh traffic probe again shows only low-use candidates. Keep a small,
isolated optimisation separate when it has a better measured return than the
next simplification step.
