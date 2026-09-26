# How llvmz80 (clang-z80) calls newlib correctly

Concise, verified contract for the `-clib=newlib_iy` / `-clib=newlib_ix` route
(`zcc +cpm -compiler=llvmz80 -clib=newlib_iy …`). Every claim below was checked
from source or emitted asm (dates = verification date), not assumed.

> Context: z88dk's own direction is that **classic is the way forward and newlib
> is compat-only** (maintainers, z88dk/z88dk#3022). This route makes llvmz80 use
> what newlib provides *today*; it deliberately does not extend newlib.

## The one rule that makes it work: honour the z88dk decorations

Every public newlib function is decorated `__smallc`, `__z88dk_callee`, or
`__z88dk_fastcall`. `include/_DEVELOPMENT/{proto,common}/sys/compiler.h` maps
those to real clang attributes **only under `__LLVMZ80`** (verified 2026-07-25):

| z88dk decoration   | clang attribute (via compiler.h) | ABI |
|--------------------|----------------------------------|-----|
| `__smallc`         | `sdcccall(0)`                    | stack args, **caller**-clean, i16 return in **HL** |
| `__z88dk_callee`   | `z88dk_callee`                   | stack args, **callee**-clean |
| `__z88dk_fastcall` | `z88dk_fastcall`                 | one arg in L / HL / DE:HL by width; return in the same |
| `__vasmallc`       | `__smallc` (→ sdcccall(0))       | variadic; return count in HL |

**If this mapping is absent the attributes are no-ops and clang falls back to its
default `sdcccall(1)` (HL/DE args, DE return).** Then clang and the sdcc-built
worker disagree on the ABI and calls corrupt data (classic symptom: a qsort
comparator scrambles the array). So: never gate this on bare `__clang__`
(ez80-clang also defines it and must keep the no-op mapping) — it is gated on
`__LLVMZ80`.

## Why no per-function adapter layer is needed (the newlib edge)

The newlib headers route the plain names to the native register/callee variants,
e.g. `#define memcpy(a,b,c) memcpy_callee(a,b,c)`,
`#define strlen(a) strlen_fastcall(a)` (fastcall). Because clang matches
`z88dk_callee`/`z88dk_fastcall` exactly, it calls those workers **directly**.
Verified (emitted asm, 2026-07-25): a `memcpy`/`strlen` TU emits
`call _memcpy_callee` and `call _strlen_fastcall` with **zero** `ex de,hl`
adapter modules. Contrast classic, which needs the hand-written
`libsrc/l/llvmz80/*.asm` adapters (`___memcpy` = `call asm_memcpy; ex de,hl; ret`)
because the old classic workers return in HL. This adapter directory is therefore
**not** used on the newlib route.

## What clang requires the workers to preserve: only IX

clang-z80's sole callee-saved GPR is IX (`Z80_CSR`); IY is reserved; the Z80
`CALL` clobbers A/BC/DE/HL/IY/FLAGS by construction. So a worker may trash any
register except IX. Audited (2026-07-23): no public newlib entry leaks IX
(stdio/malloc/string/atoi surface; `_printf` brackets `push ix`/`pop ix`,
`_fflush_fastcall` uses `ex (sp),ix`). Nothing extra for clang to do.

## Libcalls clang emits that newlib does not export

- **Integer** (`__mulsi3`, `__divhi3`, `__mulhi3`, `__divsi3`, `__divmodsi4`,
  `__udivqi3`, …): provided by `llvmz80_imath.lib` (this directory) — thin
  adapters over newlib's bundled `l_*` cores. Linked by the CLIB line.
- **Floating point** (`double` == `float` == `long double`, 32-bit IEEE-754):
  clang emits only single-precision compiler-rt libcalls (`__addsf3`, `__mulsf3`,
  `__floatsisf`, …). These are resolved by the auto-linked
  `llvmz80_fmath.lib` math32 bridge; pass `--math32` so the bridge's math32 cores
  are pulled in. No environment/config variable is needed.
- **`printf("%f")`**: stock printf formats llvmz80's 32-bit IEEE-754
  `double`/`float` through the same auto-linked `llvmz80_fmath.lib` bridge when
  linking with `--math32`. See #43.

## What NOT to rely on (deliberately not filled)

> Full list with symptoms + root cause + policy: **`KNOWN_GAPS.md`** (this
> directory). newlib is compat-only (classic is the forward direction), so newlib
> gaps for llvmz80 are **documented, not fixed** — see that file for the rationale.

- **Disk `FILE*` I/O** does not link on newlib (`asm_target_open` unimplemented
  tree-wide — ravn/z88dk #34, upstream z88dk/z88dk#3022): unsupported for now,
  use the classic clib for CP/M file I/O.
- **`<math.h>` / libm** — `<math.h>` fails to compile under llvmz80 (its
  `_FLOAT16_T` block typedefs `_Float16`, a reserved clang keyword unsupported on
  z80) AND, even guarded, newlib libm does not link (`_sqrt_fastcall` uses
  newlib's native float format, not clang IEEE-754 binary32; libm/transcendental
  entry points are not provided by the auto-linked `llvmz80_fmath.lib` math32
  bridge). Known gap — ravn/z88dk #37.

## Verification recipe (re-run to re-confirm any claim)

```
export ZCCCFG=…/z88dk/lib/config PATH=…/z88dk/bin:$PATH
export LLVMZ80EXE=…/llvm-z80/build-macos/bin/clang
# pass --math32 on programs that use double / float / %f
# ABI: confirm direct _callee/_fastcall calls, no adapter ex de,hl
zcc +cpm -clib=newlib_iy -O2 -S -o - t.c | grep -E 'call|ex de,hl'
# full matrix (24 PASS / 0 FAIL, only runtime_file skipped = #34):
TEST_CLIB=newlib_iy sh test/clang/run_all.sh
```
