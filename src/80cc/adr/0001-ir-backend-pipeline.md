# ADR 0001 — IR-based back end and the compilation pipeline

Status: Accepted

## Context

z88dk's original small-C compiler (sccz80) emits z80 directly from the AST while
parsing — fast, but it leaves little room for machine-independent analysis or
optimisation, and retargeting to other 8-bit CPUs means threading target
conditionals through the whole emitter. 80cc was written to get a real
optimising, retargetable back end while reusing the small-C front end.

## Decision

Compile through a typed **intermediate representation** with a clear pipeline:

```
AST  →  ir_build  →  IR  →  ir_analysis  →  ir_alloc  →  ir_lower  →  asm
```

- **ir_build** (`ir_build.c`) lowers the front end's AST into IR: a `Func` of
  basic blocks (`BB`), each a list of three-address `Op`s over **virtual
  registers** (`VReg`). Ops are close to machine level (loads/stores, ALU,
  compares, branches, calls) but target-independent. See `ir.h` / `IR.md`.
- **ir_analysis** (`ir_analysis.c`) computes liveness: per-BB `live_in`/
  `live_out`, per-op live sets (`live_in_per_op`), and per-vreg `LiveRange`
  `[start,end]` intervals in a flattened (BB-id-order) op-index space. These are
  the substrate the allocator and lowerer reason over.
- **ir_alloc** (`ir_alloc.c`) assigns each vreg a **physical home** (a register
  or a frame slot) — see ADR 0002/0003. It only *decides*; it emits nothing.
- **ir_lower** (`ir_lower.c` + the `ir_lower_*.inc.c` units) walks the IR and
  emits target assembly, consulting the allocation. Machine specifics (CPU
  quirks, addressing, calling convention, frame layout) live here.

The IR layer is deliberately dependency-light: `ir.h` includes only
`ir_kind.h` (the shared type-kind enum), not the full front-end `ccdefs.h`, so
`ir_selftest` and the analysis/alloc layers link without the front end.

## Consequences

- **Retargeting** is concentrated in ir_lower (per-CPU macros `IS_Z80N()`,
  `c_cpu == CPU_Z180`, …) rather than smeared across parsing.
- **Optimisation** (IVSR/strength reduction, LICM, CSE, peephole, residency) has
  a stable IR + liveness to work on (`ir_opt.c`, `ast_opt.c`).
- **A hard split** between *decide* (ir_alloc) and *emit* (ir_lower) is the
  backbone of the residency design: the allocator records `vreg_to_phys[]`; the
  lowerer must faithfully realise it. The soundness contract between the two is
  the subject of ADR 0004.
- The front end is reused as-is; 80cc is a back end, not a new compiler.
