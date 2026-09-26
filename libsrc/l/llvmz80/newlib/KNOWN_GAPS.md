# newlib + llvmz80: known gaps (documented, not fixed)

**Scope of this document.** It lists what is *known not to work* when compiling
with `-compiler=llvmz80` against the newlib clibs
(`-clib=newlib_iy` / `-clib=newlib_ix`), and *why*, so that a user hitting one of
these does not re-diagnose it from scratch.

## Why these are documented rather than fixed

z88dk's maintainers hold that **newlib is not a supported target in its own
right** — the forward direction for the C library is **classic**, and newlib is
kept only as a compatibility layer (z88dk/z88dk#3022; ravn/z88dk#34 comment
thread). Consequently, a missing or broken feature *specific to the newlib route*
for llvmz80 is **not a defect we fix by extending newlib**. The agreed policy is:

- **Use classic** (`-clib=default` / the classic CP/M route) for anything the
  newlib route cannot do — that is the sanctioned path and it is fully green.
- **Document the newlib gap here** (with the reproduction and root cause) instead
  of filing it as a bug to fix or patching newlib.
- Only close a gap on the newlib route when it is *cheap, self-contained, and
  does not extend newlib's own surface* (e.g. adding a clang-libcall bridge that
  lives entirely under `libsrc/l/llvmz80/newlib/`, as was done for `memmove_rt`).

This mirrors the newlib README's "What NOT to rely on" section
(`libsrc/l/llvmz80/newlib/README.md`) and expands it into a single reference.

---

## Known gaps (newlib route, llvmz80)

| # | Feature | Symptom | Root cause | Status / workaround |
|---|---------|---------|------------|---------------------|
| 1 | **Disk `FILE*` I/O** (`fopen` of a real file) | link error: `asm_target_open` (and `_p1`/`_p2`) undefined | The CP/M newlib target ships **no file-open driver**; the hook is unimplemented tree-wide, for all compilers | ravn/z88dk#34 (WONTFIX / out of scope). **Use classic** for CP/M file I/O — the FILE\* layer works there. |
| 2 | **`<math.h>` / libm** | (a) header won't compile: `error: _Float16 is not supported on this target`; (b) even guarded, link error `_sqrt_fastcall`, `___fixsfsi` undefined | (a) `<math.h>`'s `_FLOAT16_T` block `typedef short _Float16` — `_Float16` is a reserved clang keyword unsupported on z80. (b) newlib libm uses its **own float format**, not clang IEEE-754 binary32; libm/transcendental entry points are not provided by the auto-linked `llvmz80_fmath.lib` math32 bridge | ravn/z88dk#37 (known gap). clang `double`/`float` use the auto-linked `llvmz80_fmath.lib` math32 bridge with `--math32`, never newlib math. |
| 3 | **`setjmp` / `longjmp`** | `setjmp(env)` returns **nonzero** on the initial call → control jumps straight to the `longjmp` branch | `<setjmp.h>` maps `setjmp(env)` → `l_setjmp(&env)`, and `l_setjmp` is decorated `__SMALLC`; under clang the direct call reads the sccz80 stack-worker return from the wrong place (same HL-vs-DE / `__smallc`-mapping ABI class as the now-fixed regex #39 and fcntl #23) | Open, **left visible** (honest FAIL in `test/clang` newlib_iy leg). NOT force-fixed: setjmp/longjmp register save-restore makes a wrong fix dangerous. **Use classic** — classic `setjmp` PASSES. |
| 4 | **`-clib=new` alias wiring** | historic: unresolved `_printf`, `_calloc_callee`, `_malloc_fastcall`, … at link | The generic `-clib=new` alias did not select an llvmz80 newlib link-library set | ravn/z88dk#18. The **sanctioned route is the explicit `-clib=newlib_iy` / `-clib=newlib_ix`**, which is wired and green (35 PASS in `test/clang`). Prefer the explicit clib name. |

### Not gaps — classic-only z88dk extensions (by design)

These are absent from the newlib `_DEVELOPMENT` headers because they are z88dk
**classic-clib extensions**, not standard C, so their absence on the newlib route
is expected, not a defect:

- **`isqrt` / `unbcd`** (`<stdlib.h>`) — declared only in the classic
  `include/stdlib.h`. Use classic if you need them.

---

## What works on the newlib route (for contrast)

So this document is not read as "newlib is broken": the newlib route is otherwise
green (`test/clang` newlib_iy 35 PASS / 0 FAIL). Verified working: `string.h`,
`ctype`, `stdlib` (malloc/calloc/realloc/free/atoi/qsort/…), the full `stdio`
**FILE\*** API surface *except real disk open* (console/stream I/O works),
integer libcalls (via `llvmz80_imath.lib`), 32-bit IEEE-754
`double`/`float` compiler-rt libcalls (via the auto-linked
`llvmz80_fmath.lib` math32 bridge with `--math32`), and stock `printf("%f")`
with `--math32` (ravn/z88dk#43, CLOSED). ABI contract and the exact decoration→attribute mapping
are in `README.md` in this directory.

## Re-confirming any row

```
export ZCCCFG=…/z88dk/lib/config PATH=…/z88dk/bin:$PATH
export LLVMZ80EXE=…/llvm-z80/build-macos/bin/clang
# pass --math32 on programs that use double / float / %f
# full newlib_iy matrix (setjmp is the one honest FAIL; file-open skipped = #34):
TEST_CLIB=newlib_iy ZCC_CLIB=newlib_iy sh test/clang/run_all.sh
```

> Note: a test reads `${ZCC_CLIB:-}`; running with only `TEST_CLIB=newlib_iy`
> silently builds **classic** and hides newlib-route failures. Always set BOTH
> `TEST_CLIB` and `ZCC_CLIB` (or go through `run_all.sh`).
