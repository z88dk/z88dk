# 80cc design index

The only file that states the current next action. Everything else in this
directory is either durable (`adr/`), a measurement (`../../test/suites/BENCH_MATRIX.txt`),
or historical.

Last swept: 2026-09-18. Keep it short: when a section stops describing what is
live, it belongs in `adr/` or in git history, not here.

## Next action

**Check BC liveness at direct calls against `__preserves_regs(b,c)`.** The
argument ABI alone currently decides `[bc-call]` liveness. No in-tree callee
honours that modifier yet; establish the rule and its negative cases before
changing the allocator.

**Sizeable, not urgent: embed copt's matching ENGINE inside 80cc, extended
with a liveness precondition fed by 80cc's own backward pass.** `ir_lower.c`'s
backward pass (`b_live`/`c_live`/`d_live`/`e_live`/`f_live`, `drop[]`) now
carries a growing family of small, individually-ADR'd rewrites written as
hand-rolled C blocks matching an exact adjacent-line sequence and a liveness
precondition — `inc-mem`, `de-widen`, `z80n-add-a`, `idx-rmw-de` (ADR 0088)
and others. They read alike: pattern, liveness gate, replacement, opt-out
name — exactly copt's rule shape (pattern → replacement, `%cpu`/`%notcpu`,
`%check`/`%eval`/`%is`/`%not` preconditions) minus a liveness primitive.

Do NOT do this by calling the external `z88dk-copt` binary as a blind post-pass
on assembled text — that was tried once, for the same shape of rewrite
(`gwiden`, ir_lower.c:2167): copt applied it blind (no liveness) and
miscompiled, and it only became safe once it moved into this pass, "the only
place in the pipeline with real per-line liveness." copt runs after 80cc on
raw text shared across sccz80/80cc/sdcc, with no view of frame mode, CPU
dispatch, or 80cc's register-cache state.

The idea worth sizing is narrower and avoids that trap: link `src/copt/copt.c`'s
engine INTO 80cc as a library, not as an external post-pass. `main()`
(copt.c:915-967) is thin CLI glue — argv parsing, `init()` loading rule files
into a global rule list, `getlst()` reading stdin into a `struct lnode`
doubly-linked line list, `opt()` run per node to quiescence, then print. The
engine itself (`match`/`subst`/`check`/`check_eval`/`opt`) is already
self-contained around that `lnode`/rule-list state — swapping the stdin/argv
glue for an API (`copt_run(rules, lines) -> lines`) is a moderate refactor,
not a rewrite. `struct lnode` (`l_text`, `l_len`, `l_prev`, `l_next`) has no
spare field; add one (e.g. `l_live`, a register-bitmask) — trivial.
The precondition system (`%cpu`/`%notcpu`/`%check`/`%eval`/`%is`/`%not`/
`%notSame`) is already a general per-rule-firing hook; a new `%dead <reg>`
primitive fits that shape directly. 80cc still runs its existing backward
walk exactly once, stamps `l_live` on each line from ITS OWN liveness state
(same source of truth as today, never re-derived by copt), then hands the
annotated buffer to the embedded engine with rules written in copt's real DSL
instead of one-off C blocks per rung.

Two real limits, both already true of the current hand-written rungs: (1) it
only covers the straight-line matches — `bc-flow`/`de-flow` branch-target
fixpoint rungs need CFG dataflow copt's linear multi-pass model doesn't do,
so those stay hand-written regardless; (2) this is a genuine mid-size project
(engine extraction + annotation plumbing + DSL extension for `%dead`), not a
quick win — prototype it on 2-3 existing rungs (`idx-rmw-de`, `inc-mem`,
`de-widen`) before committing further, and gate the prototype through the full
gauntlet the same as any codegen change.

The masked word right-shift rung is accepted for plain Z80. See ADR 0090. The
A-through-CB route is faster in all 10 affected sp/fp cells and has no
compile-only corpus size change; other CB-shift CPUs remain out of scope.

Still open from ADR 0084: `[bc-call]` decides BC liveness at a direct call
from the argument ABI alone; it has not checked `__preserves_regs(b,c)`. No
in-tree callee currently honours that modifier.

### The veins worth digging, in order

**1. The CPU sweep — CLOSED. See ADR 0079 (and 0081 for the row it got
wrong).** The method,
for whoever repeats it on a new CPU: take the mnemonics `opcodes.dat` declares
REAL (`_`, not a synthetic `X`) for that CPU, take the mnemonics a full-corpus
asm dump for that CPU actually emits in both frame modes, subtract — and then
**read the operands**, because the mnemonic diff is blind in both directions.
`add` is emitted as `add hl,de` while `add hl,a` never was; `inc` is emitted as
`inc hl` while `inc (hl)` never was, and that one was worth 606 bytes. Also ask
whether the shipped **code path** uses the instruction, not whether the
**compiler** emits it: `mlt` on z180, `mul` on z80n and `div` on kc160 are all
already inside library helpers.

Swept and settled: **vm1**, **gbz80**, **rabbit**, **8085**, **8080**, **z80**,
**z80n**, **z180**, **ez80**, **kc160**. Emit sites with their own push offset
remain a separate question.

**2. Zero-extension — CLOSED. See ADR 0085.** It was carried here for months as
"the one *consistent* gap against ez80clang", on a per-1000-instruction ratio.
The census that ratio never justified: **166 sites** in bench + real, 442-499
over the whole dump, and the count barely moves with the CPU — so there is no
target where it is the disease. Most sites are already at the z80 encoding
floor: a zero-extended byte pushed as a word argument is `ld l,a; ld h,0;
push hl` and nothing shorter exists. One rung shipped (ADR 0085);
five shapes were sized and refused. **The lesson for the next vein: a
per-instruction ratio against another compiler sizes a DIFFERENCE, not a
RECOVERABLE one.** Count the bytes a rung could actually delete before calling
something the next job.

**3. The commutative swap in addition — CLOSED. See ADR 0089 (and ADR 0072
for the A/B result).** A sound answer is pass-order-dependent: changing the
operand roles changes pass-1 slot reads and therefore the pass-2 store-dead
solution. A dual render is not a useful scalar gate. The emitter remains
unchanged; the measured effects remain −6 % ticks in `md5`, +28 B in
`binary-trees`, and +75 B in `emu.c`.

**4. The indexed read-modify-write address restoration — SHIPPED. See ADR 0093
(supersedes ADR 0088's "no emitter change" call).** The 720-cell final-assembly
census found one complete `histbench` site in 8 CPU/frame cells, 5 bytes per
site; `adv_a.c` and `clisp.c` had no eligible sites, and the broad reader
matches elsewhere were pointer copies or temporaries. ADR 0088 declined to
ship from the census alone; shipped 2026-09-18 as `[idx-rmw-de]`, a 10-line
text match in `ir_lower.c`'s existing backward-liveness pass, gated on B/C/D/E
all dead after. z80/z180/8080 fire (-5 B/site, matching the census); z80n
text-matches the same pattern but the live liveness check correctly declines
(DE proven live after on z80n, dead elsewhere) — the census had counted z80n
as affected, the per-line liveness check is the one that gets believed. See
`BENCH_MATRIX.txt` s7 (2026-09-18) for the dated numbers.

The remaining instruction-selection rungs are not the current action.
`histbench` on Z80 is 32.01 M ticks against xcc `-Of`'s 28.46 M, and
80 % of either run is one basic block. Per iteration 80cc spends **518 cycles
where xcc spends 471**. What looks expensive is not the gap: the x25173
shift/add expansion is identical in both (14 `add hl,hl` + 6 `add hl,rr`), and
**both compilers reload `seed` from its frame slot every iteration** — residency
is not the difference here, so do not open the allocator for this. The 47 cycles
split three ways and one is already had: frame addressing is worth 11, and fp
mode collects it (the same block measures 504 cycles per iteration in fp, which
is the 31.01 M column). The other two are rungs nothing in the tree does yet.

* **A constant right shift of a word, Z80 only — CLOSED. See ADR 0090.**
  The A-through-CB route (`ld a,l; (srl h; rra) × count; ld l,a`) for constant
  counts 2..7 is accepted on plain Z80. It improved all 10 affected sp/fp cells
  in the 60-cell corpus, with no slower cell and 2,140,848 fewer ticks total.
  The full compile-only corpus size was unchanged; other CB-shift CPUs remain
  out of scope until measured.
* **The base address of the read-modify-write — 18 cycles and 5 bytes a site.**
  80cc copies the computed address into BC, rebuilds HL from it after the word
  load, and routes the incremented value back through `ex de,hl`: 13 bytes. HL
  only advanced by one, so a single `dec hl` restores it and the increment can
  stay in DE — `ld e,(hl); inc hl; ld d,(hl); dec hl; inc de; ld (hl),e;
  inc hl; ld (hl),d`, 8 bytes, which is what xcc emits.

The addition model, address-restoration census, and masked word right-shift
rung are recorded in ADRs 0088-0090.

**5. The 8085 K-flag trip counter — SHIPPED. See ADR 0051.** A private,
positive-literal loop counter (`AST_LOOP_COUNTDOWN`, only ever built by the
loop-reversal pass, which already proves it unread and dead after the loop —
no separate shape analysis needed) seeds at N-1 instead of N and its latch
branches on the 8085's K flag (`jp nk`) instead of rebuilding `ld a,h; or l;
jp nz`. `k-trip` opt-out. 8085-only compile-only corpus scan: -156 B over
52/60 cells, 0 larger, 0 build failures, sp and fp identical (8085 has no IX).
`long_ir` 846/846 both frame modes.

### How to work here — the traps that actually bit

* **`long_ir` FIRST, size second.** −1807 B over 720 cells was reported as a 13x
  improvement on the day's shipped work; `long_ir` then came back 718/727. A
  size scan on a compiler that miscompiles is not a weak measurement, it is
  **noise that looks like a result**, and it persuades precisely because it is
  large. Never quote a corpus delta before the correctness gate is green in both
  frame modes.
* **`make && cp && echo BUILT` lies**, and it is worse than it looks. It printed
  BUILT on a failed build and a measurement then ran against a stale binary,
  reporting a plausible `0/0`. Use `if make ...; then ... else echo FAILED; fi`
  — **and run it from the repo root**: `PREFIX=$(pwd)` makes the working
  directory load-bearing, so `make -C src/80cc PREFIX=$(pwd)` from `test/suites`
  fails silently and leaves the old compiler installed. Two rounds of figures
  came from that. **`md5sum bin/z88dk-80cc` before a scan** and compare it to
  the build you think you are measuring; two scans of "identical" configurations
  differing in 59 cells is not scan nondeterminism (the compiler is
  deterministic — 8 runs, identical md5), it is the wrong binary.
* **Gate the call sites, not a shared helper.** `opt_disabled()` placed inside
  `alloc_note_late_home` also disabled the call-split's pre-existing use, so the
  opt-out did not restore any previous compiler — it broke a working fix,
  visible as `histbench` 385 -> 431, *the wrong direction*. An opt-out that does
  not reproduce the old compiler is worse than none, because it is trusted.
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

A survey of all 14 `CPU_HAS_*` macros found five the backend never consults;
the other four are KR580VM1-only. That survey is **not** the sweep — the macros
cover a fraction of each ISA, and ADR 0075's `mul` was not among them. The sweep
is vein 1 above: `opcodes.dat` against a corpus asm dump.

**Give the shipped optimisations ADRs, then trim their comments — DONE.**
34 features documented (ADR 0039-0074), ~240 lines of comment removed, output
byte-identical throughout. Each comment keeps the rule, the gate spelling and any
correctness landmine; the figures live in the ADR.
**48-bit literal range.** `3.0e38` errors in genmath/math48 (`max_exp` 127, about `1.7e38`). sccz80 accepts and wraps. IEEE `--math32` accepts `3.0e38` and saturates larger values to Inf. Do not loosen the 48-bit check.

**Give the shipped default-on optimisations ADRs, then trim their comments.**
Of 115 registry names only about 15 are named in an ADR. Roughly ten features —
`remat-lea`, `dead-store-share`, `trunc-res`, `fclong-carry`, `call-bremat` and
similar — carry their justification, including benchmark figures, in a long
block comment and nowhere else. 26 such blocks hold ~370 lines.

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
| 3. Every surviving gate has a row below, and every row a gate | `scripts/check_gates.sh` |
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

43 remain. A gate needs a row here **and** a row needs a gate. The second
direction had rotted: **14 rows named gates deleted in earlier sweeps**, whose
explanatory comments survived in the source while the `getenv` did not, so the
index promised debugging tools that could not be switched on. Nine real gates
had no row at all. Both are fixed, and `scripts/check_gates.sh` now enforces it
so the drift cannot return silently.

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

These print; they never change emitted code. Each is one to six lines inside a
shipped feature, so they cost nothing to keep and answer "why did it do that".
`IR_HOMEMAP` is the first thing to diff when an allocation decision changes.

### Probes with a live question

| Gate | Question | Retire when |
| --- | --- | --- |
| `IR_ALLOC_PROBE` `IR_FRAMEPROBE` `IR_SHLX_PROBE` | one-line censuses inside shipped passes | on their next edit |
| `IR_BYTEPRESS` `IR_RANGEPROBE` | inert sizings: the byte-pair opportunity by pressure, and the ranging population | they are quoted in an ADR |
| `IR_LIVEPROBE` | liveness census; `=2` gives the verbose form | — |

`IR_RANGEPROBE` carries a warning, not just a number: its 461 was an upper bound
over the **wrong population** — see "do not size an opportunity by counting
values that merely fail to interfere" above.

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
front door, documented under **Opt-outs** below.

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

What survives here is the durable layer: `adr/` (76 records), `CONTEXT.md`
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
