# AGENTS.md — 80cc backend working rules

Backend-specific rules. Read the repo-root `AGENTS.md` first (build/copy-to-bin,
validation, commit hygiene, copt edges). This file is the *how to work on 80cc*
checklist. The rest of the design record:

| File | Holds |
|---|---|
| `DESIGN_INDEX.md` | what is live, and the single next action — **start here**. Live state only; anything durable belongs in `adr/` |
| `adr/` | how the back end works and why, plus what was refused (`Rejected`) |
| `CONTEXT.md` | vocabulary (residency terms, and probe/parked/opt-out/verifier) |
| `OPTIONS.md` | every `--opt-disable` / `IR_OFF` name and what turning it off does |
| `probes-retired/` | source of deleted probes, so a census can be re-run |

The old `*_PLAN.md` / `HANDOVER_*.md` pile is on branch `80cc-docs-archive`
(one commit, never merged) — `git show 80cc-docs-archive:src/80cc/<file>.md`.

## Pipeline (where a change belongs)

```
frontend (ir_build.c) → IR
  → ir_alloc.c        register/spill assignment (vreg_to_phys); proposers + arbiter
  → ir_slots.c        ir_assign_slots: frame slots for SPILL vregs → f->frame_size
  → ir_lower.c (+ *.inc.c)  two-pass render to asm; the belief cache (L.rs.*)
  → copt (lib/80cc_rules.1)  post-render peephole
```

- **Register vs slot** is decided in `ir_alloc.c`, and so is whether a home needs a
  backing slot — `ir_slots.c` asks `ir_home_requires_slot()` and places the slot it
  is told to place. `ir_alloc.c` is the ONLY writer of `vreg_to_phys` / `home_lo` /
  `home_hi`, and the only code that reads them by index; see the ownership section
  below and `scripts/check_ownership.sh`.
- **The lowerer never asks for a scratch register** — it has fixed per-op register
  roles (Bus = HL/A; Parking = BC/DE/IX/IY) and reads homes from the allocator. See
  `CONTEXT.md`.
- `ir_lower*.inc.c` are `#include`d into `ir_lower.c` (one translation unit) — grep
  across all of them.

## Correctness gates specific to 80cc

- `long_ir` 400/400 **sp AND fp** (`FP=1`) — run both; some bugs are fp-only (IX frame)
  or sp-only.
- The suite `make` only checks the **z80 exit code**; other CPUs pass-through even on
  failure. To validate another CPU, run its `.bin` through `z88dk-ticks -m<cpu>`
  yourself. Per-CPU: `-m z80n -b msx`, `-mgbz80`, `-m8080`, `-m8085`, `-mz180`,
  `-mez80_z80`, `-mkc160`; rabbit/z80n `-b msx` **ticks are garbage** → use size/asm-diff.
- **Full-corpus no-abort check** for an ungated default change: compile the bench
  corpus × 9 CPUs × sp/fp (each suite's `make -n COMPILER=80cc <cpu-target>` gives
  the exact `zcc` line; add `-a` to emit asm) and confirm no `require_slot` aborts —
  every asm file produced and non-empty.
- **byte-identical gate-off** for a gated opt: compile the corpus with the gate off,
  diff vs a pre-change reference compiler (filter `C_LINE 0,|^\s*MODULE\s|Module
  compile time`). Build BOTH refs into separate dirs, then diff — don't swap `bin/`
  mid-loop. `scripts/refgen.sh <dir>` captures a reference, `scripts/refcmp.sh
  <dir>` re-runs and diffs it.
- **"byte-identical" needs a named matrix.** These files hold many gates, and a
  refactor can preserve the default path while moving a gated one. It means: the
  whole bench corpus, across every CPU variant, in both sp and fp, at default
  gate settings — plus a gate-off run for each gate the change touches. A change
  that is byte-identical only at default settings must say so.
- A result is **ready** only when all of these hold: the opt-out is
  byte-identical to the baseline; the requested mode has no correctness
  regression; the size report names every larger cell; the tick report names
  every slower valid-tick cell; and `DESIGN_INDEX.md` records the decision and
  its evidence.
- **Real-file behavioural gate** — char-processing real files exercise shapes the
  corpus + long_ir + emu.c don't (byte-fastcall-arg promotion, call-result index-home
  commit across a BB).
  - `enigma` (cheap, run every rebuild) — run BOTH sp and default-fp
    (`-fframe-pointer`): `zcc +test examples/console/enigma.c -DARGC -compiler=80cc
    [-fframe-pointer] -o a.bin && z88dk-ticks a.bin -- hello` → must print `RXSEC`
    in both (miscompile = empty output / ~11k ticks, or a wrong 5-letter string like
    `lXb^c`; correct ~166k ticks). Three longstanding bugs lived here, all
    allocation-sensitive (any added printf masks them): byte-fastcall-arg widen
    (`8cd0132ae2`), call-result index-home commit across a BB (`b6320c9783`), and a
    stale scalar cache after an index-register accumulate (`cc6c6719d1`, fp-only).
  - `emu.c` (magnetic scrolls, the endian/char-heavy real file) — **not checked
    in**, so a fresh clone will not have it; when it is present it is the most
    valuable gate here, because it exercises shapes the corpus lacks entirely
    (several opt-outs move hundreds of bytes on it and nothing on the corpus):
    from
    `support/magnetic/zxnext_magnetic/test`, `zcc +test -clib=z80n emu.c main.c
    -compiler=80cc -o a.bin`, then `printf 'look\nquit\nq\n' | z88dk-ticks -mz80n -w 1
    a.bin | grep -a 'On The Path'` → 2 hits (intro + look). NB `grep -a` (game text has
    high-bit bytes) and capture to a file (the quit-confirm blocks on EOF → a piped
    `timeout` loses the buffer). This is the ONLY gate that caught the #10 slot-coalescing
    miscompile — run it (both modes) every rebuild.

    **`-w 1`, not `-w 60`.** The game finishes its work in well under 400M cycles;
    everything after that is ticks SPINNING on the blocked quit-confirm until the
    budget runs out, and wall time scales linearly with `-w` — 3 s at `-w 1`,
    16 s at `-w 5`, ~3 min at `-w 60`. The whole gate is ~8 s in both modes.
    The run ends at the counter limit by design, so its `Ticks:` number is
    MEANINGLESS here (see the counter-limit trap); the hit COUNT is the gate.

    **Two ways to get a false pass**, both hit while running this:
      - **Wrong cwd.** The game data (`pawn.mag`) is loaded from the working
        directory. From anywhere else it prints "Error opening game file" and
        exits in under a second with 0 hits — fast enough to look like a crash
        rather than a setup error. `cd` to the test directory.
      - **A stale binary.** `zcc ... -o /tmp/emu_fp.bin` that FAILS leaves an
        older binary of that name in place, and the gate then measures a build
        from a previous session and passes. `rm -f` the targets first and check
        both timestamps.

## Allocation ownership (checked)

`ir_alloc.c` is the only code that writes `vreg_to_phys` / `home_lo` / `home_hi`,
and the only code that reads them by index. Everywhere else asks:

| Question | Ask |
|---|---|
| where is v homed AT THIS POINT | `ir_home_at(f, v)` in the lowerer, `ir_home_at_op(f, v, g)` elsewhere |
| is v EVER homed in a register | `ir_home_assigned(f, v)` |
| does v need a frame slot | `ir_home_requires_slot(f, v)` |
| is v's home window ranged | `ir_home_is_ranged(f, v)` |

A point decision that reads the assignment directly ignores the home interval.
That is inert while homes are whole-function and a miscompile once they are not.
Run `src/80cc/scripts/check_ownership.sh` — it fails on a direct write or an indexed
read outside `ir_alloc.c`. A render that cannot realise a home REPORTS it
(`ir_alloc_demote_home`, `ir_alloc_word_home_reject`); it never edits the plan.

## Gate mechanisms

- Opt-out (default-on, escape hatch): one registry, two front doors —
  `--opt-disable=<name>` for a user and `IR_OFF=<name>` for a measurement (the
  corpus scans can only pass env vars). Both take a comma list and accept `all`.
  Read it as `!opt_disabled("my-opt")`; never add a private `getenv` for an
  opt-out. The older `IR_NO_*` and `IR_<FEATURE>=0` forms are gone: their
  mapping is `IR_NO_FOO_BAR` → `foo-bar`, `IR_A_CARRY` → `a-carry`. **Every name
  is described in `OPTIONS.md`, and `scripts/check_options.sh` fails if one is missing or
  stale — add the row in the same commit as the gate.**
- Opt-in (experimental default-off): an `IR_*` env checked via `getenv` (cache it in a
  `static int = -1` so it's read once). Example live gate: `IR_LONG_DEBC`. It must
  state the ONE decision it will answer and earn a row in `DESIGN_INDEX.md`;
  without a row it is deleted at the next sweep. A parked feature that is kept
  gets an ADR with status `Proposed`, not an indefinite gate.
- A NUMERIC knob (`IR_FOO=<N>` setting a constant) cannot be expressed by the
  on/off registry, so it stays a private `getenv` — but it is a parked experiment
  with a dial, and the same index rule applies. When the value is settled, put it
  in the code and delete the dial.
- Inert probes/verifiers: env-gated, zero codegen change, default byte-identical. The
  proven pattern for a risky arc is **verifier-first** — land an inert measurement
  (e.g. `IR_REC_VERIFY`, the recoverability verifier), run the corpus, confirm the
  model holds, *then* change codegen.

## Standing arcs (state — detail in `DESIGN_INDEX.md` and the ADRs)

- **DE:BC residency** (`IR_LONG_DEBC`, opt-in) — make DE:BC the canonical 32-bit layout,
  delete the DEHL↔BC shuffle. Landed: consumer conversions, cross-BB carry, PR_DEBC
  home, B2 (slotless fastcall-long param), frameless-fastcall, gen_add/sub → DE:BC,
  destination-aware chooser. **PARKED** (maintainer decision): only ~−42B on emu.c; the
  real gap is elsewhere. Stays gated + byte-identical-off.
  (`git show 80cc-docs-archive:src/80cc/LONG_DEBC_RESIDENCY_PLAN.md`.)
- **noframe / frameless** — trivial functions were getting spurious frame slots (→ IX
  frame pointer). `no_slot_consumer_safe` / `compute_no_slot_bytes` (ir_lower.c) mark
  A-only byte temps `IR_VREG_NO_SLOT`; `frameless_ok` (Tier-B) skips the IX frame when
  `frame_size==0` and all params are register-homed. Ongoing: **dead frame-slot
  elimination** (a `SPILL` slot the lowerer never actually accesses — served from
  registers/push-pop/ldir — should be dropped; frame shrinks, often to 0). Witnesses:
  `do_cmp`, `save_arg2`, `read_w`'s param frame.
- **endian folds** (copt #285r/#285s/#285t) — `read_l = swap_endian_32(*(type32*)p)`
  folds to a 7-insn direct big-endian byte load; double-swaps collapse. Big wins in the
  endian-saturated `emu.c`. Write-side (`write_l`) is a codegen fold, not clean copt.

## The density picture (why we're here)

The maintainer's blocker: 80cc codegen isn't dense enough to ship. On `emu.c`, 80cc is
**~40% larger than sdcc** — a *systemic* per-function gap (register allocation quality +
frame overhead), not one hotspot. Peepholes/noframe chip at it; the deep prize is
register-allocation density. Always frame a win against the sdcc number, and prefer
levers that generalise over ones that fit one benchmark.

## Fast reference

- Rebuild: `make -C src/80cc && cp src/80cc/z88dk-80cc bin/`
- long_ir: `make -C test/suites/long_ir COMPILER=80cc [FP=1]` → 400/400
- emu.c size (compile-only to a scratch `.o`, read the section size):
  `zcc +test -clib=z80n -compiler=80cc -O2 -c support/magnetic/zxnext_magnetic/test/emu.c -o e.o && z88dk-z80nm e.o | grep -m1 'Section code_compiler:'`
- sdcc baseline: same but `-compiler=sdcc` (default max-allocs)
- test a copt rule: `printf '<asm>\n' | z88dk-copt lib/80cc_rules.1`
- recoverability verifier: `IR_REC_VERIFY=1` (per-fn recovery distribution; 0 violations expected)
