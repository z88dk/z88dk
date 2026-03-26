# z80asm2 – Code Review Findings and Improvements

This directory documents the code review of the z80asm source code
(`src/z80asm/src/c/` and `src/z80asm/src/cpp/`) and tracks the improvements
applied as a result.

---

## Bugs Fixed

### 1. `expr1.c` – BUG_0041: Negative exponents silently returned 0

**File:** `src/z80asm/src/c/expr1.c`  
**Severity:** High – produces wrong assembly output without any diagnostic.

The exponentiation operator (`**`) returned 0 for negative exponents instead
of emitting an error. Integer arithmetic cannot represent fractional results,
so `2 ** -1` should be an error (not 0).

**Fix applied:** Added `error(ErrNegativeExponent, NULL)` before the silent
`return 0`. A dedicated `ErrNegativeExponent` error code was also added to
`errors.def` for a clear, descriptive message.

---

### 2. `alloc.c` – Memory block lost from tracking on fence-check failure in `m_realloc_`

**File:** `src/z80asm/src/c/alloc.c`  
**Severity:** Medium – memory block not freed at exit if program continues after fence error.

`m_realloc_()` removed the block from `g_mem_blocks` before checking fences.
If the fence check failed the function returned NULL (via `goto error`) while
the block was no longer tracked, causing a resource leak.

**Fix applied:** Re-add the block to `g_mem_blocks` at its original position
before triggering the `goto error` path.

---

### 3. `scan1.c` – Integer overflow in `scan_num()` with no diagnostic

**File:** `src/z80asm/src/c/scan1.c`  
**Severity:** Medium – silently produces truncated/wrong integer values for
numbers larger than `LONG_MAX`.

The function comment stated "range warning if greater than INT_MAX" but no
such warning was ever emitted.

**Fix applied:** Added a pre-multiplication overflow check. If
`value > (LONG_MAX - digit) / base`, a `warning(ErrIntRange, NULL)` is
emitted and the value is clamped to `LONG_MAX`.

---

### 4. `scan1.c` – `restore_scan_state()` / `drop_scan_state()` with empty stack causes NULL dereference

**File:** `src/z80asm/src/c/scan1.c`  
**Severity:** High – calling `restore_scan_state()` or `drop_scan_state()`
without a matching `save_scan_state()` leads to a NULL dereference crash.

`utarray_back()` returns NULL for an empty array; the code used the result
without checking it.

**Fix applied:** Added explicit checks with calls to `die()` giving descriptive
messages ("unbalanced save/restore") in both `restore_scan_state()` and
`drop_scan_state()`.

---

### 5. `utils2.cpp` – `ipow()` infinite loop for negative exponents

**File:** `src/z80asm/src/cpp/utils2.cpp`  
**Severity:** High – calling `ipow(base, negative_exp)` enters an infinite
loop due to arithmetic right-shift of a negative value never reaching zero.

**Fix applied:** Added an early `return 0` guard when `exp < 0`, matching
the return-value behaviour of the analogous C function `_calc_power()` in
`expr1.c` for negative exponents (the C++ path does not emit
`ErrNegativeExponent`).

---

### 6. `utils2.cpp` – `str_compress_escapes()` uses `char` for numeric accumulation

**File:** `src/z80asm/src/cpp/utils2.cpp`  
**Severity:** Low – undefined behaviour on most platforms for escape sequences
with byte values > 127 (e.g. `\xff`).

The local variable `c` used for octal/hex numeric accumulation was declared
as plain `char`. On platforms where `char` is signed, values 128–255 overflow,
which is undefined behaviour.

**Fix applied:** Changed `char c` to `unsigned char c` for the numeric
accumulation.

---

### 7. `scan2.cpp` – Signed/unsigned mixing in `ScannedLine::peek()` / `next()` / `peek_tokens()`

**File:** `src/z80asm/src/cpp/scan2.cpp`  
**Severity:** Medium – technically undefined/implementation-defined behaviour
when `m_pos + offset` wraps around.

`m_pos` is `unsigned` and `offset` is `int`. For negative `offset` with
`m_pos == 0` the arithmetic wraps to `UINT_MAX`, which accidentally returned
`end` (correct but fragile). For `next(n)` with a large negative `n`,
`m_pos` could wrap instead of being clamped to 0.

**Fix applied:** Added explicit signed arithmetic with bounds checks in all
three functions.

---

## Coupling / Maintainability Issues Fixed

### 8. `lstfile.h` – Unnecessary `#include "preproc.h"` pulling in the full preprocessor

**File:** `src/z80asm/src/cpp/lstfile.h`  
**Severity:** Low (coupling) – the list-file module only needs `Location` from
`errors.h`; pulling in `preproc.h` drags in `scan2.h`, `defines.h`, and all
their transitive includes, increasing compilation time and coupling.

**Fix applied:** Changed `#include "preproc.h"` to `#include "errors.h"`.

---

### 9. `utils2.cpp` – Search-engine URL left as a source comment

**File:** `src/z80asm/src/cpp/utils2.cpp`  
**Severity:** Low (maintainability) – a Bing search URL was used as the
comment for the `split()` function.

**Fix applied:** Replaced with a plain English description.

---

## Remaining Known Issues (not fixed in this review)

These issues were identified but left unchanged because they require broader
refactoring or affect stable, production-tested code paths.

| Issue | Location | Notes |
|---|---|---|
| Global scanner state (`sym`, `p`, `pe`, …) | `scan1.c` | Makes scanner non-reentrant; a full refactor to pass a context struct would be needed. |
| `CURRENTMODULE` / `CURRENTSECTION` global macros | `directives.c` + many files | Tight coupling to global state; needs dependency injection. |
| `cpu_rules_action.c` / `parse_rules.h` are auto-generated (>190k lines) | `src/c/` | Cannot be edited by hand; must be regenerated from `.rl` rules. |
| `m_realloc_()` loses original pointer on `realloc()` failure | `alloc.c` | `realloc` failure exits the program via `check_mem_die`, so no practical impact. |
| `a2i()` in `scan2.cpp` silently truncates values wider than `int` | `scan2.cpp` | Should use `long` or `unsigned long` and emit a warning. |
| `using namespace std` in every C++ header | `src/cpp/*.h` | Pollutes the global namespace for all includers; systematic change needed. |
| Magic bit-patterns in DMA directive implementation (>300 lines) | `directives.c` | Hard to verify correctness; should be split into separate functions with named constants. |
