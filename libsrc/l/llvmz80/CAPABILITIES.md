# llvmz80 (clang-z80) in z88dk — capabilities & limitations

**Purpose.** A single, consolidated answer to "what can and can't `clang`
(ravn/llvm-z80) do inside z88dk today?" — the raw material for the eventual
z88dk **clang wiki page**. It summarises and cross-links the detailed reference
docs in this directory; where a claim has a verification date it was checked from
source or emitted asm on that date, not assumed.

Detailed sources (read these for the mechanism, not just the verdict):
- `CALLING_CONVENTION.md` — the four ABIs, the `__ZPROTO` bridge family, the
  `double` runtime, the `-O3` fast-multiply path.
- `MATH32_BRIDGE.md` — `float`/`double` = IEEE-754 binary32, math32 bridge, per-op
  performance.
- `PRINTF_FLOAT.md` — the two `printf("%f")` routes.
- `newlib/README.md` + `newlib/KNOWN_GAPS.md` — the newlib-route contract and its
  documented gaps.
- Workspace `CLAUDE.md` "z88dk stdlib status" + "Known Bugs" — the live headline.

> **Two routes, pick one.** The **classic** clib (`-clib=default`, the CP/M
> forward direction) is the fully-green, recommended route. The **newlib**
> route (`-clib=newlib_iy`/`newlib_ix`) is compat-only and has a small set of
> documented gaps (see `newlib/KNOWN_GAPS.md`). Everything below is the
> **classic** route unless a row says "newlib".

---

## 1. Integration model — llvmz80 is NOT merged into z88dk

Same model as ez80-clang (CE-Programming): z88dk ships the bridges, headers and
copt rules; the user installs the llvm-z80 clang separately and points zcc at it.
z88dk contains **no clang binary** — only text (asm bridges, headers, config)
plus the small auto-linked float32 math bridge archive `llvmz80_fmath.lib`.

```sh
export LLVMZ80EXE=/path/to/llvm-z80/build-macos/bin/clang   # or put llvmz80-clang on PATH
zcc +cpm -subtype=rc700 -compiler=llvmz80 --math32 -O2 -o prog prog.c   # double/%f: --math32, bridge auto-linked
```

- **Compiler selection:** `-compiler=llvmz80`. Defines `-D__CLANG -D__LLVMZ80
  --target=z80`.
- **`LLVMZ80EXE`:** the clang to drive. Config default is `llvmz80-clang` (relies
  on PATH); env var overrides. (The old hard-coded macbook path is gone.)
- **`-O<n>` passthrough:** `zcc -O2` → `clang -O2`, `zcc -O3` → `clang -O3`,
  `--opt-code-size` → `-Oz`. No `-O` → `-O0`.
- **C standard:** default `-std=gnu23` (C23 + GNU ext). Override per build with
  `-Cg-std=<std>` (clang honours the last `-std`). Production firmware drives
  clang directly with `-std=c23`.

---

## 2. What works — classic route (verified)

| Area | Works | Notes |
|------|-------|-------|
| **Core codegen** | recursion, structs, globals, 32-bit `long` mul/div/mod, BSS kept out of the `.COM` image, `.quad`/`.rodata.cstN` split via copt bridge | `-O0..-O3`, `-Os`/`-Oz`. Production RC702 firmware (autoload, rcbios, cpnos) ships on this. |
| **`string.h`** | mem*, str[cpy/cmp/cat/chr/ncpy], strlen + fastcall single-arg string fns, strstr/strtok/strncmp/… | direct `__smallc` (`smallc`) calls, no `ex de,hl` adapter since #279 |
| **`ctype.h`** | isdigit/isalpha/toupper/tolower & siblings | |
| **`stdlib.h`** | malloc/calloc/realloc/free, atoi/atol/itoa, strtol/strtoul/strtod, qsort, bsearch, rand/srand, abs/labs, getenv, getopt | qsort/bsearch comparators use `__z88dk_callback` |
| **`stdio.h` — streams** | printf/sprintf/snprintf/puts/putchar/getchar, the full **FILE\*** API | variadic uses `__vasmallc` → `sdcccall(0)` (count in HL) |
| **`stdio.h` — disk FILE\*** | fopen/fclose/fread/fwrite/fprintf/fscanf on real files | **MAME-verified** (16/16). Real CP/M file I/O goes through the FILE\* layer. |
| **`stdarg.h`** | `__builtin_va_*` in user functions; variadic stdio return value | was ravn/z88dk#31 (stdio ret) + ravn/z88dk#270 (`va_start`/`va_arg`) — FIXED |
| **Integer libcalls** | `__mulsi3`, `__divsi3`, `__udivsi3`, `__divmodsi4`, `__divhi3`, `__mulhi3`, `__udivqi3`, … | thin `libsrc/l/llvmz80/*.asm` bridges over the classic `l_*` cores |
| **`double`/`float` (32-bit binary32)** | +,-,*,/, compares, `__floatsisf`/`__fixsfsi`/conversions | `double`==`float`==32-bit since ravn/llvm-z80#277; `sf` libcalls resolved by auto-linked `llvmz80_fmath.lib` math32 bridge (`--math32`). `(double)int` was #273 — FIXED |
| **`printf("%f")`** | stock `printf` + `--math32` (single route since #43; converters auto-selected since #42, `#pragma printf` optional). nanoprintf closure RETIRED | see `PRINTF_FLOAT.md`. For `%e`/`%g` see row below. |
| **Port I/O** | `address_space(2)` → `IN A,(n)`/`OUT (n),A` | ravn/llvm-z80 #1/#44 |
| **Z80 intrinsics/attrs** | `__builtin_z80_di/ei/halt/nop/im2/set_i`; `__attribute__((z80_critical))` | ships `<intrinsic.h>` so the same source compiles under clang AND SDCC |

**`float`/`double` are 32-bit IEEE-754 binary32** on this target (float32-math32,
ravn/llvm-z80#277). The `-compiler=llvmz80` path auto-injects `-mllvm
-z80-float-sdcccall0` so the f32 arithmetic libcalls bridge to z88dk math32. See
`MATH32_BRIDGE.md`.

---

## 3. What works — newlib route (summary)

Route: `-clib=newlib_iy` / `-clib=newlib_ix`. **35 PASS / 0 FAIL** in `test/clang`
(newlib_iy leg), file-open cases skipped by design. Direct `_callee`/`_fastcall`
calls (no adapter modules — the newlib headers redirect plain names to the native
variants and clang matches `z88dk_callee`/`z88dk_fastcall` exactly).

Works: `string.h`, `ctype`, `stdlib` (malloc/calloc/realloc/free/atoi/qsort/…),
the full `stdio` **FILE\*** API *except real disk open* (console/stream I/O
works), integer libcalls (via `llvmz80_imath.lib`), 32-bit `double`/`float` (via
the auto-linked `llvmz80_fmath.lib` math32 bridge, `--math32`).

**Prefer the explicit `-clib=newlib_iy`/`newlib_ix`** — the generic `-clib=new`
alias is not wired (ravn/z88dk#18).

---

## 4. What does NOT work / limitations (consolidated)

| Limitation | Route | Status / workaround |
|------------|-------|---------------------|
| **`setjmp`/`longjmp`** | newlib | `setjmp` returns nonzero on the initial call (`__SMALLC` ABI mismatch). Open, left visible. **Use classic** — classic `setjmp` PASSES. (`KNOWN_GAPS.md` #3) |
| **Disk `FILE*` I/O** | newlib | link error `asm_target_open` — CP/M newlib ships no file-open driver, tree-wide. ravn/z88dk#34 WONTFIX. **Use classic.** (`KNOWN_GAPS.md` #1) |
| **`<math.h>` / libm** | both | `<math.h>` won't compile (`_Float16` reserved keyword); newlib libm uses a non-IEEE float format and won't link. ravn/z88dk#37. clang `double` uses the auto-linked `llvmz80_fmath.lib` math32 bridge, not newlib math. (`KNOWN_GAPS.md` #2) |
| **`printf` `%e` / `%g`** | classic | was a nanoprintf design limitation; nanoprintf is now RETIRED (#43). On stock classic `printf` these are separate converters — availability not re-verified this session; `%f` is the verified path. |
| **POSIX fd-layer** (`open`/`read`/`write`/`close`/`lseek`) | classic `+cpm` | resolve to intentional no-op dummy stubs — the integer-fd layer does not exist on CP/M for **any** compiler. Use the `FILE*` layer. (`write()` returns the byte count correctly — ravn/z88dk#23 fixed.) |
| **`isqrt` / `unbcd`** | newlib | classic-clib extensions, absent from newlib `_DEVELOPMENT` headers by design. Use classic. |
| **`double` TPA cost** | both | the 32-bit math32 bridge is small, but pulling in float math + `%f` converters still costs TPA; budget it on 64 KB CP/M. Integer-only programs link byte-identically (the bridge archive discards all unreferenced modules). |

> **Note on ABI visibility:** clang-z80 default is `sdcccall(1)` — 16-bit return
> in **DE** (not HL). This is visible in inline asm and is why the bridge fns
> exist; ordinary C code never sees it. See §5.

**Superseded / stale:** the 2026-07-16 `tasks/z88dk-submission-gap-2026-07-16.md`
lists several BLOCKERs that are now **resolved** — the hard-coded `LLVMZ80EXE`
default (now `llvmz80-clang`), the stdio/string/stdlib bridge gaps (#20/#22/#23,
now green), and the far-`jr` assembler failure (ravn/llvm-z80#267, backend-fixed
2026-07-20/21). Treat that doc as a historical submission checklist, not current
status.

---

## 5. ABI facts a wiki reader needs

Default convention is **`sdcccall(1)`** (unannotated `extern`): args in HL/DE,
16-bit result in **DE**, HL/DE/BC/AF caller-saved, **IX the only callee-saved
GPR**, IY reserved. z88dk decorations map to clang attributes **only under
`__LLVMZ80`** (`include/_DEVELOPMENT/.../compiler.h`):

| z88dk decoration | clang attribute | ABI |
|------------------|-----------------|-----|
| `__smallc` (= `smallc`) | `smallc` | stack args **left-to-right**, caller-clean, i16 return in HL |
| `__z88dk_callee` | `z88dk_callee` | stack args, callee-clean, right-to-left |
| `__z88dk_fastcall` | `z88dk_fastcall` | one arg in L/HL/DE:HL by width; return same |
| `__vasmallc` | `sdcccall(0)` | variadic; count returned in HL |

If this mapping is absent the attributes are no-ops and clang falls back to
`sdcccall(1)` → ABI mismatch and corrupt data. Since ravn/llvm-z80#279 the
`__ZPROTO*` clang branch is a plain natural-order `__smallc` prototype (identical
to the SDCC branch) — clang calls the classic `_name` workers directly, no
hand-asm bridge, no reversed params. Full detail: `CALLING_CONVENTION.md`.

---

## 6. Optimization levers (opt-level-gated `_fast` runtime variants)

Both are **`-O3`-only** (`CodeGenOptLevel::Aggressive`); every other level
(`-O0/-O1/-O2/-Os/-Oz`) and production (`-Os`) is untouched. SM83/gbz80 excluded.

- **`-O3` div/mod fast** (ravn/llvm-z80#244): i16 `__divhi3`/`__udivhi3`/`__modhi3`/
  `__umodhi3` → `_fast` variants (repeated-subtraction, ~2x on small-quotient
  code). On the z88dk route these `_fast` names are plain aliases of the same
  cores. See `__divhi3.asm`.
- **`-O3` 32-bit multiply fast** (ravn/llvm-z80#283): `__mulsi3` → `__mulsi3_fast`
  (signed-magnitude core hits the 32→16×16 demote for 16-bit-fitting operands).
  Measured **−42%** T-states on the mandelbrot demo; correct drop-in (byte-
  identical render). See the "32-bit multiply `-O3` fast path" section in
  `CALLING_CONVENTION.md`. Packaging: the crt0 libs must be rebuilt for the
  symbol to auto-resolve.

**Measured effect** (full mandelbrot demo, RC702 in MAME, `-nothrottle`,
`_main`→`_getk` bracket, 2026-08-08):

| Build | T-states | vs clang `-O2` |
|-------|----------|----------------|
| clang `-O2` (`__mulsi3`) | 1,192,734,124 | — |
| clang `-O3`, mul unchanged (isolation) | 1,192,734,175 | +0.0% |
| **clang `-O3` (`__mulsi3_fast`)** | **691,592,091** | **−42.0%** |
| sccz80 `-O2` | 934,494,391 | −21.7% |
| sccz80 `-O3` | 941,766,172 | −21.0% |

The isolation row (clang `-O3` linked against a `__mulsi3_fast` that calls the
*unsigned* core) is essentially identical to `-O2`, proving the **entire** win is
the multiply routing — not general `-O3`. With it, clang `-O3` beats sccz80 by
~26% here (once the multiply gap closes, clang's BSS locals + better `>>`
codegen dominate). Render output is byte-identical between `-O2` and `-O3`.

---

## 6b. Hosted by default — C-library optimisations & how to opt out (ravn/z88dk#57)

The `-compiler=llvmz80` compile line is **hosted** (zcc does **not** pass
`-ffreestanding`). Hosted mode lets clang's middle-end recognise C library
functions and optimise them — most valuably `printf("foo\n")` → `puts("foo")`
in InstCombine, plus constant-folding of `strlen`/`strcmp`/`abs`/`isdigit`… on
constant arguments. On bare-string-`printf`-heavy code this is worth **~20%**
(measured: a 7-`printf` banner program 7338 → 5881 B, **−19.8%**, correct output
under ntvcm).

These middle-end-**synthesized** calls (clang creates the `puts` declaration
itself) are made ABI-correct on the classic clib by the paired backend flag
`-mllvm -z80-classic-libc-cc`, which zcc also emits. It stamps the classic
`__smallc` calling convention (`CallingConv::Z80_SmallC` = cc132: stack args,
caller cleanup, return in DE) on those declarations, so the emitted call matches
the real `_puts`/`_strlen`/… routines. Without it, hosted mode would emit calls
with the default C CC and read stack garbage at runtime. Both flags are wired
into the config together (see `src/zcc/zcc.c`, the `-compiler=llvmz80` branch);
`-z80-classic-libc-cc` is off by default in the compiler and only turned on here.

**Requesting freestanding explicitly (outside zcc's config).** If you need
freestanding semantics — no libcall recognition, no `printf`→`puts`, no
constant folds of library functions (e.g. to guarantee every `printf` stays a
`printf`, or when not linking the classic clib) — pass it yourself on the zcc
command line with the `-Cg` clang-arg forwarder:

```sh
zcc +cpm -compiler=llvmz80 --math32 -O2 -Cg-ffreestanding -o prog prog.c
```

`-Cg<arg>` forwards `<arg>` straight to clang, appended **after** the config's
own flags; clang honours the **last** of `-ffreestanding`/`-fhosted`, so
`-Cg-ffreestanding` reliably overrides the hosted default with no rebuild
(verified: same banner program 5881 → 7338 B, i.e. back to the freestanding
size, output still correct). This is the supported way to select freestanding —
zcc no longer forces it, so the choice is the caller's.

---

## 7. Verification recipes

```sh
export ZCCCFG=…/z88dk/lib/config PATH=…/z88dk/bin:$PATH
export LLVMZ80EXE=…/llvm-z80/build-macos/bin/clang   # double/%f: add --math32, bridge auto-linked

# classic self-test matrix (ntvcm for stdout-only, MAME for file I/O):
sh test/clang/run_all.sh

# newlib_iy leg (setjmp is the one honest FAIL; file-open skipped = #34).
# ALWAYS set BOTH vars or a newlib run silently builds classic and hides gaps:
TEST_CLIB=newlib_iy ZCC_CLIB=newlib_iy sh test/clang/run_all.sh

# confirm direct _callee/_fastcall calls, no adapter ex de,hl (newlib):
zcc +cpm -clib=newlib_iy -O2 -S -o - t.c | grep -E 'call|ex de,hl'
```
