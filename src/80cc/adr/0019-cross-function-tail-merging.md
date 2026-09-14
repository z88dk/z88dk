# ADR 0019 — Cross-function tail merging

Status: Rejected (2026-09-12)

Relates to ADR 0013 (peephole / assembly-text layer). The **per-function** tail
merging pass is unaffected by this and remains shipped.

## Context

Tail merging replaces the duplicated tail of two code paths with a jump to one
copy. 80cc does this per function. Widening it to the whole module measures
about a third better on the corpus, because epilogues repeat across functions.
The same idea appears in the form of a shared `__sdcc_leave_ix`-style epilogue
helper that every function jumps to.

## Decision

Do not merge tails across function boundaries, and do not add a shared epilogue
helper. The reason is correctness, not value.

The code section is chosen **per function**: `declparse.c` switches to
`c_home_section` or `c_code_section` per function, `#pragma codeseg` can change
it mid-file, and `--codeseg` sets it globally. Two functions in one module can
therefore land in different sections, and those sections can be placed in
different **banks**. A jump from one function's body into another's is then a
real miscompile on a banked target.

The same argument rules out anything that makes one function's emitted code
depend on another function's body. `__naked` and standalone functions, and
zcc's mixing of several compilers in one link, all assume a function is
self-contained.

The per-function pass is safe and was checked against this: a function body can
contain a section switch of its own (a local `static` emits its rodata inline
and switches back), but all of one function's *code* stays in one section, and
the pass already refuses to let a merged run span a `SECTION` directive.

## Reopening

Only with a version that proves both tails are in the same section *and* in
functions with the same banking attributes. That removes most of the value for
a large amount of new machinery, which is why it was not built.
