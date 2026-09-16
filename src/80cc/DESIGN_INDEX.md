# 80cc design index

The only file that states the current next action. Everything else in this
directory is either durable (`adr/`), a measurement (`../../test/suites/BENCH_MATRIX.txt`),
or historical.

Last swept: 2026-09-16. Keep it short: when a section stops describing what is
live, it belongs in `adr/` or in git history, not here.

## Next action

**Last swept 2026-09-16.** The simplification is finished, the residency arc is
closed, and the documentation backlog is cleared. Vein 1 below paid again —
a Rabbit store-reload fold, ADR 0075, **−138 B / −0.105 %, nothing larger** —
and left **one live question**, below. What follows is the handover.

### The live question: listbench, and the three cures that failed

Inlining Rabbit's multiply (ADR 0075, opt-in `IR_RABBIT_MUL=1`) measures
**−721 B and −1.568 %** and would ship but for listbench, which loses
**+10..13 %** on every Rabbit in both frame modes.

**The diagnosis is solid and the cures are all refuted — do not re-run them.**
Removing the call makes the function call-free, `idx2_home_available()` then
admits the `RC_DE_ACC` pool, and that pool takes the best IY candidate
(`idxben=251`) before `ir_iy_reduction_pack` runs; the pack skips it and settles
for `idxben=46`. DE cannot hold a whole-function value, so it spills anyway.
`IR_OFF=word-resident` restores the original pick, which is the proof.

Three fixes were built and measured. All three failed, and **two of them only
after measuring as large size wins** — see the 16/9 sections of
`BENCH_MATRIX.txt`:

| | why it failed |
|---|---|
| `iy-yield-idx2` (fp: idx2 *is* IY) | **size**: −1415 B against −1807 B without it, `recordbench fp` +80..98 on five CPUs. `idx_ben` is the same UNIT for both candidates but a different MODEL — plain index home vs `add iy,de` accumulation |
| `iy-late-home` (let the pack's home survive the word-home revert) | **correctness**: `long_ir` sp 718/727. The pre-pick snapshot can already hold an IY home for another vreg, so the revert restores two owners of IY. The whole-array memcpy restores a *consistent* plan — that is its purpose |
| `de-yield-iy` alone | **correctness**: `long_ir` sp 772/774, and it does not fix listbench without the one above |

**The prerequisite for any future attempt**: the IY reduction pack's gain has no
number comparable to `idx_ben`. Produce one first. And treat "a late pass keeps
its decision across the word-home revert" as unsound by construction.

### The four veins worth digging, in order

**1. Finish the CPU sweep. It has now paid twice, and it is still the cheapest
thing here.** Diff each CPU's declared instruction set against what the lowerer
emits. Do it from `src/z80asm/dev/cpu/opcodes.dat` — the authoritative
asm/CPU/synth table — against a full-corpus asm dump per CPU, *not* from the
`CPU_HAS_*` macros, which cover only a fraction of each ISA. Beware the Intel
spellings in that table: `ldsi` and `ld de,sp+n` are separate rows for the same
opcode, so a mnemonic-level diff reports shipped instructions as un-mined.

Found so far: **LDSI on 8085** (ADR 0039, −366 B / −0.95 %) and a **Rabbit
store-reload fold** (ADR 0075, −138 B / −0.105 %, 0 larger).

**Size a find before believing it.** The second started as "Rabbit never emits
its `mul`", which was false — `l_mult` on Rabbit *is* `ld bc,hl; mul; ld hl,bc;
ret`, and the comment that looked like a bug was correct. **Read the helper the
call actually reaches, on that CPU, before concluding an instruction is
unused.** What was really wrong was cheaper and more general: the call is an
opaque clobber, so the product went through a frame slot and was read straight
back, and the `#R2`/`#G1`/`#S1` fold family had no member matching Rabbit's
one-instruction `ld (sp+N),hl`. **Check that family for other gaps** — it is
per-addressing-form, so every CPU with its own slot spelling needs its own.

Swept and clean: **vm1** (all four `CPU_HAS_*` consulted), **gbz80** (already
emits its specials heavily), **rabbit**. Left, with corpus sizings:

| | |
|---|---|
| ez80 `lea hl,ix+d` | 196 fp-mode `ld hl,N; add hl,sp` pairs remain; 3 bytes against 4. Already used at the two `emit_*_slot_addr` sites *only* |
| 8085 `ld de,hl+n` (LDHI) | 64 `ld de,N; add hl,de` sites; 2 bytes against 4 — LDSI's sibling, same shape as ADR 0039 |
| z80n `add hl,a` / `add de,a` / `add bc,a` | 48 byte-widen-then-add pairs; 2 bytes against 5. Also `add hl,nn` (4 bytes, and it preserves DE) |
| z180 / ez80 `tst` | a flag-only `and` that preserves A — not yet sized |
| kc160 `div hl,a` / `div dehl,bc` / `divs` | hardware divide, never emitted; only 6 helper-call sites in this corpus, so size it on a real file before building |

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
* **`make -j` on `long_ir` garbles the log.** Concurrent writes interleave
  mid-line, so the summed run count is nondeterministic and *under*-counts: 712
  and 728 on two runs of an identical 376-target binary set, against a true 739
  serially. Take the pass count from a **serial** run or it is fiction.
* **A failed compile in the size scan reports its neighbour's size.** The scan
  writes every object to one `/tmp` path, so a compile that fails leaves the
  previous file's `.o` in place. That is what "structbench 375 -> 750" was: not a
  regression, a stale object. A doubled figure is a symptom, not a discovery.
* **copt is invisible to every dump you have.** The compiler's own asm can be
  correct at every stage and `zcc -a` still be wrong — that is how ADR 0075's
  `pop bc` went missing. Diff `z88dk-80cc` direct output against `zcc -a` before
  opening a backend pass. This trap was already written down and still cost an
  hour.
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
the other four are KR580VM1-only. That survey is **not** the sweep — the macros
cover a fraction of each ISA, and ADR 0075's `mul` was not among them. The sweep
is vein 1 above: `opcodes.dat` against a corpus asm dump.

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

One registry of 118 names, each described in `OPTIONS.md`. Two front doors:

    --opt-disable=name,name     a compiler flag, for a user
    IR_OFF=name,name            the same registry, for a measurement

Read it as `!opt_disabled("my-opt")`; never add a private `getenv` for an
opt-out. `scripts/check_options.sh` fails if a name is undocumented or a
documented name no longer exists.

## Surviving gates

59 remain. A gate needs a row here or it is deleted.

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

### Parked, measured, waiting on one answer

| Gate | What it does | Flip it on when |
| --- | --- | --- |
| `IR_RABBIT_MUL` | inlines Rabbit's `mul` instead of calling `l_mult`: −721 B, −1.568 %, but listbench +10..13 % (ADR 0075) | the call-free IY re-pick above is understood |

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
