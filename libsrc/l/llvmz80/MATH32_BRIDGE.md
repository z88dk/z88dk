# math32 <-> clang-z80 (ravn/llvm-z80) float bridge — reference document

This is the companion to `CALLING_CONVENTION.md`, focused specifically on the
32-bit `float`/`double` bridge to z88dk's **math32** library
(`libsrc/math/float/math32/`). It collects everything established while
investigating and building `ravn/llvm-z80#277` (2026-07-31 / 2026-08-01):
the data-format question, the exact calling convention, the bridge files
themselves, the semantic caveats, and a full cycle-accurate benchmark of
math32 vs. compiler-rt for all 7 float libcalls clang can emit. Every claim
below was verified (source read + disassembly + runtime execution under
`ntvcm` and/or `z88dk-ticks`), not guessed; re-verify with the same method if
either the backend or math32 changes.

## 0. Background: how this came about

clang lowers every `double` operation to compiler-rt libcalls. By default
that means 64-bit `double` (`__adddf3` etc.), because that's what LLVM
assumes for a "normal" C target — a modern CPU with a built-in FPU.

z88dk's classic clib has no native support for that shape. Its own small
floats are 48-bit math48/MBF — a different bit layout, incompatible with
IEEE-754 `double`.

So the first working path was to ship a **self-contained 64-bit soft-float
runtime** with the compiler itself (Berkeley SoftFloat + compiler-rt-named
shims, `llvmz80-softfloat`). That closure worked but was heavy for a 64 KB
8-bit target and had no z88dk library to lean on. **It is now RETIRED and its
tree deleted (ravn/z88dk#44)** — obsolete since `double` became 32-bit; the
remaining live FP runtime is the math32 bridge described below.

The assumption behind that whole effort was that `double` **had to be**
64-bit — "a fixed requirement due to LLVM being written for bigger and
newer machines" (the user's own words, quoted from the discussion below).

z88dk maintainer `suborb` corrected this on 2026-07-28
(`z88dk/z88dk#3033`): z88dk already ships an IEEE-754 float library,
**`--math32`** — compiler-rt just needs to be bridged to it. Maintainer
`feilipu` pointed to the existing `--math32` alias
(`lib/config/alias.inc`) the same thread.

That correction is what started this investigation: make `double` 32-bit
(matching math32), bridge clang's compiler-rt libcalls to math32's own
cores, and only fall back to the 64-bit closure where 32-bit precision
genuinely isn't enough.

**Open question, not yet done (asked 2026-08-01): can `-lm` be made to run
64-bit `double`, without any z88dk code?** Answer: not via `-lm` itself —
`-lm` is a *link-time* flag, but `double`'s width (`DoubleWidth` in
`Z80TargetInfo`, `clang/lib/Basic/Targets/Z80.cpp`) is baked into the
object code at *compile* time (which libcall name/argument size gets
emitted). No link flag can retroactively turn an already-compiled 32-bit
`__addsf3` call into a 64-bit `__adddf3` call. What *would* work, and
*would* need no z88dk code: a new compile-time flag (e.g. `-mllvm
-z80-double64`) that switches `DoubleWidth`/`DoubleFormat` to 64-bit
IEEEdouble at compile time and links against a self-contained 64-bit
soft-float closure. The `llvmz80-softfloat` closure that once filled that
role has since been **RETIRED and deleted (ravn/z88dk#44)**, so this future
opt-in would require re-vendoring a 64-bit runtime first. This has not been
designed or implemented; it is a plausible future opt-in mode, parked here as
a note, not a task in progress.

## 1. Why this bridge exists

clang (ravn/llvm-z80) makes `double`/`long double` **32-bit IEEE-754 binary32**
(`Z80TargetInfo`, `ravn/llvm-z80#277` Phase 0) instead of shipping a 64-bit
soft-float closure. This makes `float`<->`double` promotion a no-op (zero
`__extendsfdf2`/`__truncdfsf2` ever emitted) and every FP op a single 32-bit
`sf` compiler-rt libcall (`__addsf3`, `__subsf3`, `__mulsf3`, `__divsf3`,
`__cmpsf2`/`__gtsf2`/`__gesf2`/`__unordsf2`, `__fixsfsi`/`__fixunssfsi`,
`__floatsisf`/`__floatunsisf`). Rather than shipping a compiler-rt-style
software-float *implementation* of these 11 libcalls, z88dk already has a
mature, tested 32-bit IEEE float library (**math32**) — the bridge files in
this directory (`__addsf3.asm`, `__cmpsf2.asm`, `__floatsisf.asm`) make clang's
libcalls resolve straight into math32's own cores, at (for most ops) **zero
runtime cost beyond math32's own execution** — see §5.

## 1a. In plain language: why does this bridge live in z88dk, not llvm-z80?

Short answer: **there are two separate float code paths, and only one of
them needs anything from z88dk.**

- **Path A — default ABI.** clang ships its own complete, self-contained
  IEEE-754 binary32 float library as part of the compiler
  (`compiler-rt/lib/builtins/z80/*.asm` in the llvm-z80 repo — `__addsf3`,
  `__cmpsf2`, `__cmpsf2_fast`, etc.). This is compiler-rt's own
  implementation, written from scratch for Z80. It works completely on its
  own; z88dk contributes nothing to it and doesn't need to know it exists.
  This is the same thing every LLVM target does — ship a runtime library
  alongside the compiler for the arithmetic the CPU can't do in hardware.

- **Path B — `-mllvm -z80-float-sdcccall0` (opt-in).** Here we deliberately
  *don't* use compiler-rt's own float code. Instead we redirect clang's
  libcalls into z88dk's existing **math32** library
  (`libsrc/math/float/math32/`), because math32 is smaller/faster on real
  Z80 hardware than compiler-rt's generic version (see §5 for the numbers).
  But math32 wasn't written for compiler-rt's calling convention or its
  return-value contract (e.g. compare needs a -1/0/+1 tri-state result,
  math32 gives a Z/C flag pair) — so a handful of small glue files are
  needed to translate between the two. *That* glue is the "bridge", and it
  lives in z88dk (`libsrc/l/llvmz80/`) because it's fundamentally about
  z88dk's own math32 internals (`m32_compare` and friends) — the compiler
  side of the contract is just "call this symbol name", nothing math32-
  specific leaks into llvm-z80.

Could the linker instead be told to pull a compiler-rt-shaped library
straight out of llvm-z80? Yes — and that's exactly what already happens
for Path A. But for Path B specifically that would mean either
duplicating math32's float format/logic a second time inside the
compiler (double maintenance, risk of the two drifting apart), or having
llvm-z80's own runtime archive reach into z88dk's internal math32 API by
name — which breaks the rule that the compiler should build and test
without knowing anything z88dk-specific. So: same IEEE-754 binary32
*format* either way, but two different *implementations* — one is the
compiler's own code (Path A, no z88dk needed), the other is a thin
translator that lets the compiler reuse z88dk's existing math32 code
(Path B, lives in z88dk).

**Important: `-lm` vs `--math32` picks the IMPLEMENTATION, not the WIDTH.**
It would be easy to assume `-lm` (plain link against the default C runtime,
no z88dk math library) gives you a "normal" 64-bit `double` and `--math32`
gives you the smaller 32-bit one. **That is not the decision being made
here, and it is not true.** `double`/`long double` being 32-bit IEEE-754
binary32 is set unconditionally in `Z80TargetInfo`
(`clang/lib/Basic/Targets/Z80.cpp`, `DoubleWidth = 32`) — it applies to
*every* build of this compiler, regardless of which link flag you pass.
There is no 64-bit `double` mode to opt in or out of via `-lm`/`--math32`
(the separate 64-bit soft-float closure `llvmz80-softfloat` has been RETIRED
and deleted, ravn/z88dk#44 — see §0).

What `-lm` vs `--math32` (or rather, `-mllvm -z80-float-sdcccall0 -lmath32`)
actually decides is **which of the two float-runtime implementations from
§1a your 32-bit floats run on**:
- Plain link, no z88dk float library selected -> Path A, compiler-rt's own
  binary32 code (`compiler-rt/lib/builtins/z80/*.asm` in llvm-z80).
- `-mllvm -z80-float-sdcccall0` (plus linking z88dk's math32, e.g. via the
  `--math32` alias or `-lmath32`) -> Path B, this bridge, into z88dk's
  math32 core.
Get this wrong and you link a mismatched pair (e.g. math32 object files
without the ABI flag, or the ABI flag without linking math32) — that's a
**link/runtime bug** (wrong calling convention or missing symbol), not a
different floating-point precision. The precision (32-bit binary32) is the
same either way; only which hand-written assembly executes it changes.

## 2. Data format: IEEE-754 binary32 on both sides (verified identical)

**Question that came up mid-investigation: is the on-the-wire bit
representation the same on both sides, with only the *code* (algorithms)
differing, or does math32 use some other internal encoding requiring real
conversion?**

Verified: **the bit-level format is identical.** Two independent pieces of
evidence:

1. **`cm32_sdcc_fsread.asm`** (`libsrc/math/float/math32/c/sdcc/`) has a
   comment "Convert from sdcc_float calling to d32_float" that reads like a
   *format* conversion — but its actual implementation (`m32_fsload`, in
   `libsrc/math/float/math32/asm/z80/f32_fsload.asm`) is a **pure 4-byte
   memory-to-register load**:
   ```
   ld c,(hl+)
   ld b,(hl+)
   ld e,(hl+)
   ld d,(hl)      ; DEBC = float
   ld hl,bc
   ret            ; DEHL = float
   ```
   No bit shifting, masking, or re-packing of any kind. "Convert ... calling
   to d32_float" refers to the **calling convention** (stack-passed bytes ->
   register-passed value), not the data format — the bytes read are used
   as-is.
2. **`libsrc/math/float/math32/readme.md`** states the packed format
   explicitly: `seeeeeee emmmmmmm mmmmmmmm mmmmmmmm`, bias 127 — standard
   IEEE-754 binary32, "compatible with Intel / IEEE" — exactly the format
   clang/compiler-rt uses (see the `__cmpsf2.asm` header's own byte-layout
   description, which matches byte-for-byte).

This identity is *why* the arithmetic and conversion bridges in this
directory can be **pure alias `JP`s with zero glue code** (§4) — if the
formats differed, every bridge would need real repacking code, not a tail
jump.

### 2a. But NOT bit-identical *results* in all cases (semantic caveat)

Same bit format does not imply identical computed values for every input.
Two documented differences (`math32/readme.md`), relevant to anyone
considering a hybrid design (e.g. bridging only some ops to math32):

- **No denormal/subnormal support.** math32 does not implement gradual
  underflow; compiler-rt's own soft-float implementation typically does.
- **Rounding differs by operation.** math32 uses full IEEE round-to-nearest-
  even only for **product/pack paths** (mul, sqr, div, poly, invsqrt/sqrt);
  **add/sub use a cheaper "jam-sticky" rounding** on lost bits (not full RNE).
  This is the documented source of a 1-ULP discrepancy observed on `-3/3`
  during earlier benchmarking (see `llvm-z80/tasks/design-2026-07-31-float32-math32-strategy.md`
  §9).

Neither difference affects the bridge's correctness contract (both are
valid roundings of a genuine IEEE-754 binary32 value) — but a caller relying
on bit-exact reproducibility with a strict-IEEE reference implementation
should be aware results can differ in the last bit/ULP for add/sub, and that
subnormal inputs are not supported.

## 3. The compiler-side ABI gate: `-mllvm -z80-float-sdcccall0`

math32's own SDCC-targeted wrappers (`cm32_sdcc_fsadd`/`fssub`/`fsmul`/`fsdiv`
etc., in `libsrc/math/float/math32/c/sdcc/`) are written for SDCC's
`__sdcccall(0)`/`__smallc` stack-argument convention: **both operands pushed
on the stack** (declared order — second-declared operand ends up on top,
closest to the return address), **caller cleans up**, 32-bit result in
**DE:HL** (D = MSB). Compares differ only in returning a 16-bit result in
**HL** (not DE:HL).

clang's *default* C ABI for these libcalls does not match this shape (see
`llvm/test/CodeGen/Z80/issue-277-f32-libcall-sdcccall0.ll`). Rather than
writing register-shuffling glue code to adapt one shape to the other, the
backend gained a dedicated flag: **`-mllvm -z80-float-sdcccall0`** (opt-in,
default OFF, `cl::Hidden`) that makes clang emit these specific libcalls
(`G_FADD`/`G_FSUB`/`G_FMUL`/`G_FDIV`/`G_FCMP`/`G_FPTOSI`/`G_FPTOUI`/
`G_SITOFP`/`G_UITOFP` on 32-bit float/int, in `Z80LegalizerInfo.cpp`) with
`CallingConv::Z80_SDCCCall0` instead of the default `CallingConv::C` — making
every bridge in this directory a **pure alias `JP`**, zero glue code.

**Why the flag is opt-in, not the new default:** the standalone
`--target=z80` ELF path (no z88dk) has its OWN compiler-rt-style `__addsf3`
etc., written for the *default* C ABI. Making the CC change unconditional
would silently break that path (every operand read from the wrong
stack/register slot). Only `zcc +cpm -compiler=llvmz80` opts in, via
`-mllvm -z80-float-sdcccall0`.

**Why not change compiler-rt's own ABI upstream instead** (asked directly
during this investigation): measured in isolation (`design-2026-07-31-float32-math32-strategy.md`
§9a), the `Z80_SDCCCall0` shape costs **+142 T-states/call more** than the
default C ABI to marshal a *no-op* body (165 vs 307 T-states for the same
1-instruction function) — porting compiler-rt to it would make compiler-rt
*slower*, not faster, and still nowhere near math32's speed (math32's
advantage is algorithmic, not ABI-shape). No performance case for an
upstream ABI change exists; the flag + bridge design is confirmed the right
call, not just the pragmatic one.

## 4. The bridge files (this directory)

| file | libcalls | math32 entry points | shape |
|---|---|---|---|
| `__addsf3.asm` | `__addsf3`/`__subsf3`/`__mulsf3`/`__divsf3` | `cm32_sdcc_fsadd`/`fssub`/`fsmul`/`fsdiv` | pure alias `JP`, zero glue |
| `__cmpsf2.asm` | `__cmpsf2`/`__gtsf2`/`__gesf2`/`__unordsf2` | `m32_compare` (called directly, not via the SDCC wrapper) | NOT a pure alias — see below |
| `__floatsisf.asm` | `__fixsfsi`/`__fixunssfsi`/`__floatsisf`/`__floatunsisf` | `cm32_sdcc___fs2sint`/`__fs2uint`/`__slong2fs`/`__ulong2fs` | pure alias `JP`, zero glue |

**Compare is the one non-trivial bridge.** math32's own SDCC compare wrappers
return an SDCC-native carry-flag/HL boolean, not the GCC -1/0/+1 tri-state
`G_FCMP`'s legalization expects, and `m32_compare`'s sign/magnitude algorithm
has **no NaN awareness at all** ("IEEE float is considered zero if exponent
is zero" — no special case). So `__cmpsf2.asm` calls `m32_compare` directly
and (a) translates Z/C flags to the -1/0/+1 encoding clang expects
(`__cmpsf2`/`__unordsf2` families differ only in their NaN fallback value,
+1 vs -1) and (b) checks both operands for NaN itself (exponent==0xFF &&
mantissa!=0, read directly off the stack without disturbing SP) *before*
calling `m32_compare`, short-circuiting to the correct fallback if either is
NaN. See the file's own header comment for a worked NaN-detection example.

All three files' correctness was verified end-to-end at runtime under
`ntvcm`: `z88dk/test/clang/runtime_float.c`/`.sh` (arithmetic, incl.
order-sensitive sub/div cases), `runtime_fcmp.c`/`.sh` (all six
ordered/unordered predicates, several NaN cases), `runtime_fconv.c`/`.sh`
(boundary values incl. 0, negative, INT16_MIN/MAX).

### 4a. Packaging + auto-link (`llvmz80_fmath.lib`, ravn/z88dk#44)

The three bridge sources are assembled into an archive `llvmz80_fmath.lib`
(reproducible via `build_fmath_lib.sh`, committed with `git add -f` like the
sibling `newlib/*.lib`). `zcc` **auto-links** it for every `-compiler=llvmz80`
program — config var `LLVMZ80FMATH`, default
`DESTDIR/libsrc/l/llvmz80/llvmz80_fmath` (env override respected). Because it is
an ARCHIVE the linker discards every unreferenced module, so an integer-only
program pays zero bytes, and the math32 cores (`cm32_`, `m32_compare`) are only
pulled when a float libcall is actually referenced — i.e. only when the user
also passed `--math32`. So a user needs nothing beyond `--math32`; no manual
`-lllvmz80_fmath`.

This closes the ravn/z88dk#44 **blocker** (the fmath bridge was previously an
incomplete stub — only `__addsf3`/`__cmpsf2`/`__floatsisf` were built into the
archive, so `-lllvmz80_fmath` left `__gtsf2`/`__fixsfsi`/… undefined). The full
family above now links and runs; verified 2026-08-09 end-to-end on
`z88dk-ticks` with a comprehensive arith+compare+conv program
(`add=5.50 sub=4.75 mul=7.00 dvd=1.75 neg=-3.50`, `cmp 001101`, `i2=3 u2=3`).
`--math32` is therefore a complete FP runtime for the llvmz80 lane, which is
what unblocked retiring the 64-bit `llvmz80-softfloat/` closure — now **DONE**
(tree deleted, `LLVMZ80RTLIB` wiring removed from zcc, ravn/z88dk#44).

## 5. Performance: math32 vs. compiler-rt, all 7 ops (2026-08-01, reproducible)

Earlier benchmarking (`design-2026-07-31-float32-math32-strategy.md` §9)
only covered add/mul/div. This extends to all 7 ops clang can emit, to
answer directly: **is "always route to math32" (the current bridge design)
actually the fastest choice for every op, or only some?**

**Reproducible**: `test/clang/bench_math32_vs_compilerrt.sh` regenerates
this entire table from scratch (both sides, all 7 ops, plus the
`-ffast-math` compare row in §5a) — no numbers here are hand-copied from a
throwaway session script. Run it with:

```
PATH=<z88dk>/bin:$PATH ZCCCFG=<z88dk>/lib/config \
LLVMZ80EXE=<llvm-z80 build>/bin/clang LLVM_Z80_BUILD=<llvm-z80 build dir> \
test/clang/bench_math32_vs_compilerrt.sh
```

**Method** (both sides cycle-accurate, `z88dk-ticks`, N=2000 loop, fixed
operands every iteration — 3.14159f/2.71828f, 12345.678f for f2i, 12345 for
i2f):

- **compiler-rt side**: a standalone freestanding binary (no CP/M CRT) —
  plain portable C compiled `--target=z80 -Os` with no z88dk/sdcccall0
  flag, so clang emits the libcall under its own default ABI; linked
  directly against the prebuilt compiler-rt `.o` for that op;
  `z88dk-ticks -pc <_start> -end <_bench_halt>`.
- **math32 side**: the real production pipeline, `zcc +cpm -compiler=llvmz80
  -mllvm -z80-float-sdcccall0 -lmath32` (already correctness-verified by the
  `runtime_*.sh` suite above), same loop body, `z88dk-ticks` on the
  resulting `.com`.

**Two pitfalls hit while building the script (documented so they aren't
rediscovered):**
- `z88dk-ticks` decides whether to install the CP/M warm-boot/BDOS trap
  vectors (addresses 0/5/8/11) and load the binary at 0x100 by
  **string-matching the input filename for a literal `.com` suffix**
  (`src/ticks/ticks_main.c`). Without it, the binary loads at address 0
  instead — a 0x100 offset error, no traps installed — corrupting the
  emulated environment from instruction 1 and reliably segfaulting the
  **host** `z88dk-ticks` process itself. Always name CP/M binaries `*.com`.
- On the standalone compiler-rt side, a `noreturn` halt function marked
  only `__attribute__((noreturn))` gets **inlined** at `-Os` — its own
  out-of-line copy (whose address `-end` looks up) is then dead code the
  loop never actually reaches, so `z88dk-ticks` hits its internal
  200M-cycle safety timeout instead of the real exit point. Fix: also mark
  it `noinline`, so a real `call`/`jp` to that address remains in the
  compiled loop.

| op | math32 (T-states/call) | compiler-rt (T-states/call) | winner |
|---|---|---|---|
| add | 978.2 | 1877.0 | **math32 ~1.9x** |
| sub | 1202.4 | 2254.0 | **math32 ~1.9x** |
| mul | 2354.2 | 8931.0 | **math32 ~3.8x** |
| div | 24596.3 | 10797.0 | **compiler-rt ~2.3x** |
| compare (`<`) | 1115.4 | 663.0 | **compiler-rt ~1.7x** |
| float->int | 1425.4 | 799.0 | **compiler-rt ~1.8x** |
| int->float | 583.9 | 615.0 | math32 ~1.05x (near tie) |

**Conclusion:** the current "always bridge to math32" design is **not
uniformly optimal**. It wins clearly for add/sub/mul (the dominant ops in
typical code) and loses clearly for div, compare, and f2i, with int->float
close to a wash. compare's cost is the NaN short-circuit + flags
translation glue in `__cmpsf2.asm` layered on top of `m32_compare` itself
(§5a addresses this under `-ffast-math`). A future per-op hybrid (math32
for add/sub/mul, compiler-rt for div/compare/f2i) is possible in principle
but is **not proposed as a change here** — this section only records the
measurement; any such change needs its own separate go-ahead per the
project's filing/change discipline.

#### Why div is ~2.3x slower in math32: algorithm, not glue

Unlike compare (glue overhead on an otherwise-competitive core routine),
div's gap is **architectural** — the two implementations use fundamentally
different algorithms, and the slower one loses even *in principle*, not
just in this bridge's plumbing.

**math32** (`libsrc/math/float/math32/asm/z80/f32_fsdiv.asm`,
`m32_fsinv_fastcall`) computes `a/b` as `a * (1/b)`, finding the
reciprocal `1/b` via a **Newton-Raphson iteration**: a degree-2 polynomial
seed (`X0 = 140/33 + (-64/11 + 256/99*D')*D'`), then two refinement steps
`X := X + X*(1 - D'*X)`, each of which is 2 float multiplies + 2 float
adds. Counting the seed too, that's **~8 float multiplies + ~7 float
adds worth of sub-calls** (`m32_fsmul24x32`/`m32_fsmul32x32`/
`m32_fsadd24x32`/`m32_fsadd32x32`), plus the final `a * (1/b)` multiply
to get the quotient. NR converges fast in *iteration count* (each step
roughly doubles the correct bits), which is the right trade-off on
hardware with a fast multiplier/FPU — but on the Z80, `m32_fsmul` is
itself a multi-byte shift-and-add routine, not a single instruction, so
"fewer iterations, each an expensive multiply" does not win here.

**compiler-rt** (`compiler-rt/lib/builtins/z80/divsf3.asm`, `___divsf3`)
instead does **24-bit restoring binary long division** directly on the
unpacked mantissas: a fixed 24-iteration loop (`__div_lp`, `djnz`-driven),
each iteration doing one 24-bit compare/subtract and one 3-byte shift —
no multiply at all. This is architecturally the same shape as
compiler-rt's own integer division, just applied to the 24-bit
significands after exponent/sign unpacking.

Net effect: math32 spends ~8 full float-mul/add sub-calls (each itself
built from Z80 shift-and-add mantissa multiplication) computing a
reciprocal, where compiler-rt spends 24 cheap compare-subtract-shift
steps computing the quotient bits directly — and the reproducible
measurement (24596.3 vs 10797.0 T-states/call, ~2.3x) confirms the
mul-heavy NR approach loses on this ISA. This is also the source of the
1-ULP `-3/3` rounding discrepancy noted in §2a (NR's accumulated
rounding differs from a direct restoring divider's exact residual/guard
tracking).

**Possible upstream angle (not yet filed):** since compiler-rt's
`___divsf3` is both faster *and* already IEEE-754 round-to-nearest-even
correct (with explicit guard/round/sticky handling — see the
`__div_guard1`/`__div_rnd_up` block above), it may be worth reporting to
the z88dk maintainers as a possible replacement/alternative for
`m32_fsdiv` on z80/z180/z80n — either swapping the algorithm in math32
itself, or exposing compiler-rt's divider as an option under
`--math32`. This is **not filed yet**; it needs the same
explain-before-filing treatment as any other upstream report (root
cause here is a genuinely different algorithm, not a math32 bug — NR
reciprocal is a legitimate design choice that simply loses on the Z80's
lack of a fast multiplier, which is worth stating plainly in the
report rather than framing it as "math32 has a bug"). If filed, the
report should be honest that this is a **trade-off report**, not a bug
report: math32's NR approach is correct and reasonable in the abstract,
it's simply beaten by direct long division on this specific ISA, and
the report's job is to present that trade-off with the reproducible
numbers above, not assert one implementation is "wrong".

### 5a. `___cmpsf2_fast`: recovering most of the compare gap under `-ffast-math`

The compare glue's NaN check is the biggest chunk of the compare gap
(§5): a raw-asm isolation (design doc §9c) found `m32_compare` alone costs
619 T-states/call, versus 946 for the full `___cmpsf2` bridge — 327
T-states (~78% of the 418 T-state total gap) is the NaN-check + flag
translation glue, not `m32_compare` itself.

math32 has no NaN awareness at all (§2a), so that glue exists purely to
give the bridge IEEE-correct NaN behaviour under plain (non-fast-math) C
semantics. But LLVM already has a standard, existing mechanism for "the
caller doesn't need NaN correctness": `-ffast-math`'s `nnan` flag. Z80's
GlobalISel legalizer (`Z80LegalizerInfo.cpp`, `hasAllFastFlags`,
pre-existing — authored by zlfn, commit `31997a65c57fe`, 2026-03-12,
predates this investigation) already emits a single `__cmpsf2_fast`
libcall instead of `__cmpsf2`/`__gtsf2`/`__gesf2` whenever an `fcmp`
carries all three fast-math flags (`nnan`+`ninf`+`nsz`), for exactly this
reason. `compiler-rt` already had a matching `__cmpsf2_fast` for the
default ABI (`compiler-rt/lib/builtins/z80/cmpsf2.asm`) — but the
z88dk/math32-side bridge (`sdcccall(0)` ABI, gated by
`-z80-float-sdcccall0`) did not, so a `-ffast-math` build against math32
failed to **link** (`undefined symbol: ___cmpsf2_fast`).

Fixed 2026-08-01: `libsrc/l/llvmz80/__cmpsf2.asm` gained `___cmpsf2_fast`
— same sdcccall(0) entry contract as `___cmpsf2`, but calling
`m32_compare` directly and skipping both `CheckNaN` calls, since `nnan`
means the caller has already promised NaN cannot occur.

Verified (`test/clang/runtime_fcmp_fast.{c,sh}`, red/green):
- **RED** (pre-fix): `zcc ... -ffast-math` compiled fine but failed to
  link with `undefined symbol: ___cmpsf2_fast`.
- **GREEN** (post-fix): links, and all six ordered predicates
  (`==`,`!=`,`<`,`<=`,`>`,`>=`) give correct results on ordinary
  (non-NaN — NaN is out of contract under `-ffast-math`) operands.
- Generated `.asm` inspected directly: every compare call site in the
  fast-math build resolves to `call ___cmpsf2_fast`; zero calls to
  `___cmpsf2`/`__gtsf2`/`__gesf2` remain.

**Measured** (`test/clang/bench_math32_vs_compilerrt.sh`, same
reproducible N=2000 harness as §5, `compare` vs `compare_fast` rows):

| op | math32 (T-states/call) | compiler-rt (T-states/call) | winner |
|---|---|---|---|
| compare (`<`), no `-ffast-math` | 1115.4 | 663.0 | **compiler-rt ~1.7x** |
| compare (`<`), `-ffast-math` | 811.4 | 602.0 | **compiler-rt ~1.3x** |

`-ffast-math` saves **304 T-states/call** on the math32 side (1115.4 ->
811.4) — matching the isolated 327 T-state glue estimate above within
~7%. compiler-rt also gets a little faster under `-ffast-math` (663.0 ->
602.0, 61 T-states — its own NaN-check-skipping `__cmpsf2_fast`), so the
math32-vs-compiler-rt gap narrows from ~1.7x to ~1.3x, not full parity.

Net effect: `-ffast-math` closes roughly 60% of the compare gap on the
math32 side without changing the ABI or the "always bridge to math32"
design. This does **not** apply to add/sub/mul/div/f2i/i2f — those
libcalls have no NaN-check glue to remove, so `-ffast-math` earns them no
speedup on the math32 bridge side.

## 6. Related files

- `libsrc/math/float/math32/readme.md` — math32's own format/algorithm
  documentation (source for §2/§2a).
- `libsrc/math/float/math32/c/sdcc/cm32_sdcc_fsread.asm`,
  `libsrc/math/float/math32/asm/z80/f32_fsload.asm` — the "conversion" that
  turns out to be a plain memory load (§2).
- `llvm-z80/tasks/design-2026-07-31-float32-math32-strategy.md` — the full
  design rationale, Path X/Y decision, §9/§9a/§9b benchmarks.
- `llvm/test/CodeGen/Z80/issue-277-f32-libcall-sdcccall0.ll`,
  `issue-277-f32-cmp-conv-sdcccall0.ll` — lit tests pinning the
  `-z80-float-sdcccall0` codegen shape (llvm-z80 repo).
- `z88dk/test/clang/runtime_float.{c,sh}`, `runtime_fcmp.{c,sh}`,
  `runtime_fconv.{c,sh}`, `runtime_fcmp_fast.{c,sh}` — the red/green
  correctness suite for these bridges (the last one for `___cmpsf2_fast`).
- `z88dk/test/clang/bench_math32_vs_compilerrt.sh` — reproducibly
  regenerates the §5/§5a performance tables from scratch.

## 7. z88dk's own `test/suites/math` under `-compiler=llvmz80` (2026-08-03)

z88dk ships a math test-suite (`test/suites/math`) that builds
`test_math32.bin` — the IEEE-754 binary32 variant — with, verbatim:

    -DMATH32 -D__MATH_MATH32 -fp-mode=ieee ... -lmath32

Two independent things stood between that target and a green run under the
llvmz80 backend; only the first was a driver bug we fixed, the second is a
test-wiring gap that is **not** a compiler/bridge defect.

### 7a. Driver fix: zcc no longer forwards `-fp-mode` to clang (FIXED)

`-fp-mode=<x>` is an **sccz80/sdcc** double-format selector
(`src/sccz80/main.c`: `fp-mode=ieee` -> 32-bit IEEE, `fp-mode=z80` -> 48-bit,
`mbf32`, …). It is *not* a zcc driver option, and zcc forwards any flag it
does not recognise straight to the C compiler
(`parse_cmdline_arg` -> `add_option_to_compiler` -> `comparg`). So the
llvmz80 clang driver received it and aborted:

    clang: error: unknown argument: '-fp-mode=ieee'

On the suite's command line the flag even appears *before* `-compiler=llvmz80`,
so it is already in `comparg` by the time the compiler is known — filtering at
parse time is unreliable.

Fix (commit `ef85518d3e`, `src/zcc/zcc.c`): after `configure_compiler()`
resolves `compiler_type == CC_LLVMZ80`, a new helper `strip_flag_prefix()`
removes any `-fp-mode*` token from `comparg`. clang-z80 is IEEE-754-only, so
`-fp-mode=ieee` is a no-op for it and any other `-fp-mode=<x>` is unsupported;
dropping it is correct. The helper matches only at whitespace/token
boundaries, so a `-fp-mode` substring embedded in a path is left alone.

Verified: `zcc +cpm -compiler=llvmz80 -fp-mode=ieee` now compiles with output
**byte-identical** to the no-flag build (confirming the no-op); `sccz80` still
honours `-fp-mode` (the strip runs only in the llvmz80 branch); llvmz80
without `-fp-mode` is unchanged.

### 7b. Remaining gap: the stock target links no clang float32 runtime (NOT fixed)

With the flag consumed, `test_math32.bin` compiles and then fails at the
**link** stage with undefined `sf` compiler-rt symbols
(`___addsf3`, `___subsf3`, `___mulsf3`, `___divsf3`, `___cmpsf2`, `___gesf2`,
`___unordsf2`, `___fixsfsi`, …).

This is expected and is a property of the *test as written*, not a bug in
the compiler or in this bridge. clang emits standard-ABI `sf` libcalls for
`float`, and the suite links only z88dk's `-lmath32` (whose entry points are
`cm32_*`, not the compiler-rt names). Resolving those libcalls under llvmz80
needs **one** of the two paths this document describes, and the stock target
wires up neither:

- **Path B — the math32 bridge (§3/§4):** add `-mllvm -z80-float-sdcccall0`
  so clang's `sf` calls use the sdcccall(0) ABI, and link the bridge aliases
  in this directory (`__addsf3.asm`, `__cmpsf2.asm`, `__floatsisf.asm`) on top
  of `-lmath32`. This is the light path and the one whose correctness is
  proven by `test/clang/runtime_float|fcmp|fconv.sh`.
- **Path A — the softfloat closure (RETIRED, ravn/z88dk#44):** historically
  linked the `llvmz80-softfloat` archive (Berkeley SoftFloat + compiler-rt
  shims incl. `src/sf32.c`), which defined the `sf` symbols directly. Heavier;
  see §0. That tree is now deleted — Path B is the sole route.

Making `test/suites/math`'s `test_math32.bin` link+run under llvmz80 is
therefore a **test-harness change** (teach that one target to add the Path-B
ABI flag + bridge objects for `-compiler=llvmz80`), tracked separately from
the driver fix above. (The `llvmz80-softfloat` Path-A archive has since been
RETIRED and deleted, ravn/z88dk#44, so only the Path-B ABI flag + bridge
objects remain relevant.)
