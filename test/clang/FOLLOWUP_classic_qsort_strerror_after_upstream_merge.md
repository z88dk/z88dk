# Follow-up: 2 classic clang regressions from the 2026-07-23 upstream merge

**STATUS: BOTH RESOLVED 2026-07-24.**  qsort (#33) and strerror (#32) now PASS
on the classic clang path; as a bonus the standard 5-arg `bsearch` gap closed
too (xfail_bsearch retired → `runtime_bsearch`, PASS on classic AND newlib_iy).
Classic clang suite: 24 PASS / 0 FAIL.  newlib_iy: 23 PASS / 0 FAIL.  See the
per-item "FIX" notes below.

Merging `upstream/master` (commit `b6ce4aedc6`) into ravn/master brought in new
library implementations that two ravn llvmz80 classic bridges were built against.
On the **classic** clib path (`-clib=default`, `-compiler=llvmz80`) two tests
failed; **newlib was unaffected** (newlib_iy all green). Not in the production
firmware path (rcbios/autoload/CP-NET/cpnos don't use qsort/strerror).

Nothing here blocked the signed-mod fix, which is done (see
`BUG_newlib_signed_mod.md`).

**Tracking issues:** qsort → ravn/z88dk **#33**; strerror → ravn/z88dk **#32**
(pre-existing; commented with the post-merge manifestation).

## 1. runtime_qsort — comparator ABI mismatch with upstream's redesigned qsort  (#33)

Upstream replaced the classic qsort machinery (`qsort_sccz80`/`qsort_sdcc`/
`qsort_sdcc_callee`, all deleted) with a single sort core plus **per-compiler
comparator thunks**: each compiler links a distinct entry (`qsort` for sccz80,
`_qsort` for sdcc) that builds a closure on the stack passing the comparator
address in `ix`; the shared core does `call l_jpix`, landing on the thunk
(`l_cmp_sccz80` / `l_cmp_sdcc`) which marshals the two operands in the
compiler's argument order. See `libsrc/classic/stdlib/qsort.asm`,
`_qsort.asm`, `qsort_core.asm`.

ravn's old integration (an `stdlib.h` `__qsort_llvmz80` inline that reversed the
args and called the now-deleted `qsort_sdcc_callee`, plus a `__smallc`
comparator requirement) was dropped in the merge (took upstream's `stdlib.h`).
Now `_qsort` links (from `z80_crt0.lib`) but the comparator is invoked with the
wrong convention → the program runs but produces no/garbage output.

**FIX (2026-07-24):** route (a).  Two coupled ABI facts, both handled purely in
`include/stdlib.h` under `#if defined(__LLVMZ80)` — no new asm, no lib rebuild:
1. **Comparator convention.** The comparator must be `__smallc` (`l_cmp_sdcc`
   marshals the two operands on the STACK, not in registers).  `runtime_qsort.c`
   already declared `cmp_asc`/`cmp_desc` `__smallc`; the prototype now types the
   `compar` parameter as a pointer-to-`__smallc`-function so clang's
   `-Wincompatible-function-pointer-types` is satisfied.
2. **Argument order.** clang's `__smallc`/`sdcccall(0)` pushes qsort's four args
   right-to-left, but the `_qsort` asm entry expects the z88dk left-to-right
   order (base deepest, compar on top).  Fix: a reversed-argument alias
   `__qsort_llvmz80(compar,size,nmemb,base)` bound to the existing `_qsort`
   symbol via an `__asm("qsort")` label (clang re-prepends `_`), plus a macro
   `#define qsort(base,nmemb,size,compar) __qsort_llvmz80(compar,size,nmemb,base)`
   that swaps the order back.  Verified `call _qsort` with compar on top.
`runtime_qsort.c` header rewritten to describe the two facts.  Same treatment
applied to `bsearch` (`__bsearch_llvmz80` → `_bsearch`, 5 args).

## 2. runtime_strerror — `__rodata_error_strings_head` not pulled  (#32)

Upstream's `libsrc/string/z80/asm_strerror.asm` references
`__rodata_error_strings_head`. ravn's `libsrc/l/llvmz80/__strerror_table.asm`
DEFINES that symbol (it is present in `z80_crt0.lib` — 11 bridge/qsort symbols
confirmed), but the link fails `undefined symbol: __rodata_error_strings_head`:
the defining module is not pulled on-demand across the `cpm_clib.lib` →
`z80_crt0.lib` boundary in the current link order.

**FIX (2026-07-24):** the real cause was simpler than "not pulled across a lib
boundary".  `z88dk-z80nm` showed `__strerror_table` was **not in z80_crt0.lib at
all** — its `__rodata_error_strings_head` appeared only as an `U` (undefined
extern from `asm_strerror`), never a `G`.  A stale comment in
`__strerror_table.asm` claimed the module was pulled via a "buildcrt obj-glob"
and must NOT be in `llvmz80.lst`; that was wrong — the glob never included it.
Fix: add `${NEWLIB_ROOT}l/llvmz80/__strerror_table.asm` to
`libsrc/l/llvmz80.lst` (exactly like the sibling `__divhi3`/`__itoa` bridges,
which `newlib-z80.lst` pulls into z80_crt0.lib), then rebuild:
`make -C libsrc TARGETS=z80 clean && make -C libsrc TARGETS=z80 && make -C libsrc
install`.  No double-inclusion risk: no classic module declares `section
rodata_error_strings` (so z80asm generates no auto section-start symbol to
clash), and the clang **newlib** route (`-clib=newlib_iy`, `-nostdlib`) never
links z80_crt0.lib — it keeps using newlib's own section-start symbol from
`lib/crt/newlib/clib_rodata.inc`.  Comment in `__strerror_table.asm` corrected.

> NB: `make -C libsrc TARGETS=z80 clean` also wipes the gitignored **newlib**
> `.lib` artifacts (`libsrc/newlib/lib/{sccz80,sdcc_ix}/*.lib`).  Rebuild them
> with `make -C libsrc/newlib cpm` afterwards or newlib links fail with
> `file not found: cpm.lib`.

## Rebuild notes captured this session (for whoever picks this up)

- The lib toolchain is **native** (no Docker): `z88dk-sccz80`, `z88dk-zsdcc`,
  `z80asm` in `bin/`. The old CLAUDE.md "z88dk via Docker" note was stale.
- `make -C libsrc TARGETS=cpm` builds `cpm_clib.lib`; `TARGETS=z80` builds
  `z80_crt0.lib` (which holds the l/llvmz80 bridges + qsort); `make -C libsrc
  install` copies `libsrc/*.lib` → `lib/clibs/`. newlib: `make -C libsrc/newlib
  cpm`. z80asm `-d` reuses stale `.o`, so `*-clean` (or `make -C libsrc clean`)
  before a source-changing rebuild.
- Fixed en route: ravn's `libsrc/stdlib/c/sccz80/strtol.asm` used `IX` under a
  bare `IF __CLASSIC`, breaking the 8080/8085/gbz80 classic builds; now guarded
  `IF !__CPU_INTEL__ && !__CPU_GBZ80__` (clang only targets Z80).
