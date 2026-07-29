# Plan: math16 8085 support

> **Status:** **approved** — implementation may proceed on branch `math16-8085`.  
> **Location:** z88dk repo root (this file).  
> **Updated:** 2026-07-29  
> **Precedents:** math32 8085 work — PRs [#3020](https://github.com/z88dk/z88dk/pull/3020), [#3021](https://github.com/z88dk/z88dk/pull/3021)  
> **Skills (keep top of mind):**  
> - [extended-usage](../8085-skills/.grok/skills/extended-usage/SKILL.md) — stack-only locals, no `exx`/IX/IY, 8085 extended ops; **performance-minded** sequences  
> - [opcode-reference](../8085-skills/.grok/skills/opcode-reference/SKILL.md)  
> - [z88dk-tooling](../8085-skills/.grok/skills/z88dk-tooling/SKILL.md) §1–6 measurement + **§9 copt** — **copt never runs on library `.asm`**; hand-write clean code; match file whitespace; A/B ticks for core choices  

---

## 1. Goal

Add **Intel 8085** support to the **math16** adjunct library (`libsrc/math/float/math16/`), producing **`math32`-style** product wiring, with a **complete sccz80 compiler interface**.

| Product | Role |
|---------|------|
| **`math16_8085.lib`** | Install under `lib/clibs/`; full **sccz80** half/`l_f16_*` bridge + cores |
| **`--math16` with `-clib=8085`** | Links `math16_8085` so C expressions on `half_t` / `_Float16` resolve |
| **`test/suites/math` recipe** | `test_math16_8085.bin` via ticks **`-m8085`** (correctness; optional TIMER microbenches for cores) |

### 1.1 Adjunct library — not a full float product

Math16 is an **adjunct / special-purpose** library (graphics, games, NN-style work: ~3.5 sig digits, **speed first**).

| In scope | **Out of scope** |
|----------|------------------|
| Arithmetic, compare, convert, poly, sqrt, common `*f16` maths | **stdio** float print/scan (`printf %f`, `atof`, dtoa for half) |
| sccz80 expression codegen via `l_f16_*` / `cm16_sccz80_*` | Acting as the system “default” float lib |
| Extended **f24** internal path for accuracy of hot loops | Pairing **required** with math32 for library correctness |

**Explicit:** there is **no requirement** that math16_8085 provide or depend on **printf / scanf / dtoa** support. Z80 math16 historically may be *used with* math32 for host I/O in apps; the **8085 math16 product itself must stand alone** for compute. Test harnesses may print integers or use any convenient I/O; that is not a library deliverable.

### 1.2 Compiler interfaces (mandatory deliverable)

Three client shapes exist on Z80 math16 today; **8085 must cover the same roles**, with cores in 8085 asm.

| Client | How half ops appear | Z80 path (mirror) | 8085 product |
|--------|---------------------|-------------------|--------------|
| **sccz80** | Native `half_t` / `_Float16` expressions → **`l_f16_*`** helpers | `lm16/c/sccz80/l_f16_*.asm`, `cm16_sccz80_*` | **Required** — primary classic 8085 compiler (`-clib=8085`) |
| **80cc** | Same sccz80-family half IR: `_Float16` ops lower to **`l_f16_*`** (HL RHS, stack LHS) | IR notes in `src/80cc/long_ir.c` (`f16_add` etc. → `l_f16_*`) | **Required check** — same `l_f16_*` symbols; use **80cc + `--math16`** as a second compiler gate that the sccz80 ABI is complete |
| **sdcc / zsdcc** | **Cannot generate native `_Float16` calls** | Explicit helpers: **`___hadd` / `___hmul` / `___hdiv` / …**, `___h2sint` / `___sint2h`, … under `lm16/c/sdcc/` + `c/sdcc/cm16_sdcc_*` | **Required surface** — same **named half API** as Z80 (not native expression codegen). Apps call library functions; do not expect the compiler to emit half operators |

#### sccz80 + 80cc (shared helper ABI)

Both expect the sccz80-family half convention:

```text
  RHS / single arg:  often HL = half
  LHS / 2nd arg:     stack (callee pops per __z88dk_callee)
  Return:            HL = half
  Helpers:           l_f16_add, l_f16_sub, l_f16_mul, l_f16_div,
                     l_f16_{lt,le,gt,ge,eq,ne}, l_f16_neg, l_f16_fabs, …
                     l_f16_*2f / l_f16_f2* style int/long conversions
```

| Layer | Path (Z80 today) | 8085 requirement |
|-------|------------------|------------------|
| Compiler helpers | `lm16/c/sccz80/l_f16_*.asm` | In `math16_8085.lib` → **8085** `asm_f16_*` / f24 cores |
| Callee/fastcall | matching `*_callee` | Same names/ABI as Z80 sccz80 half |
| Higher API | `c/sccz80/cm16_sccz80_*`, `lm16` | sccz80-callable; precompile for 8085 if needed |

**80cc check:** build/link a small `_Float16` expression program with **80cc** and `--math16` against `math16_8085.lib` (same helper names as sccz80). Undefined `l_f16_*` = incomplete interface. 80cc is a **parity check** on the sccz80 helper set, not a separate 8085 IR rewrite.

#### sdcc — explicit `_Float16` function surface (Z80 parity)

SDCC does **not** emit native half arithmetic. Z80 math16 therefore ships **explicit** entry points, e.g.:

| Kind | Examples (Z80 `lm16/c/sdcc/`) |
|------|------------------------------|
| Binary ops | `___hadd`, `___hsub`, `___hmul`, `___hdiv` (+ `_callee`) |
| Compare | `___heq`, `___hneq`, `___hlt`, `___hgt`, … |
| Convert | `___h2sint`, `___sint2h`, `___h2slong`, `___ulong2h`, … |
| Lib API | `sin`/`exp`/… half wrappers, `poly`, etc. as on Z80 |

**8085 must expose the same class of symbols** (implemented on 8085 cores), in line with the Z80 solution:

- Include **`lm16/c/sdcc`** (and `c/sdcc` bridges) in the 8085 library build **or** 8085-specific equivalents with **identical public names**.
- Document that sdcc users write **function calls** (or use whatever z88dk half wrappers exist), not raw `_Float16 a*b` codegen.
- Do **not** treat “no zsdcc 8085 backend” as an excuse to omit the Z80-style **explicit half API** from `math16_8085.lib` — that surface is part of math16’s multi-compiler contract.

#### Verification matrix

| Check | Pass criterion |
|-------|----------------|
| sccz80 `+test -clib=8085 --math16` | half expressions link; map → 8085 objects |
| 80cc + `--math16` | same `l_f16_*` resolve; smoke arithmetic OK |
| sdcc-style link | `___hmul` / `___hadd` / converts resolve from `math16_8085.lib` |
| nm | no Z80-only `exx` modules in the 8085 lib |

---


## 2. Format model (unchanged contract; restate for implementers)

### 2.1 External interface (compiler-facing)

Packed IEEE-like **binary16** (z88dk half):

```text
  HL = seeeeemm mmmmmmmm   (s=1, e=5, m=10 + hidden 11th)
  memory: little-endian half word
  bias 15; no subnormals; exp 0 → ±0; exp 31 → Inf/NaN
```

- **sccz80 (primary 8085 client):** RHS often in **HL**; LHS on stack (callee/fastcall as today). **This path must be complete.**  
- **zsdcc:** stack parameters (Z80-only — **no zsdcc 8085 path**).  
- Higher C math (`sinf16`, `expf16`, …) under `c/` / `lm16/`: see **§2.3** (Z80-only objects today; need an **8085 sccz80 compile**, same pattern as math32).

### 2.2 Internal extended path (**f24**)

As documented in `libsrc/math/float/math16/README.md`:

```text
  d  = eeeeeeee          8-bit exponent, bias 127 (binary32-scale)
  e  = s.......          sign in bit 7
  hl = 1mmmmmmm mmmmmmmm 16-bit mantissa with explicit leading 1
```

| Property | half (external) | f24 (internal) |
|----------|-----------------|----------------|
| Mantissa width | 11 (10+hidden) | **16** (natural on Z80/8085) |
| Exponent field | 5 bits (bias 15) | **8 bits** (bias 127, same scale as float32) |
| Purpose | ABI / storage | mul/add/div/NR/poly accuracy |
| Exit | — | **`asm_f16_f24`** packs/rounds/saturates to half |

User framing (project intent):

> math16 echoes math32, but `_Float16` at the compiler interface and an **extended 24-bit internal** path (8-bit exp + 16-bit mant) for many functions. A 16-bit mantissa is more natural on Z80/8085 than the half’s 11-bit field. The internal exponent can range like single float; **only on exit** is f24 converted back to `_Float16`/half.

**8085 cores must preserve this f24 ABI** (register layout d/e/hl) at internal call boundaries so Z80 and 8085 stay algorithmically comparable — only *implementation* of mul/add/shift changes.

### 2.3 Higher-level C functions (sccz80, CPU-specific objects)

Today’s math16 **higher functions** (trig, exp/log, pow, … under `c/*.c`, bridged via `c/sccz80/cm16_sccz80_*` and `lm16/`) are:

| Fact | Implication for 8085 |
|------|----------------------|
| Written in **C**, compiled with **sccz80** | Source can be shared; **objects are not** |
| Current precompiled / listed asm under `c/sccz80`, `c/asm`, `lm16/c/sccz80` is **Z80-specific** | Contains Z80 codegen (and may assume Z80 lib entry points); **must not** go into `math16_8085.lib` unchanged |
| Same situation as **math32** | math32 solved this with **`make -C c 8085`** → sccz80-generated asm under **`c/8085/`**, listed in `newlibfiles_8085.lst` |

**Required work (mirror math32):**

1. Add an **8085 sccz80 compile** of the higher C sources (Makefile target e.g. `make -C c 8085` under math16).  
2. Emit/store 8085 objects or assembler under e.g. **`c/8085/`** (or equivalent), linked only into **`math16_8085.lib`**.  
3. Ensure those compiles call **8085** `asm_f16_*` / f24 cores (and `l_f16_*` / poly), not Z80 `exx` paths.  
4. Keep Z80 product lists pointing at existing Z80 sccz80 outputs so classic `math16.lib` does not regress.  
5. No zsdcc compile of higher funcs for 8085 (sdcc uses the **explicit** half API; higher `sinf16`-style wrappers still need 8085-callable implementations — either from this sccz80 C compile or thin asm bridges).

Until WP4 is done, an 8085 lib that only has intrinsics is incomplete for full math16 API parity.

---

## 3. Lessons from math32 #3020 / #3021 (mirror this plan)

| math32 step | Apply to math16 |
|-------------|-----------------|
| Reorg: shared tables → `asm/` (or CPU-neutral); Z80 cores → `asm/z80/`; **8085 cores → `asm/8085/`** | Same: move `z80/` → `asm/z80/` (or keep `z80/` and add `asm/8085` if smaller delta — prefer **math32 layout** for consistency) |
| Shared 8080-compatible coeffs/constants | Coefficient tables (`coeff_f16_*`) + pure data → **common** list (no `exx`) |
| `newlibfiles_8085.lst` + `math32_8085_asm.lst` + hierarchical includes | Add **`newlibfiles_8085.lst`**, **`math16_8085_asm.lst`**, update **Makefile** product `math16_8085.lib` |
| Classic `z80_crt0s/newlib-8085.lst` pulls CPU mul helpers | Add math16 8085 mantissa helpers if any are listed the same way |
| C higher funcs: `make -C c 8085` → precompiled sccz80 asm in `c/8085/` | **Required:** current math16 higher C is sccz80 but **Z80-specific**; complete **8085 sccz80 compile** of `c/*.c` (and list into `math16_8085.lib`) |
| Compiler bridges | **sccz80 `l_f16_*`** + **sdcc explicit `___h*`** (Z80 parity); **80cc** checks same `l_f16_*` set |
| Remove AI HANDOFF from tree before merge | Keep this plan at root only while active; delete or archive at merge like math32 |
| Tests: `test_math32_8085.bin` | Add **`test_math16_8085.bin`** linking **`-lmath16_8085`** (no math32 dependency for the *library*; harness may print ints) |
| README + benchmarks | Document 8085, adjunct role, **no stdio claim**; TIMER A/B for hot cores |

---

## 3b. Performance mandate (graphics-oriented)

math16 is chosen for **speed**. On 8085, **mul, add, normalise, and poly** are first-class optimisation targets (same spirit as math32 8085 mul/add strategy work).

### Principles

1. **Correct first, then race maintainable variants** — suite green before claiming a winner.  
2. **A/B with z88dk-ticks** (`-m8085`, TIMER bounds, same `zcc` line) — see z88dk-tooling.  
3. **Map/nm proof** the timed symbol is the 8085 core under test.  
4. **Prefer readable 8085 extended-op code** that wins (or ties within noise) over clever but brittle Z80 ports.  
5. **copt does not clean library asm** — write the fast form yourself (no dead moves).  
6. Document chosen algorithm + rejected alternatives + tick deltas in README or commit notes.

### Cores to investigate (minimum set)

| Core | Why hot | Strategy candidates (investigate + time) |
|------|---------|------------------------------------------|
| **16×16 mantissa mul** (f24 mul kernel) | Every mul/fma/poly term | (a) Unrolled shift-add with zero-bit skip; (b) 8×8 partial products + accumulate (Z80 math16 style without HW mul); (c) hybrid: special-case power-of-two / small mant; (d) lessons from `f32_8085_mulu_32h_24x24` scaled to 16×16 |
| **f24 add/sub** | Align + add + renorm | (a) Byte/nybble shift trees (math32 style); (b) word `sra hl` / `add hl,hl` chains; (c) early-out equal exp / tiny addend |
| **normalise** (post-op) | After add/mul/div | (a) Loop with `add hl,hl` + exp--; (b) nibble/byte leading-one detect then bulk shift; (c) shared vs specialised post-mul vs post-add paths |
| **poly (Horner f24)** | Graphics curves, sin/exp tables | (a) Tight mul+add in registers/stack with minimal pack/unpack; (b) keep accumulator in f24 entire Horner; (c) degree-specialised small N; (d) coeff access via `ld de,hl+*` / pointer walk |

Also time **mul2 / div2 / mul10** if used heavily by higher funcs; treat as secondary.

### Timing harness (required for core choice)

```bash
# Example pattern — dedicated microbench or suite TIMER labels
zcc +test -clib=8085 -vn -DSTATIC -DTIMER -O2 --math16 \
  core_bench.c -o core_bench.bin -m -lndos -lmath16_8085
z88dk-ticks -m8085 core_bench.bin -x core_bench.map \
  -start TIMER_START -end TIMER_STOP -counter 999999999999
```

- Fix input vectors (mix of normals, near-1.0, edge exp).  
- Report cycles/op and size of the core object.  
- **Winner = best cycles among variants that stay maintainable** (clear frame comments, no static scratch, extended-usage compliant).  
- If two variants within ~3–5%, prefer the clearer one.

### What “performance” does *not* mean

- Sacrificing suite correctness or f24 exit rounding policy.  
- `exx` emulation via huge static banks.  
- Unreadable fully-unrolled 500-line mul with no residual rounding story.

---

## 4. Porting constraints (8085-skills + copt)

### 4.1 Hard constraints

1. **No `exx`, no IX/IY as temps** — Z80 math16 uses **`exx` / `ex af,af'` heavily** in mul/add/poly/sqrt. 8085 must re-map the second f24 operand to the **stack** (math32 8085 pattern: unpack → push frames → `ld de,sp+n`).  
2. **Stack-only locals/intermediates** — static/BSS only for true constants/tables.  
3. **No `pop af` for return addresses or live 16-bit values** — F bit 3 hardwired 0. Prefer explicit flag bytes on stack (math32 mul already does this).  
4. **Prefer 8085 extended ops** where legal: `ld de,sp+*`, `ld hl,(de)`, `ld (de),hl`, `sub hl,bc`, `rl de`, `sra hl`, K-loops.  
5. **Synthetics OK** for legibility (`ld bc,de`, `ld a,(hl+)`, …) if assembler expands to legal 8085.  
6. **Library asm is not copt’d** — remove dead `ld r,a`/`ld a,r` yourself; match **space-indented** style of existing math16/math32 cores (do not reformat to sccz80 tab style).  
7. **No Z80 CB multi-byte ops, `djnz`, `outi`, etc.**

### 4.2 f24 register discipline (proposal)

Keep Z80-documented layout for **one** live f24 in DE/HL:

| Field | Register |
|-------|----------|
| exp | **D** |
| sign | **E** bit 7 |
| mant | **HL** |

Second operand / product residual: **stack slots**, not alternate register set. Document frame layout in each core’s header comment (depth diagram), as math32 8085 does.

### 4.3 Mantissa multiply (core difficulty)

Z80 math16 builds 16×16→32 via staged 8×8 (shift-add or `mlt`/`mul de` on z180/z80n).

8085 needs:

| Helper | Role |
|--------|------|
| **`f16_8085_mulu_32h_16x16`** (name TBD) | High product for f24 mul (16×16 → top 16..24 bits + residual for round) |
| Optional **sqr** helper | If sqrt/poly benefits (math32 split sqr kernel) |

Reuse ideas from **`f32_8085_mulu_32h_24x24`** (shift-add / partial product trees), scaled down to 16×16. Prefer correctness + residual bits for rounding over micro-opts first.

---

## 5. Work packages (implementation order)

### WP0 — Inventory & ABI freeze (read-only)

- [ ] Catalogue every `z80/*.asm` public symbol and whether it uses `exx` / `ex af,af'`.  
- [ ] List C `*f16.c` entry points and which asm they call.  
- [ ] Confirm sccz80 half/`_Float16` codegen for **8085** (`+test -clib=8085` probe).  
- [ ] Freeze internal f24 layout + pack/unpack names (`asm_f24_f16`, `asm_f16_f24`, zero/inf/nan).

### WP1 — Tree reorganisation (like math32)

- [ ] Introduce `asm/z80/` (move current `z80/` cores) **or** keep `z80/` and only add `asm/8085/` if preferred smaller first PR — **recommendation: full math32-like split** so lists stay clear.  
- [ ] Shared pure data → `asm/` (coeffs, constants) if not already.  
- [ ] Update **all** existing `*.lst` paths so Z80/z180/z80n products **do not regress**.  
- [ ] Smoke: rebuild existing `math16.lib` / `math16_z80n.lib` / etc. and run `test_math16.bin`.

### WP2 — Build product `math16_8085.lib` + **sccz80 link path**

- [ ] `Makefile`: `obj/8085/`, `-m8085`, `@newlibfiles_8085.lst`, link `@math16.lst` → `math16_8085.lib`.  
- [ ] `newlibfiles_8085.lst` / `math16_8085_asm.lst` (common + 8085-only).  
- [ ] Install path: `lib/clibs/math16_8085.lib` (same pattern as `math32_8085.lib`).  
- [ ] Wire **zcc** so **`--math16` + `-clib=8085`** pulls `-lmath16_8085` (CPU-lib map / `@{ZCC_LIBCPU}`).  
- [ ] **sccz80 bridges:** `lm16/c/sccz80/l_f16_*`, `cm16_sccz80_*` → 8085 cores.  
- [ ] **sdcc explicit half API (Z80 parity):** `lm16/c/sdcc/___h*` / converts + `c/sdcc/cm16_sdcc_*` in the 8085 lib (same public names).  
- [ ] Link smoke **sccz80:** `half_t` / `_Float16` expressions → no undefined `l_f16_*`.  
- [ ] Link smoke **80cc:** `_Float16` IR helpers → same `l_f16_*` set.  
- [ ] Link smoke **sdcc surface:** `___hmul` / `___hadd` / key converts resolve (even if tests are call-based).  
- [ ] Classic `newlib-8085.lst` only if math16 objects are pulled that way for other CPUs today.  
- [ ] **Do not** require `-lmath32_8085` for math16_8085 to link or run compute tests.

### WP3 — Intrinsics (asm/8085) — bottom-up + **timed cores**

Order mirrors dependency (same spirit as math32):

1. **Constants / classify / sign:** zero, inf, nan, neg, abs, classify.  
2. **Convert:** f16↔f24, f24↔int/long (f16↔f32 **optional**, not for stdio).  
3. **Normalize / pack / error / compare** — **time normalise variants** (§3b).  
4. **Add / sub** — **time shift/align strategies** (§3b); stack second mant.  
5. **Mul / mul2 / mul10** — **time 16×16 kernel strategies** (§3b); pick maintainable winner.  
6. **Div / div2** (NR or restoring; residual as needed).  
7. **frexp / ldexp / floor / ceil / discardfraction.**  
8. **sqrt / poly** — **time Horner / f24-accumulator poly** (§3b).  
9. **Compiler bridges:** `l_f16_*` (sccz80/80cc) and **`___h*`** / converts (sdcc explicit API) → 8085 asm.

Gate each layer with small probes; for steps 3–5 and 8 attach TIMER A/B notes before locking the algorithm.

### WP4 — Higher C functions (8085 sccz80 compile — like math32)

Current higher-level sources under `c/*.c` are compiled with **sccz80 for Z80**; shipped bridges/objects are **Z80-specific**. An **8085 sccz80 compile** is a **required** deliverable (not optional polish).

- [ ] Makefile: **`make -C c 8085`** (or equivalent) producing **`c/8085/*.asm`** (or `.o` tree) via sccz80 `-m8085` / project flags.  
- [ ] List those outputs **only** in `newlibfiles_8085.lst` / math16 8085 product — do **not** mix into Z80 `math16.lib`.  
- [ ] Recompile all public higher APIs: `sinf16`, `cosf16`, `tanf16`, `asin`/`acos`/`atan`/`atan2`, `exp`/`exp2`/`exp10`, `log`/`log2`/`log10`, `pow`, `hypot`, etc. as present on Z80 math16.  
- [ ] Link against **8085** intrinsics (f24 mul/add/poly); fix any codegen that assumes Z80-only runtime.  
- [ ] Accuracy: match Z80 math16 policy (f24 path); tighten only if suite fails.  
- [ ] Prefer hot path through timed f24 mul/add/poly; avoid needless pack/unpack in Horner.  
- [ ] **No integer-only fast paths** that diverge ABI unless proven on both CPUs (math32 pow lesson).

### WP5 — Tests & measurement

- [ ] `test/suites/math`: `test_math16_8085.bin`  
  - compile with **`-lmath16_8085`** and sccz80 8085; **no hard dependency on math32** for pass/fail of half ops  
  - run: `z88dk-ticks -m8085`  
- [ ] Expect `N run, N passed, 0 failed`.  
- [ ] **Required for WP3 hot cores:** TIMER microbenches (mul/add/normalise/poly) comparing strategy candidates; record winner + ticks.  
- [ ] Map/nm: 8085 symbols only (no Z80 `exx` objects).  
- [ ] sccz80 interface test: expressions using half arithmetic link cleanly.

### WP6 — Docs & cleanup

- [ ] Update `math16/README.md`: 8085 product; **adjunct / no stdio**; f24 internal path; sccz80 `--math16` usage; build lines; no zsdcc.  
- [ ] Document chosen mul/add/normalise/poly algorithms and tick comparisons.  
- [ ] Changelog / small reviewable commits.  
- [ ] Remove temporary AI notes; plan file policy as math32 HANDOFF (keep during work, drop or archive at merge).

---

## 6. Non-goals (this effort)

- Full IEEE half **subnormals** or round-to-even (unless already required on Z80 math16).  
- Native **sdcc `_Float16` operator codegen** (impossible / not supported — use **explicit** half functions instead, as on Z80).  
- **stdio / printf / scanf / dtoa** support for half (adjunct library — apps use integers or another float lib if they must print).  
- Requiring **math32_8085** as a dependency of math16_8085.  
- Replacing math32/math48 as the system float library.  
- 8080-only product (8085 extended ops allowed; 8080 may come later as subset).  
- Optimising for z180/z80n mul hardware in the 8085 tree.

---

## 7. Risk register

| Risk | Mitigation |
|------|------------|
| Heavy `exx` in Z80 mul/add | Stack frames + DE pointers; port one core at a time |
| Rounding differences | Explicit residual bits; compare against Z80 vectors in suite |
| f16↔f32 bridge | Optional only; not required for adjunct compute or sccz80 half ops |
| Higher C still Z80-only objects | Dedicated **8085 sccz80 compile** (math32 `c/8085` pattern); keep list files CPU-split |
| C helper sccz80 quality | Precompile under `c/8085`; copt does not clean that asm either |
| Path reorg breaks Z80 libs | WP1 green `test_math16.bin` before any 8085 code |
| Scope creep (full lib at once) | WP3 ordered gates; mergeable “intrinsics only” PR then “C funcs” |

---

## 8. Success criteria

1. **`math16_8085.lib`** builds and installs beside other math16 CPU libs.  
2. **Compiler interfaces complete:**  
   - **sccz80:** native half expressions → `l_f16_*` (8085).  
   - **80cc:** same `l_f16_*` set resolves (parity check with `--math16`).  
   - **sdcc surface:** explicit `_Float16` helpers (`___h*`, converts, …) present as on Z80 — SDCC has no native half codegen.  
3. **`test_math16_8085`** passes under ticks `-m8085` **without** requiring math32 for the library under test.  
4. Existing **Z80-family math16** tests still pass after reorg.  
5. 8085 sources obey **extended-usage** + **no dead moves** (copt discipline).  
6. **Hot cores** (mul, add, normalise, poly): at least two strategies considered each; TIMER A/B recorded; maintainable winner selected.  
7. **Higher C on 8085:** sccz80 rebuild of current Z80-only higher functions into **`c/8085/`** (math32-style); full public `*f16` API links on 8085.  
8. README: f24 path, 8085 product, **adjunct / no stdio**, sccz80/80cc/sdcc surfaces.  
9. Public API remains half/`_Float16` at the edge; extended format is **internal only**.

---

## 9. Suggested PR strategy

| PR | Content |
|----|---------|
| **PR A** (structure) | Tree reorg + list/Makefile only; no behaviour change on Z80 |
| **PR B** (#3020-analogue) | 8085 intrinsics + `math16_8085.lib` + basic tests |
| **PR C** (#3021-analogue) | Higher C, accuracy fixes, README, cleanup |

---

## 10. First implementation commit (after approval)

1. Create branch e.g. `math16-8085`.  
2. Stage this plan at repo root (this file).  
3. Execute **WP1** only; land green Z80 tests.  
4. Then WP2–WP3 add/mul skeleton.

---

## 11. Reference paths

| Path | Notes |
|------|--------|
| `libsrc/math/float/math16/` | Source home |
| `libsrc/math/float/math16/z80/` | Current Z80 cores (→ `asm/z80/`) |
| `libsrc/math/float/math16/README.md` | f24 format + calling convention |
| `libsrc/math/float/math32/asm/8085/` | Template for 8085 style |
| `libsrc/math/float/math32/readme.md` | Product/layout documentation model |
| `test/suites/math/Makefile` | Add 8085 math16 recipe |
| `lib/clibs/math32_8085.lib` | Sibling product only — **not** required by math16_8085 |

---

*End of plan — approved on branch `math16-8085`; implement WP0–WP6 in order.*
