---
name: library-am9511
description: >
  Am9511A (Intel 8231A) APU float library: IEEE host format vs APU format,
  pushf/popf status mapping, IEEE-side specials, classic/newlib link flags,
  multi-product rebuild. Use when editing libsrc/math/float/am9511, APU I/O,
  or measuring --math-am9511 / --am9511.
---

# Library — am9511 (Am9511A APU)

Home: `libsrc/math/float/am9511/`.  
Product docs of record: `libsrc/math/float/am9511/readme.md`.  
**Vendor datasheets / app notes (canonical):** external repo
[z88dk/techdocs](https://github.com/z88dk/techdocs) → **`amd/am9511a/`**
(not under this product tree).

## When to load this skill

- Editing `asm/am32_*.asm`, `asm/z80/` or `asm/8085/` push/pop/classify, or `am32_fspecial.asm`
- Wiring `--math-am9511` / `--am9511` / classic `--math-am9511_8085`
- Debugging Inf/NaN, divide-by-zero, sqrt(neg), or wrong zero after APU ops
- Comparing am9511 vs math32 TIMER (hardware APU vs software float)

## Link / flags

| Audience | Typical flags |
|----------|----------------|
| Classic z80 | `--math-am9511` or `--am9511` (alias); needs APU at the port map in config |
| Classic 8085 | `--math-am9511_8085` (or target docs’ 8085 APU recipe) |
| Newlib | `--am9511` / `-lam9511` with IEEE float mode as in readme |
| Host emulator | `z88dk-ticks` includes an Am9511 model (`src/ticks/am9511.c`); ports **0x42/0x43** default |

Products (via `libsrc/math/float/am9511/Makefile`): `am9511.lib`, `am9511_8085.lib`,
`am9511_ixiy.lib`, `am9511_z180.lib`, `am9511h.lib` (helper). Install into
`lib/clibs/` after rebuild.

Header: `include/math/math_am9511.h` (`isinf`/`isnan` via `fpclassify`).

## Architecture (short)

| Layer | Role |
|-------|------|
| **Host IEEE-754 single** | What C and the rest of z88dk use (DEHL / stack) |
| **pushf / popf** | Convert IEEE ↔ Am9511 stack format; **popf** maps APU **status** → IEEE 0 / ±Inf / NaN |
| **APU ops** | FADD/FSUB/FMUL/FDIV/SQRT/… on the chip (or ticks model) |
| **`am32_fspecial.asm`** | **IEEE-side** specials (exp 0 / 255) **before** push — APU has **no Inf/NaN** |
| **lam32 / c/sccz80 / c/sdcc** | Compiler bridges and higher C functions |

APU float: 24-bit mantissa, **unbiased 7-bit** exp (−64…+63), sign bit, **normalised**
(or all-zero). Range about **±(2.7×10⁻²⁰ … 9.2×10¹⁸)** and zero — **much smaller
than IEEE**. Out-of-range IEEE values are clamped on push (max/zero); do not
expect chip-native Inf. Chip value is *mantissa × 2^exponent* with
**0.5 ≤ |mantissa| < 1** (binary point left of bit 23).

### Host bus / I/O (datasheet interface)

All transfers are 8-bit. Host selects **command vs data** with **C/Ḋ** (plus
**RḊ/WṘ**, **CṠ**). Typical programmed-I/O decode in z88dk:

| Access | Port (classic default) | Meaning |
|--------|------------------------|---------|
| Data | `__IO_APU_DATA` = base (often **0x42**) | Push/pop stack bytes |
| Status / command | `__IO_APU_STATUS` = base+1 (**0x43**) | Read status; write command |

**Byte order (critical for pushf/popf):**

- **Push** operand: **LSB first**, MSB last (4 bytes for float / 32-bit).
- **Pop** result: **MSB first**, LSB last.
- Wrong count or order **misaligns** the internal byte pointer (LIFO wrap).

Stack capacity: **8 × 16-bit** or **4 × 32-bit/float** entries. **TOS** = top,
**NOS** = next. Binary float ops take TOS and NOS, write result to NOS, pop
(stack moves up). Many **derived** ops (trig, log, …) also use lower stack as
**scratch** — lower values can be destroyed (see algorithm brief / command
“stack contents after” diagrams).

**Command byte** (single 8-bit write to status/command port):

```
 bit7 SVREQ(sr) | bit6–5 format | bit4–0 operation
```

| bit6–5 | Format |
|--------|--------|
| `00` | Floating-point 32-bit (FADD…, SQRT…) |
| `01` | Fixed 32-bit (DADD…) |
| `1x` | Fixed 16-bit (SADD…) — bit5=1, bit6 selects single |

Bit **7 = SVREQ**: if set, **SVREQ** pin asserts when the command completes
(until SVACK or a later cmd with sr=0). Library float ops normally use **sr=0**
(hex codes `10` FADD, `12` FMUL, `13` FDIV, `01` SQRT, …).

**END** pin (and SVREQ) mark completion; library float path usually **polls
BUSY** in status instead of using END/SVREQ interrupts. Issuing a new command
while busy is allowed by the bus but **PAUSE** stays low until the current op
finishes.

### APU I/O macros (`config_am9511_private.inc`)

Always use these (or the same ports) — do **not** hard-code ports in new code
unless writing a multi-APU `am32_stack/*` clone.

| Macro | Normal (`!__AM9511_HELPER_FUNC`) | Helper (`__AM9511_HELPER_FUNC` / `am9511h`) |
|-------|----------------------------------|--------------------------------------------|
| `AM9511_IN_APU_STATUS` | `in a,(__IO_APU_STATUS)` | `call __am9511_in_status` |
| `AM9511_IN_APU_DATA` | `in a,(__IO_APU_DATA)` | `call __am9511_in_data` |
| `AM9511_OUT_APU_CONTROL` | `out (__IO_APU_STATUS),a` | `call __am9511_out_control` |
| `AM9511_OUT_APU_DATA` | `out (__IO_APU_DATA),a` | `call __am9511_out_data` |

**z80** hot push/pop often use **`in r,(c)` / `outi` / `out (c),…`** with
`BC = __IO_APU_DATA` for speed — those paths **bypass** the data macros (status
still uses `AM9511_IN_APU_STATUS`). **8085** push/pop use the macros throughout.
Helper product: `am9511_io.asm` + `-D__AM9511_HELPER_FUNC`.

### Status register (must know for popf)

Datasheet layout (**only valid when BUSY=0**; while BUSY=1 other bits are
**undefined** — do not decode ERROR/ZERO/SIGN off a busy-rotated A):

```
BUSY(7) | SIGN(6) | ZERO(5) | ERROR[4:1] | CARRY(0)
```

**ERROR is a 4-bit code**, not four independent sticky bits:

| Code (b4…b1) | Mask | Meaning |
|--------------|------|---------|
| `0000` | — | No error |
| `1000` | `0x10` DIV0 | Divide by zero |
| `0100` | `0x08` NEGRT | Sqrt/log of negative |
| `1100` | `0x18` | asin/acos / eˣ domain |
| `XX10` | `0x04` UNDFL | Underflow |
| `XX01` | `0x02` OVRFL | Overflow |

Defines: `libsrc/newlib/target/am9511/config_am9511_private.inc`
(`__IO_APU_STATUS_*`). Status may be read **while a command runs** (BUSY=1);
only BUSY is meaningful then. Continuous status reads can also clear the END
flip-flop — prefer one wait-for-BUSY-clear then a **clean** status sample.

**Do not edit generated `config_am9511_{private,public}.inc` / `.h` alone.**
Source of truth: `libsrc/newlib/target/am9511/config/config_am9511a.m4`
(included from `config.m4`; also pulled into **yaz180** `libsrc/target/yaz180/config.m4`).
Regenerate via `libsrc/newlib` Makefile (`make am9511` config step) or:

```bash
cd libsrc/newlib
m4 -DCFG_ASM_DEF -I../../src/m4 -I. -I.. target/am9511/config.m4 \
  > target/am9511/config_am9511_private.inc
# similarly CFG_ASM_PUB → public.inc, CFG_C_DEF → config_am9511.h
# yaz180: same flags on ../target/yaz180/config.m4 → config_yaz180_*.inc / .h
```

**popf policy (library):** re-read status after data pop; trap **ZERO|ERROR**
before bias convert (APU zero is not a valid “normal” am9511_float for that
path). OVRFL → ±Inf; UNDFL/ZERO → 0; DIV0 → ±Inf for residual chip divides;
NEGRT → NaN. **0/0 → NaN** and full Inf/NaN algebra for IEEE inputs are
**software specials**, not APU encodings.

### Datasheet op notes (library-relevant)

Binary float ops: **TOS** and **NOS** operands; result replaces NOS; stack pops
one level. Status affected: Sign, Zero, Error field (and Carry on some fixed ops).

| Op | Hex (sr=0) | Chip cycles (typ. range) | Behaviour notes |
|----|------------|--------------------------|-----------------|
| FADD | `0x10` | 54–368 (24 if A=0) | Exp OVR/UNDFL: mantissa “correct”, exp offset **±128** |
| FSUB | `0x11` | 70–370 | Same exp-offset note |
| FMUL | `0x12` | 146–168 | Same |
| FDIV | `0x13` | 154–184 (22 if divisor 0) | Divisor **A = TOS**, dividend **B = NOS**. If **A=0**: **R ← B** (NOS), **DIV0** set. Exp OVR/UNDFL: mantissa correct, exp **±128** |
| SQRT | `0x01` | 782–870 | √ of TOS → TOS; **non-negative only** — negative → error **0100** (NEGRT) |

Derived functions (SIN/COS/…): Chebyshev approximations; many destroy lower
stack slots; angles in **radians**. Domain errors use codes above (e.g. LN/LOG
of non-positive → **0100**). See algorithm brief for stack scratch diagrams.

**Range-error quirk (FADD/FSUB/FMUL/FDIV):** when OVRFL/UNDFL is reported, the
returned exponent may be **true_exp ± 128** with a usable mantissa — library
`popf` still maps OVRFL → IEEE Inf and UNDFL → 0 rather than trusting that
mantissa.

### IEEE specials (software)

| Module | Role |
|--------|------|
| `asm/am32_fspecial.asm` | `spec_div` / `spec_mul` / `spec_add` / `spec_sqrt` — CF=1 if handled |
| `asm/am32_f{div,mul,add,sub,sqrt,finv}.asm` | Call specials then APU path |
| `asm/z80/am32_popf.asm`, `asm/8085/am32_popf.asm` | Status → IEEE after op |

Stack convention for binary specials: **DEHL = RHS (y)**; **stack** =
`ret_spec, ret_user, x` as **L,H,E,D** (IEEE host order). `load_xo` must
**preserve BC** (callers stash sign in **C**).

Keep specials **8080-compatible** in shared `asm/am32_*.asm` (no EXX/IX). CPU-specific
I/O and push/pop stay under `asm/z80/` and `asm/8085/`.

## Force rebuild

Prefer a full product make so **cimpl** (`ftoa`/`ftoe`) stays in the `.lib`
(classic `%f` and the math suite need them). Partial `z80asm -x @am9511.lst`
after deleting only a few `.o` files is fine **if** other `obj/<cpu>/**/*.o`
remain; wiping `obj/` without re-running the full Makefile drops ftoa.

```bash
cd libsrc/math/float/am9511
# touch specials / popf / binary cores then full products:
rm -f obj/z80/math/float/am9511/asm/am32_fspecial.o \
      obj/z80/math/float/am9511/asm/am32_f{div,mul,add,sub,sqrt,finv}.o \
      obj/z80/math/float/am9511/asm/z80/am32_popf.o
rm -f obj/8085/math/float/am9511/asm/am32_fspecial.o \
      obj/8085/math/float/am9511/asm/8085/am32_popf.o
make
cp -f ../../../am9511.lib ../../../am9511_8085.lib ../../../lib/clibs/
```

After install, delete suite `.bin`/`.map` before remeasure.

Prove link: `z88dk-z80nm lib/clibs/am9511.lib | rg 'spec_|popf|fdiv|ftoa'`.

## Measure / suite

- Suite: `test/suites/math` → `test_9511.bin`, `test_9511_8085.bin` with
  **`-DMATH_SPECIALS`** (finite + Inf/NaN algebra via `am32_fspecial` + `popf`).
- Do **not** add bare `-lm`/`-lgenmath` ahead of `--math-am9511`: genmath’s
  `sqrt` can win the link and bypass the APU path.
- TIMER benches: classic recipes with `--math-am9511` / `--math-am9511_8085`; see
  `am9511/readme.md` and **`methodology/measure`**.
- Ticks APU: `src/ticks/am9511.c` (approximate model — not bit-exact silicon).
  Status-bit accuracy is a separate work item if suite/hardware disagree.

## Further reading (techdocs)

Canonical tree: **https://github.com/z88dk/techdocs/tree/master/amd/am9511a**  
(Do not treat a local PDF copy in a product working tree as the cite target.)

| File | Use for |
|------|---------|
| [`Am9511 Arithmetic Processor.pdf`](https://github.com/z88dk/techdocs/blob/master/amd/am9511a/Am9511%20Arithmetic%20Processor.pdf) | **Primary:** interface (C/Ḋ, push/pop byte order), status, command format, FADD/FDIV/SQRT descriptions, float format, cycle table |
| [`Am9511A-9512FP_Processor_Manual.pdf`](https://github.com/z88dk/techdocs/blob/master/amd/am9511a/Am9511A-9512FP_Processor_Manual.pdf) | Fuller processor / 9512 companion material |
| [`Am9511_Algorithm_Details.pdf`](https://github.com/z88dk/techdocs/blob/master/amd/am9511a/Am9511_Algorithm_Details.pdf) | Accuracies, stack scratch per op, ranges beyond the short datasheet |
| [`An Efficient Software Driver for Am9511A.pdf`](https://github.com/z88dk/techdocs/blob/master/amd/am9511a/An%20Efficient%20Software%20Driver%20for%20Am9511A.pdf) | Host driver / sequencing patterns |
| [`HARWELL - Using the Am9511A.pdf`](https://github.com/z88dk/techdocs/blob/master/amd/am9511a/HARWELL%20-%20Using%20the%20Am9511A.pdf) | Application / systems notes |

In-tree companion: `libsrc/math/float/am9511/readme.md` (layout, API, benches).  
YAZ180 interrupt/FIFO driver (not the same as classic pushf/popf path):
`libsrc/target/yaz180/device/am9511a/readme.md`.

## Related skills

- Soft IEEE float: **`library-math32`**, **`library-math16`**
- Measure / suite / ticks: **`methodology/measure`**, **`tool-ticks`**
- 8085 stack-only library rules: **`cpu-8085`**
- Classic vs newlib product shape: **`library-classic`**, **`library-newlib`**
