# AGENTS.md — 80cc backend working rules

Backend-specific rules. Read the repo-root `AGENTS.md` first (build/copy-to-bin,
validation, commit hygiene, copt edges). Vocabulary is in `context.md`. This file is
the *how to work on 80cc* checklist; the *what/why* of each arc is in the untracked
`*_PLAN.md` + agent memory.

## Pipeline (where a change belongs)

```
frontend (ir_build.c) → IR
  → ir_alloc.c        register/spill assignment (vreg_to_phys); proposers + arbiter
  → ir_slots.c        ir_assign_slots: frame slots for SPILL vregs → f->frame_size
  → ir_lower.c (+ *.inc.c)  two-pass render to asm; the belief cache (L.rs.*)
  → copt (lib/80cc_rules.1)  post-render peephole
```

- **Register vs slot** is decided in `ir_alloc.c`. Which values get a frame slot is
  `ir_slots.c` (only `IR_PR_SPILL` vregs, minus `IR_VREG_NO_SLOT`).
- **The lowerer never asks for a scratch register** — it has fixed per-op register
  roles (Bus = HL/A; Parking = BC/DE/IX/IY) and reads homes from the allocator. See
  `context.md`.
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
  mid-loop.
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
  - `emu.c` (magnetic scrolls, the endian/char-heavy real file): from
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

## Gate mechanisms

- Opt-out (default-on, escape hatch): one registry, two front doors —
  `--opt-disable=<name>` for a user and `IR_OFF=<name>` for a measurement (the
  corpus scans can only pass env vars). Both take a comma list and accept `all`.
  Read it as `!opt_disabled("my-opt")`; never add a private `getenv` for an
  opt-out. The older `IR_NO_*` and `IR_<FEATURE>=0` forms are gone: their
  mapping is `IR_NO_FOO_BAR` → `foo-bar`, `IR_A_CARRY` → `a-carry`.
- Opt-in (experimental default-off): an `IR_*` env checked via `getenv` (cache it in a
  `static int = -1` so it's read once). Example live gate: `IR_LONG_DEBC`.
- Inert probes/verifiers: env-gated, zero codegen change, default byte-identical. The
  proven pattern for a risky arc is **verifier-first** — land an inert measurement
  (e.g. `IR_REC_VERIFY`, the recoverability verifier), run the corpus, confirm the
  model holds, *then* change codegen.

## Standing arcs (state — detail in the PLAN docs / memory)

- **DE:BC residency** (`IR_LONG_DEBC`, opt-in) — make DE:BC the canonical 32-bit layout,
  delete the DEHL↔BC shuffle. Landed: consumer conversions, cross-BB carry, PR_DEBC
  home, B2 (slotless fastcall-long param), frameless-fastcall, gen_add/sub → DE:BC,
  destination-aware chooser. **PARKED** (maintainer decision): only ~−42B on emu.c; the
  real gap is elsewhere. Stays gated + byte-identical-off. `LONG_DEBC_RESIDENCY_PLAN.md`.
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
