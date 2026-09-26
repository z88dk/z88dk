# clang-z80 (ravn/llvm-z80) calling convention — reference for the bridge layer

This directory holds the ABI adapters that let a program compiled by
`zcc +cpm -compiler=llvmz80` call z88dk's classic clib. To write or review one
correctly you need the exact calling convention ravn/llvm-z80 emits. It is NOT
documented by the backend, so it is captured here. Every fact below was
verified by disassembling real caller/callee code with this clang (dates in
parentheses); re-verify with the same method if the backend changes.

> **2026-08 update (ravn/llvm-z80#279):** clang's `__smallc` now maps to the
> **`smallc`** calling convention (arguments pushed **left-to-right**,
> caller-cleans) — byte-for-byte the SDCC/sccz80 `__smallc` layout. It used to be
> wired to `sdcccall(0)` (right-to-left), which only happened to work for the
> 1-argument console workers. This removed a whole class of reversed-parameter
> header bridges: a plain multi-arg `__smallc` declaration now calls the classic
> workers correctly with **no reversal and no hand-asm**. The historical
> reversed-param / `___name` register-bridge machinery (Strategy A/B below) is
> **superseded**; it is kept here only as background.

## The four conventions in one table

| Macro (portable spelling) | llvmz80 attribute | push order | cleanup | 16-bit return | Use |
|---|---|---|---|---|---|
| *(none / default)* | `sdcccall(1)` | arg1→HL, arg2→DE, rest R→L | callee | `DE` | what an unannotated `extern` uses |
| `__smallc` | `smallc` | **left-to-right** (all on stack) | caller | `HL` | call a classic `__smallc` clib worker |
| `__z88dk_callback` | `sdcccall(0)` | right-to-left (all on stack) | caller | `HL` | a callback the library calls back into |
| `__vasmallc` | `sdcccall(0)` | right-to-left | caller | `HL` | a variadic library function (printf…) |
| `__z88dk_callee` | `z88dk_callee` | right-to-left | **callee** | `HL`/`A` | a `*_callee` clib entry |
| `__z88dk_fastcall` | `z88dk_fastcall` | single arg in `L`/`HL`/`DE:HL` | — | by width | a `*_fastcall` clib entry |

`smallc` and `sdcccall(0)` are **mirror images** for a multi-argument call
(left-to-right vs right-to-left); they coincide only for a single argument. This
is why `__smallc` and `__z88dk_callback`/`__vasmallc` are *different* macros even
though all three are "stack + caller-clean + HL return". Getting the direction
wrong swaps the arguments (e.g. a `__smallc` qsort comparator inverts the sort).

---

## `sdcccall(1)` — the default (what an unannotated `extern` uses)

The ravn/llvm-z80 backend default, `sdcccall(1)`-compatible, kept per the user's
"do not change sdcccall 0/1" directive. An unannotated declaration already uses
it, so **no annotation is normally needed**; the explicit form is
`__attribute__((sdcccall(1)))`. It is the convention every clang-compiled C
function is emitted with, and the one a bridge must match when *called by* clang.

- **Arguments**: arg1 → `HL`, arg2 → `DE`. Args 3.. **pushed right-to-left**
  (last declared arg deepest, arg3 nearest the top). Verified 2026-07-16:
  `worker4(0x1111,0x2222,0x3333,0x4444)` → `ld hl,0x1111 / ld de,0x2222 /
  push 0x4444 / push 0x3333 / call`. 8/32-bit register assignment differs (a
  leading `char` uses `A`/`L`); the facts here are for 16-bit (pointer/int) args.
- **16-bit return**: in **`DE`**, not HL. A call site does `call foo / ex de,hl`;
  a returning function ends `... / ex de,hl / ret`.
- **8-bit return**: in `A`.
- **Stacked-arg cleanup**: **callee-cleans** (`pop bc / inc sp*2N / push bc / ret`).
- **Register preservation**: `HL`/`DE`/`BC`/`AF` caller-saved, `IX` callee-saved,
  `IY` reserved.

## `__smallc` == `smallc` — the classic stack convention

Used to call a classic `__smallc` clib worker directly. Byte-for-byte the
SDCC/sccz80 `__smallc` layout, so an annotated declaration stays source-portable
(`__smallc` is a native keyword / no-op for sccz80/sdcc).

- **Arguments**: **all** args on the stack, **left-to-right** (first declared arg
  pushed first = **deepest**; last declared arg ends up **on top**, nearest the
  return address). Verified 2026-08: `worker(0x1111,0x2222,0x3333)` →
  `push 0x1111 / push 0x2222 / push 0x3333 / call`. This is **byte-identical to
  native SDCC `__smallc`** (checked against `z88dk-zsdcc --sdcccall 0`).
- **Return**: 16-bit in **`HL`** (classic clib convention); clang adds its own
  `ex de,hl` after the call. So a `__smallc` bridge needs no `ex de,hl`.
- **Cleanup**: **caller-cleans** (`pop af`×N after the call), matching the
  classic workers (which end `pop ix / ret`, leaving the args on the stack).

### Consequence — arg order now MATCHES the classic worker (no reversal)

A classic `__smallc` worker reads `ix+4 = last-declared arg`, `ix+6 = …`, i.e.
**last arg on top, first arg deepest**. Because `smallc` pushes left-to-right,
clang lands the **first** declared param deepest and the **last** on top — exactly
what the worker wants. So the natural-order declaration is correct as written:

```c
/* natural order, no reversal, no asm — clang marshals straight into _fread */
extern int __LIB__ fread(void *ptr, size_t size, size_t num, FILE *fp) __smallc;
```

This is what `include/sys/proto.h`'s `__ZPROTO*` macros emit for clang now
(identical to their SDCC branch). The pre-#279 code had to declare a **reversed**
low-level to compensate for `__smallc == sdcccall(0)`; that reversal is gone.

## `__z88dk_callback` == `sdcccall(0)` — a callback the library calls back into

For a function the **classic library invokes through its own thunk** — a
`qsort()`/`bsearch()` comparator, `funopen()`'s hooks, etc. The library's
callback thunk (e.g. `l_cmp_sdcc` in `classic/stdlib/_qsort.asm`) marshals the
operands in **SDCC's default (sdcccall0, right-to-left)** order and expects the
result in `HL`.

- **sccz80/sdcc**: their own default already matches → `__z88dk_callback` is
  **empty** (a plain callback is called correctly).
- **llvmz80/clang**: clang's default is `sdcccall(1)` (register args), which does
  NOT match → the macro expands to `__attribute__((sdcccall(0)))`.

It is deliberately **not** `__smallc`: `__smallc` is `smallc` (left-to-right),
the mirror of `sdcccall(0)`, so a `__smallc` comparator would receive its two
operands swapped and **invert the sort** (verified at runtime). Full doc +
per-compiler definitions live in `include/sys/compiler.h`. Usage:

```c
__z88dk_callback int cmp(const void *a, const void *b) { /* … */ }
qsort(base, n, size, cmp);            /* comparator carries the convention */
```

Shipped users: `qsort`/`bsearch` in `include/stdlib.h`. Distinct from
`__vasmallc` (a *variadic library function* the user calls) even though both are
`sdcccall(0)` on clang — they differ on sccz80 (`__vasmallc == __smallc` there).

---

# The `__ZPROTO` family — how the header macros wire clang → classic clib

`include/sys/proto.h`'s `__ZPROTO2/3/3N/4/5` macros declare classic-clib workers.
Since ravn/llvm-z80#279 the **clang branch is identical to the SDCC branch**: a
plain natural-order `__smallc` prototype of the public worker.

```c
/* what __ZPROTON expands to for clang AND sdcc now: */
extern r name(t1 a1, …, tN aN) __smallc;
```

`__smallc == smallc` (left-to-right), which is exactly the layout the classic
`_name` workers read, so **clang calls them directly** — no `___name` low-level,
no reversed params, no forwarding inline, no hand-asm bridge, no `ex de,hl`
(the worker returns HL and clang adds the swap itself). `__ZPROTO3N` is now
equivalent to `__ZPROTO3` for clang (both natural-order `__smallc`).

## Superseded machinery (historical — pre-#279)

Before `__smallc` meant `smallc`, the clang `__ZPROTO` branch declared a
**reversed-parameter** `___name` low-level under the register default and a
forwarding inline, and bridges came in two flavours:

- **Strategy A** — a hand-asm `___name:` marshaller in the worker's `.asm`
  (moved HL/DE/stack into the `asm_*` core, did `ex de,hl`, cleaned per return
  width). Used by the string functions and strtol/strtoul.
- **Strategy B** — a header `extern r __name(<reversed params>) __smallc
  __asm__("<worker>")` + forwarding inline, binding straight to the classic
  `__smallc` global.

Both existed **only** to compensate for `__smallc == sdcccall(0)` putting the
first param on top. With `smallc` the natural declaration already produces
the worker's layout, so these are no longer emitted; any remaining `___name`
hand-asm bridges are unreferenced (the linker drops them). Do **not** write new
reversed-param bridges — declare the worker `__smallc` in natural order.

## POSIX fd-layer (`open`/`read`/`write`/`close`/`lseek`) on CP/M — DUMMY

`<fcntl.h>` declares these with `__ZPROTO3`/`__ZPROTO2`. On the classic `+cpm`
target they resolve to `libsrc/classic/fcntl/dummy/*.asm` — intentional no-op
stubs (`open`→`ld hl,-1`, `read`/`write`/`close`→bare `ret`) that `PUBLIC` the
bare/`_`-prefixed names, so clang links against them and needs **no bridge**. The
POSIX integer-fd layer simply does not exist on CP/M for ANY compiler; real CP/M
file I/O goes through the **stdio `FILE*` layer** (complete, MAME-verified).
(Note: `write()` now returns the byte count correctly under `+cpm` — the natural
`__ZPROTO3` `__smallc` declaration fixed ravn/z88dk#23.)

## Checklist to add/verify a `__ZPROTO` bridge

1. Prefer a plain `__ZPROTO*` (or `extern … __smallc`) natural-order declaration:
   `smallc` calls the classic `_name` worker directly, no asm.
2. For a `*_callee` entry use `__smallc __z88dk_callee` (the `z88dk_callee`
   attribute wins — callee-cleans, right-to-left); for a `*_fastcall` entry use
   `__z88dk_fastcall`.
3. For a callback the library calls back into (comparator/hook), put
   `__z88dk_callback` on the callback (and on the fn-pointer parameter type).
4. Only fall back to a hand-asm bridge when the worker is not a plain `__smallc`
   global (e.g. a register-passing `asm_*` core with no `__smallc` entry).
5. Red-green: add a `test/clang/runtime_*.{c,sh}` case; prove fail-before /
   pass-after (ntvcm for stdout-only, MAME for file I/O).

---

# Floating-point runtime (`double`/`float`) — the auto-linked `llvmz80_fmath.lib` bridge

On the z80 target `double` == `float` == `long double` == **32-bit IEEE-754
binary32** (`sizeof == 4`, since ravn/llvm-z80#277). clang therefore lowers every
floating-point operation to **single-precision** compiler-rt soft-float libcalls
only — `__addsf3`/`__subsf3`/`__mulsf3`/`__divsf3`, the comparisons
(`__cmpsf2`/`__unordsf2`/`__gtsf2`/`__gesf2`), and the conversions
(`__floatsisf`/`__floatunsisf`/`__fixsfsi`/`__fixunssfsi`). It never emits any
64-bit `df` libcall. z88dk's classic clib does not supply these under those
compiler-rt names (its own floats are a different bit layout), so a thin
**math32 bridge** maps them onto z88dk's 32-bit-IEEE `--math32` core. It is
packaged as a z80asm `.lib` archive `llvmz80_fmath.lib` (built by
`libsrc/l/llvmz80/build_fmath_lib.sh`), living **inside z88dk**.

**Auto-link:** `zcc` appends the bridge for every `-compiler=llvmz80` link via
the `LLVMZ80FMATH` config var, which has a `DESTDIR` default, so it is **on by
default** — no env var, no explicit `-l`:

```sh
zcc +cpm -compiler=llvmz80 --math32 -o prog prog.c   # double/%f just work
```

Because it is an **archive**, an integer-only program that never touches a float
links **byte-identically** whether or not the bridge is on the line, and the
bridge only pulls math32's float cores when the user also passes `--math32`
(i.e. when a float libcall is actually referenced). See
[`MATH32_BRIDGE.md`](MATH32_BRIDGE.md). ravn/z88dk#44.

Status: `(double)int` (`__floatsisf`) and user `va_start`/`va_arg` (was
ravn/llvm-z80#270) are **FIXED**; classic `printf("%f")` works via stock `printf`
+ `--math32` (ravn/z88dk#43, single route). The 64-bit Berkeley-SoftFloat closure
(`softfloat_cpm_z80.lib` / `LLVMZ80RTLIB`) and the `llvmz80-softfloat/` tree are
**RETIRED** (ravn/z88dk#44) — obsolete since `double` became 32-bit.

> **Classic `%f` — single route since ravn/z88dk#43** (reconciled 2026-08-09):
> stock z88dk `printf` + `--math32` (verified byte-identical to sccz80,
> `v=   3.5|d=42`). As of ravn/z88dk#42 the driver auto-scans format strings in
> `zpragma` (`-autoformat`) and selects the classic converters exactly like
> sccz80 for **both `-compiler=llvmz80` and `-compiler=sdcc` (zsdcc)**, so an
> explicit `#pragma printf` is **no longer required** on either lane (it still
> works and still wins if you want to prune the set by hand). Only `--math32`
> remains mandatory, to supply the 32-bit-IEEE float core. The old
> `llvmz80-softfloat` nanoprintf closure (`__llvmz80_printf`) is **RETIRED** —
> `double` is 32-bit since ravn/llvm-z80#277 so stock `printf` covers `%f` with
> the portable entry point. Full recipe + rationale:
> [`PRINTF_FLOAT.md`](PRINTF_FLOAT.md).

# Variadic stdio return value (printf/sprintf/scanf family) — ravn/z88dk#31 (FIXED)

The classic clib variadic workers return the 16-bit count in **HL** and push
their varargs **right-to-left** so the fixed format arg is reachable — i.e.
`sdcccall(0)`, **not** `__smallc`. The variadic decls carry `__vasmallc`, which
for llvmz80 is pinned to `sdcccall(0)` explicitly:

```c
#if defined(__LLVMZ80)
#undef  __vasmallc
#define __vasmallc __attribute__((sdcccall(0)))   /* HL return, R-to-L fixed args */
#endif
```

> Note: this was `#define __vasmallc __smallc` while `__smallc` still meant
> `sdcccall(0)`. Once `__smallc` became `smallc` (left-to-right) the two
> stopped being interchangeable, so `__vasmallc` now pins `sdcccall(0)` directly.
> `sdcccall(1)` would read the count from `DE` (garbage); the fix changes clang's
> own call-site codegen — **no asm trampoline**. Guarded to `__LLVMZ80`;
> ez80-clang (`__stdc`, HL return) is already correct and untouched.

**`va_list` variants** — `vfprintf`/`vsnprintf`/`vfscanf`/`vsscanf` end in a
fixed `void *ap`, so `__vasmallc` does not reach them. Their classic workers are
the same va-style layout (fixed args nearest the return address, count in HL), so
they are declared **`__attribute__((sdcccall(0)))`** under `#if defined(__LLVMZ80)`
in `include/stdio.h` (again *not* `__smallc`, which would push them the wrong
way). Verified GREEN by the integration suite (`test/clang/runtime_fileio_fmt`,
`runtime_printf_ret`, and the vfamily self-check).

# 32-bit multiply `-O3` fast path — `__mulsi3` → `__mulsi3_fast` (ravn/llvm-z80 #283)

At **`-O3` only** (clang `CodeGenOptLevel::Aggressive`), the Z80 backend routes
the 32-bit integer multiply libcall `__mulsi3` to a fast variant
`__mulsi3_fast`. Every other opt level (`-O0/-O1/-O2/-Os/-Oz`) keeps the plain
`__mulsi3`, so production firmware (built at `-Os`) is untouched. SM83 (gbz80)
is excluded (different multiply ABI/runtime, no `_fast` bridge) — matching the
`-O3` `__*hi3_fast` div/mod routing (#244).

## Why it is faster — the signed-magnitude demote trick

Both bridges here forward to the z88dk classic 32-bit multiply cores. The
unsigned core `l_mulu_32_32x32` (= `l_small_mul_32_32x32` on the small model)
has a fast path that *demotes* a 32×32 multiply to a single 16×16 when **both**
hi-words are zero. clang sign-extends `i16→i32` for the common `(long)a*b`
fixed-point shape, so a negative operand has hi = `0xFFFF` and **misses** the
demote → the full, slow 32×32 runs.

`__mulsi3_fast` instead calls the **signed** core `l_muls_32_32x32`
(= `l_small_muls_32_32x32`), which takes each operand's *magnitude* first
(hi → `0x0000` for a value that fits 16 bits), **hits** the demote, then fixes
the sign. The low 32 bits of a signed vs unsigned product are identical, so this
is a **correct drop-in for every 32-bit multiply**, not just sext-`i16` ones. It
only costs a small abs/negate overhead on *genuine* 32-bit operands (which then
miss the demote anyway) — a speculative speed-over-predictability trade, which is
exactly why it is gated to `-O3`.

## The bridge file (this directory)

`__mulsi3_fast.asm` is a byte-for-byte sibling of `__mulsi3.asm` (same clang↔core
ABI adaptation: register factor in `HL:DE`, other factor on the stack, preserve
`IX`, product back in `HL:DE`) with a single change:
`call l_muls_32_32x32` instead of `call l_mulu_32_32x32`.

## Compiler side — where the routing lives (non-obvious under the new RTLIB API)

Under LLVM's RuntimeLibcalls redesign the GlobalISel legalizer resolves a
`.libcallFor` name from a **`LibcallLoweringInfo`** built by the
`LibcallLoweringInfoWrapper` analysis — which calls
`TargetSubtargetInfo::initLibcallLoweringInfo`, **not** the `TargetLowering`
instance. So the override must live in `Z80Subtarget::initLibcallLoweringInfo`
(`setLibcallImpl(RTLIB::MUL_I32, RTLIB::impl___mulsi3_fast)` gated on opt level);
a `setLibcallImpl` in the `Z80TargetLowering` ctor silently has **no effect**
(the emitted call stays `___mulsi3`). The custom impl name is declared in
`llvm/include/llvm/IR/RuntimeLibcalls.td` as
`def __mulsi3_fast : RuntimeLibcallImpl<MUL_I32>;`. Pinned by lit test
`llvm/test/CodeGen/Z80/issue-283-mul-fast-o3.ll` (O3 → `___mulsi3_fast`,
O2 → `___mulsi3`).

## Measured effect (full mandelbrot, RC702 in MAME, `-nothrottle`, `_main`→`_getk`)

| Build | T-states | vs clang `-O2` |
| --- | --- | --- |
| clang `-O2` (`__mulsi3`) | 1,192,734,124 | — |
| clang `-O3`, mul unchanged (isolation) | 1,192,734,175 | +0.0% |
| **clang `-O3` (`__mulsi3_fast`)** | **691,592,091** | **−42.0%** |
| sccz80 `-O2` | 934,494,391 | −21.7% |
| sccz80 `-O3` | 941,766,172 | −21.0% |

The isolation row (clang `-O3` linked against a `__mulsi3_fast` that calls the
*unsigned* core) is essentially identical to `-O2`, proving the **entire** win is
the multiply routing, not general `-O3`. With it, clang `-O3` beats sccz80 by
~26% here (clang's BSS locals + better `>>` codegen dominate once the multiply
gap closes). Render output is **byte-identical** between `-O2` and `-O3` (the
signed/unsigned low-32-bit guarantee).

## Packaging caveat

`__mulsi3_fast.asm` lives in this directory but the symbol only resolves at link
once the classic `crt0` libs are rebuilt (it is compiled into the `*_crt0.lib`
like the other `l/llvmz80` objects). The #283 measurement above linked
`__mulsi3_fast` as a standalone object; a lib rebuild is the packaging step for
arbitrary `-O3` user builds to pick it up automatically.
