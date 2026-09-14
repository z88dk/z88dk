# ADR 0031 — A stepped pointer parameter may live in BC

Status: Accepted (2026-09-14, promoted from opt-in)

Relates to ADR 0003 (register residency) and ADR 0012 (frame-pointer default).

## Context

A walking-pointer parameter — `const char *a` stepped by one `inc` inside a
loop — is the shape at the heart of `strcmp`, `strlen` and every scan loop. The
BC candidate rule refused it because a parameter is normally `write_count == 0`,
and stepping writes it.

Relaxing that rule lets the pointer ride BC and the loop read through `ld a,(bc)`
instead of reloading the pointer from its slot each iteration.

Two conditions make it sound:

- **call-free function only.** A call evicts BC, and the reload would restore it
  from the caller's slot — which is stale once the pointer has stepped.
- **a single in-place `inc`/`dec`**, lowered as `inc bc`, so BC stays coherent
  across the step rather than being written back and re-read.

## History, and why it stayed off for two months

It landed **off by default** in July 2026 as a deliberate stepping stone, with
the author's note: *"kept opt-in until proven (checksum self-checks)"*. A first
re-measurement found it worth about 37 bytes, all of it in one benchmark
function, and it was left parked as failing the one-bench rule.

A full regression run in August then found it **broken in frame-pointer mode**:
the `looppr` suite case ran 293x over budget until the watchdog killed it, and
the very function the gate optimises miscompiled. Crucially, the real-file
checks — `emu.c` and `enigma` — **passed in both modes**, because neither
exercises the shape. Only the suite caught it.

The root cause was not this feature. `frameless_ok` accepted a function as
frameless when every parameter was homed in BC or DE, and **"homed in DE" does
not mean "never accessed in memory"**: DE is the lowerer's `ex de,hl` scratch,
so a DE-homed parameter is evicted and reloaded from its slot routinely — and
for a parameter in place that slot is the *caller's* frame at `(ix+d)`, which a
frameless function has no IX to reach. The gate only made an existing landmine
reachable. It was fixed by narrowing `frameless_ok` to accept only a
whole-function BC parameter home.

## Decision

Default-on, with `--opt-disable=bc-step-param` / `IR_OFF=bc-step-param` as the
opt-out, byte-identical to the compiler before the flip.

The evidence, measured after the `frameless_ok` fix:

- **Size**: 30 benchmarks x 12 CPU variants x both frame modes, 720 cells —
  **−514 bytes, 24 cells smaller, no cell larger.**
- **Ticks**: 11 CPU variants x both frame modes, 660 cells — **−0.06 % overall,
  22 cells faster, no cell slower, no new failures.** The gain concentrates in
  string scanning (about 4.5 % on `strbench`), which is the shape it targets.
- The two historical failures are re-run and healthy: `looppr` in fp is back to
  its normal tick count, and `strbench` passes its checksum in both modes.

The earlier "worth one function" verdict came from a single-CPU measurement.
Across the twelve variants the same change is −514 bytes, because the reload it
removes costs more on the CPUs with dearer slot access.

## Consequences

The shape stays narrow by construction: pointer parameter, exactly one in-place
step, call-free function. Widening any of those three conditions re-opens the
stale-slot reload this ADR's conditions exist to prevent, and would need its own
regression run — a real-file spot check will not catch it.
