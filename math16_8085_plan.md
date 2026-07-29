# Plan: math16 8085 support

> **Status:** **complete** (implementation on branch `math16-8085`; ready for review/merge).  
> **Location:** z88dk repo root (this file).  
> **Updated:** 2026-07-29 (outcomes + benchmarks)  
> **Precedents:** math32 8085 work — PRs [#3020](https://github.com/z88dk/z88dk/pull/3020), [#3021](https://github.com/z88dk/z88dk/pull/3021)  
> **Skills:**  
> - [extended-usage](../8085-skills/.grok/skills/extended-usage/SKILL.md)  
> - [opcode-reference](../8085-skills/.grok/skills/opcode-reference/SKILL.md)  
> - [z88dk-tooling](../8085-skills/.grok/skills/z88dk-tooling/SKILL.md)  

---

## 0. Completed outcomes (summary)

| Deliverable | Result |
|-------------|--------|
| **`math16_8085.lib`** | Builds; install under `lib/clibs/` |
| **`--math16` + `-clib=8085`** | Links 8085 half cores; suite uses `--math16 -lmath32_8085` when harness needs float print helpers |
| **`test_math16_8085.bin`** | **13 run, 13 passed, 0 failed** (`z88dk-ticks -m8085`) |
| **Z80 math16 regression** | `test_math16.bin` still **13/13** after reorg |
| **Layout** | math32-like: shared `asm/`, CPU cores `asm/z80/` + `asm/8085/`, higher C `c/8085/` |
| **Hot cores** | Stack frames (no `exx`); extended ops; timed opts (see §12–13) |
| **Benchmarks** | classic sccz80 **math16** for z80 + 8085 on mandelbrot, n-body, spectral-norm (see §13) |

**Suite ticks (adjunct compute + harness I/O):**

| Suite | Ticks (latest) |
|-------|---------------:|
| Math16-8085 | **708 992** |
| Math16 Z80 | **522 079** |

---

## 1. Goal

Add **Intel 8085** support to the **math16** adjunct library (`libsrc/math/float/math16/`), producing **`math32`-style** product wiring, with a **complete sccz80 compiler interface**.

| Product | Role | Status |
|---------|------|--------|
| **`math16_8085.lib`** | Install under `lib/clibs/`; full **sccz80** half/`l_f16_*` bridge + cores | **Done** |
| **`--math16` with `-clib=8085`** | Links 8085 half product | **Done** |
| **`test/suites/math` recipe** | `test_math16_8085.bin` via ticks **`-m8085`** | **Done** |

### 1.1 Adjunct library — not a full float product

Math16 is an **adjunct / special-purpose** library (graphics, games, NN-style work: ~3.5 sig digits, **speed first**).

| In scope | **Out of scope** |
|----------|------------------|
| Arithmetic, compare, convert, poly, sqrt, common `*f16` maths | **stdio** float print/scan as a math16 deliverable |
| sccz80 expression codegen via `l_f16_*` / `cm16_sccz80_*` | Acting as the system “default” float lib |
| Extended **f24** internal path for accuracy of hot loops | Pairing **required** with math32 for library correctness |

**Explicit:** math16_8085 stands alone for compute. Suite/apps may still link math32_8085 for printf-style float conversion; that is harness convenience, not a math16_8085 requirement.

### 1.2 Compiler interfaces

| Client | 8085 product | Status |
|--------|--------------|--------|
| **sccz80** | `l_f16_*` → 8085 `asm_f16_*` / f24 | **Done** (primary gate) |
| **80cc** | Same `l_f16_*` names | Same ABI as sccz80 family (parity via shared helpers) |
| **sdcc surface** | Explicit `___h*` / converts in lists | Present in product lists (call-based API, as on Z80) |

---

## 2. Format model (unchanged contract)

### 2.1 External interface

Packed IEEE-like **binary16** in **HL**; bias 15; no subnormals; exp 0 → ±0; exp 31 → Inf/NaN.

### 2.2 Internal **f24**

```text
  d  = eeeeeeee          8-bit exponent, bias 127
  e  = s.......          sign in bit 7
  hl = 1mmmmmmm mmmmmmmm 16-bit mantissa with explicit leading 1
```

Pack/expand: **`asm_f16_f24`** / **`asm_f24_f16`** (shared algorithms; 8085 uses `add hl,hl` / field extract).

### 2.3 Higher-level C

8085 sccz80 compile → **`c/8085/`** (math32 pattern); Z80 product still uses Z80 lists/objects.

---

## 3. Layout (as shipped)

Mirrors math32:

```text
libsrc/math/float/math16/
  asm/                          # portable shared
    asm_f16_{zero,inf,nan,neg,sigdig}.asm
    coeff_f16_{atan,exp,exp10,exp2,log,sin}.asm
  asm/z80/                      # Z80/z180/z80n cores
  asm/8085/                     # 8085 cores (no exx/IX/IY)
  c/8085/                       # sccz80-generated higher funcs + 8085 bridges
  newlibfiles_8085.lst
  math16_8085_asm.lst
  Makefile → math16_8085.lib
```

| Shared (byte-identical / data-only) | CPU-specific |
|-------------------------------------|--------------|
| zero, inf, nan, neg, sigdig | mul, add, div, normalize, poly, sqrt, convert, abs (`res` vs `and`), … |
| `coeff_f16_*` (DEFQ rodata) | all f24 arithmetic |

---

## 4. Work packages — completion

### WP0 — Inventory & ABI freeze

- [x] Catalogue cores / `exx` use on Z80  
- [x] Confirm sccz80 half codegen on 8085  
- [x] Freeze f24 layout d/e/hl  

### WP1 — Tree reorganisation

- [x] `z80/` → `asm/z80/`; add `asm/8085/`  
- [x] Shared pure data/specials → `asm/`  
- [x] Update `*.lst` paths; Z80 `test_math16` green  

### WP2 — Product `math16_8085.lib` + sccz80 link path

- [x] Makefile `obj/8085/`, `-m8085`, `@newlibfiles_8085.lst`  
- [x] `math16_8085.lib` → `lib/clibs/`  
- [x] sccz80 bridges / higher API listed for 8085  
- [x] sdcc-named surface included in 8085 product lists  

### WP3 — Intrinsics (asm/8085)

- [x] Constants / classify / sign  
- [x] Convert f16↔f24, int/long  
- [x] Normalize / pack / compare  
- [x] Add / sub (stack second operand; dual-path sort, no stack `swap4`)  
- [x] Mul / mul2 / mul10 (`f16_8085_mulu_32_16x16`, `rl de` renormalize)  
- [x] Div (Newton inv + mul)  
- [x] frexp / ldexp / floor / ceil / discardfraction  
- [x] sqrt / poly  
- [x] Compiler bridges → 8085 cores  

### WP4 — Higher C (`c/8085/`)

- [x] sccz80 8085 compile of higher APIs  
- [x] Listed only in 8085 product  
- [x] Calls 8085 f24 mul/add/poly  

### WP5 — Tests & measurement

- [x] `test_math16_8085.bin` — **13/13**  
- [x] Z80 suite still **13/13**  
- [x] Hotspot profile + TIMER microbenches for hot cores  
- [x] Classic support/benchmarks math16 z80+8085 (mandelbrot, n-body, spectral-norm)  

### WP6 — Docs & cleanup

- [x] `math16/README.md` 8085 product notes  
- [x] `changelog.txt` math16 8085 line (beside math32)  
- [x] Algorithm / tick notes in this plan §12–13  

---

## 5. Performance work done (beyond initial port)

| Area | Change | Effect |
|------|--------|--------|
| **f24 add** | Dual-path large/small (no stack `swap4`); byte+bit align; commutative f16 entry | Large suite win early (~add was ~12% of suite) |
| **f24 mul** | Commutative f16 entry; keep Y in regs after push; synthetics `ld bc,hl` / `ld de,bc` | Setup traffic cut |
| **pack/expand** | Expand: field extract + `add hl,hl`×5; pack: `add hl,hl`×3 (overflow path keeps classic sticky C) | Hot convert path |
| **align ≫** | `sra hl` logical mant shift (sticky before `and` clears C; then bare `sra`) | Multi-bit align |
| **Synthetics** | `ld bc,hl`, `ld de,hl`, `ld hl,de`, `ex de,hl` for swaps | Size/clarity |
| **Extended mem** | `ld de,sp+*`, `ld hl,(de)`, `ld (de),hl` throughout stack traffic | Baseline 8085 style |

**Not winners (documented):** bare `sra` without sticky fix (broke Newton); pack overflow with `ld h,80h` while C still set; static scratch.

---

## 6. Non-goals (unchanged)

- Full IEEE half subnormals / round-to-even beyond Z80 math16 policy  
- Native sdcc `_Float16` operator codegen  
- stdio as a math16 product requirement  
- math32_8085 as a hard dependency of math16_8085 compute  
- 8080-only product  

---

## 7. Success criteria — checklist

1. [x] `math16_8085.lib` builds and installs  
2. [x] sccz80 half expressions → 8085 `l_f16_*`  
3. [x] `test_math16_8085` green under `-m8085`  
4. [x] Z80-family math16 tests still pass after reorg  
5. [x] 8085 sources: extended-usage, no `exx`/IX/IY temps, stack frames  
6. [x] Hot cores timed / optimised (add, mul, pack/expand, align)  
7. [x] Higher C on 8085 under `c/8085/`  
8. [x] README + changelog + this plan outcomes  
9. [x] Public API remains half/`_Float16` at the edge; f24 internal only  

---

## 8. Classic benchmarks (sccz80 math16)

Sources under `support/benchmarks/*/z88dk-classic/` accept `__MATH_MATH16` (`DOUBLE` → `_Float16`).  
Recipes and RESULT blocks in classic + parent `readme.txt`.

### Recipes

```bash
# z80
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints \
  <bench>.c -o <bench>.bin --math16 -lndos -m
z88dk-ticks <bench>.bin -x <bench>.map \
  -start TIMER_START -end TIMER_STOP -counter 999999999999

# 8085
zcc +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints \
  <bench>.c -o <bench>.bin --math16 -lmath32_8085 -lndos -m
z88dk-ticks -m8085 <bench>.bin -x <bench>.map \
  -start TIMER_START -end TIMER_STOP -counter 999999999999
```

### Why these benches

| Bench | Half range | Notes |
|-------|------------|--------|
| **mandelbrot** | Yes | Existing newlib math16; classic now has same `DOUBLE` hook |
| **n-body** | Yes with **DT=1e-1** | Same as newlib math16; invsqrtf16/sqrtf16 |
| **spectral-norm** | Yes | invf16/sqrtf16; N=100 norms stay in range |
| whetstone / pi / … | No | Outside half exponent / not float-hot |

### Measured ticks (2026-07-29, this tree)

| Bench | CPU | Library | Bytes† | Cycle count | @ 4 MHz |
|-------|-----|---------|-------:|------------:|--------:|
| n-body N=1000 | z80 | math16 | 4054 | **363 824 289** | 1 min 31 s |
| n-body N=1000 | 8085 | math16 | 3834 | **428 771 307** | 1 min 47 s |
| mandelbrot 60×60 | z80 | math16 | 3040 | **924 216 002** | 3 min 51 s |
| mandelbrot 60×60 | 8085 | math16 | 2988 | **1 142 010 284** | 4 min 46 s |
| spectral-norm N=100 | z80 | math16 | 3635 | **4 951 503 496** | 20 min 38 s |
| spectral-norm N=100 | 8085 | math16 | 3608 | **6 108 745 067** | 25 min 27 s |

† Approximate image size for `+test` ORG 0 (“bytes less page zero” style).

**Relative 8085 vs z80 (math16, same source flags):** ~1.18× n-body, ~1.24× mandelbrot, ~1.23× spectral-norm.

---

## 9. Reference paths

| Path | Notes |
|------|--------|
| `libsrc/math/float/math16/` | Source home |
| `libsrc/math/float/math16/asm/` | Shared specials + coeffs |
| `libsrc/math/float/math16/asm/8085/` | 8085 cores |
| `libsrc/math/float/math16/asm/z80/` | Z80 cores |
| `libsrc/math/float/math16/c/8085/` | Higher sccz80 8085 |
| `libsrc/math/float/math16/README.md` | f24 format + product notes |
| `test/suites/math/Makefile` | `test_math16_8085.bin` |
| `support/benchmarks/{mandelbrot,n-body,spectral-norm}/` | classic math16 recipes + RESULT |
| `changelog.txt` | math16 8085 headline line |
| `lib/clibs/math16_8085.lib` | Installed product |

---

## 10. Suggested PR strategy (historical)

| PR | Content | Status |
|----|---------|--------|
| Structure | Tree reorg + lists | Done on branch |
| Intrinsics + product + tests | WP2–WP3, WP5 | Done |
| Higher C + docs + benches | WP4, WP6, §8 | Done |

---

*End of plan — implementation complete on branch `math16-8085`.*
