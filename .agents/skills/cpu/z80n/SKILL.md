---
name: cpu-z80n
description: >
  Z80N (ZX Spectrum Next) for z88dk: Next-only opcodes (mul, nextreg, LDIX…),
  nextreg I/O model, copper co-processor programs, +zxn / -mz80n / math32_z80n.
  Use when writing or reviewing Next asm, nextreg/copper code, or measuring HW mul.
---

# CPU — Z80N (ZX Spectrum Next)

Z80-compatible core **plus Next extensions**. Target: **`+zxn`**. Assemble with
**`-mz80n`**. z88dk uses **Zilog mnemonics** only in tree sources.

Authoritative extended-ISA list (human wiki):

https://wiki.specnext.dev/Extended_Z80_instruction_set

Assembler accept/reject last resort: `src/z80asm/dev/cpu/cpu_test_z80n_{ok,err}.asm`
(see **`tool-z80asm`**). C/asm constants: `include/arch/zxn.h`,
`libsrc/newlib/target/zxn/config_zxn.h`.

Do **not** paste the full NextReg catalogue into context — open one register page
or one `#define` when needed.

---

## 1. Next-only opcodes (agent map)

Status **E** on the wiki = Next-only. Common Zilog forms z80asm accepts under `-mz80n`:

| Mnemonic (Zilog / z80asm) | Encoding (hex) | T (wiki) | Role |
|---------------------------|----------------|----------|------|
| `mul de` / `mul d,e` | `ED 30` | 8 | D×E → DE (unsigned); **no flags** |
| `nextreg imm8,imm8` | `ED 91 rr vv` | 20 | Write value to nextreg |
| `nextreg imm8,a` | `ED 92 rr` | 17 | Write A to nextreg |
| `add hl/de/bc,a` | `ED 31/32/33` | 8 | rr += zero-extended A |
| `add hl/de/bc,imm16` | `ED 34/35/36 lo hi` | 16 | rr += constant |
| `push imm16` | `ED 8A **hi lo**` | 23 | Immediate push; operand is **big-endian** (unique) |
| `swapnib` | `ED 23` | 8 | Swap A nibbles |
| `mirror a` | `ED 24` | 8 | Reverse bits of A |
| `test imm8` | `ED 27 nn` | 11 | Flags as `and a,n` without changing A |
| `bsla/bsra/bsrl/bsrf de,b` | `ED 28…2B` | 8 | Variable shift DE by B (B&31) |
| `brlc de,b` | `ED 2C` | 8 | Rotate left DE by B (B&15) |
| `outinb` | `ED 90` | 16 | Like OUTI but B unchanged |
| `pixelad` / `pixeldn` / `setae` | `ED 94/93/95` | 8 | ULA pixel address / next line / mask from E |
| `jp (c)` | `ED 98` | 13 | IN (C) then patch low 14 bits of PC |
| `ldix` / `lddx` / `ldirx` / `lddrx` | `ED A4/AC/B4/BC` | … | Block copy; **skip** store when `(hl)==a` |
| `ldws` | `ED A5` | 14 | Copy; INC L, INC D (Layer 2 vertical-ish) |
| `ldpirx` | `ED B7` | … | Pattern fill from 8-byte table |

**Agent rules**

1. These opcodes require **`-mz80n`** (or a product built for z80n). Plain `-mz80` will reject or not use them.
2. **`mul de`** helps mul-heavy / NR **inv** float paths; **restoring div** does not use it (`library-math32`).
3. Prefer fixtures + `-l` listing over guessing encodings.
4. Full descriptions and flag notes: SpecNext wiki page above (do not bulk-load into chat).

---

## 2. NextReg (feature control registers)

### What they are

**Next registers** (TBBlue feature control) are a bank of 8-bit configuration /
hardware registers: MMU, video layers, copper, sprites, peripherals, etc. They
are **not** Z80 CPU registers.

Catalogue index: https://wiki.specnext.dev/Board_feature_control  
Per-register pages: `https://wiki.specnext.dev/NextReg:$NN`  
FPGA source of truth when wiki drifts: `nextreg.txt` in the ZX Next FPGA repo.

### How the CPU accesses them

**Port pair (classic):**

| Port | z88dk name | Role |
|------|------------|------|
| `$243B` | `IO_NEXTREG_REG` / `IO_243B` | Select register number |
| `$253B` | `IO_NEXTREG_DAT` / `IO_253B` | Read/write selected register data |

Sequence: write register index to `$243B`, then read/write data at `$253B`.

**Z80N opcodes (preferred when writing Next-only asm):**

```asm
    nextreg $50,$22      ; write imm to nextreg (ED 91)
    nextreg $50,a        ; write A to nextreg (ED 92)
```

**C helpers** (`include/arch/zxn.h`):

| Helper | Role |
|--------|------|
| `ZXN_NEXTREG(reg,val)` | Compile-time constant reg+val (peephole-friendly) |
| `ZXN_NEXTREGA(reg,val)` | Constant reg, runtime val |
| `ZXN_READ_REG(reg)` | Read nextreg |
| `ZXN_WRITE_REG(reg,val)` | Write nextreg |

Register number symbols: `REG_MMU0`…`REG_MMU7`, `REG_COPPER_DATA`, … (same header /
`config_zxn.h`).

### Agent rules for nextreg

1. **One register at a time** when researching — open the specific `NextReg:$NN` page or one `#define` block.
2. Writes can reconfigure memory map, video, copper; order and timing matter.
3. Prefer **`nextreg`** opcode or z88dk helpers over open-coded port I/O unless matching existing code.
4. Do not invent register numbers; copy from `zxn.h` / wiki.

---

## 3. Copper (co-processor)

**Authoritative source (read this page when working on copper):**  
https://wiki.specnext.dev/Copper  

z88dk names: `REG_COPPER_DATA` / `REG_COPPER_CONTROL_L` / `REG_COPPER_CONTROL_H`
and `RCCH_COPPER_*` in `include/arch/zxn.h` / `config_zxn.h`.

### What it is (from the wiki)

A programmed helper that changes **Next Registers** at chosen **scanline /
horizontal** positions. “Copper” = co-processor (Amiga-style name).  
**Not** the Raspberry Pi “coprocessor”.

The Z80 uploads a small program; the copper then **WAIT**s and **MOVE**s without
the CPU for every register poke.

### Instruction set (16-bit words)

Each instruction is **16 bits**. One bit selects WAIT vs MOVE; two special cases:

| Opcode | Bit pattern | Effect | Duration |
|--------|-------------|--------|----------|
| **WAIT** | `%1hhhhhhv %vvvvvvvv` | Wait for raster line **v** (0–311) and horizontal position **h×8** (**h** 0–56) | 1 CLOCK |
| **MOVE** | `%0rrrrrrr %vvvvvvvv` | Write value **v** to nextreg **r** | 2 CLOCKS |
| **NOOP** | `%00000000 %00000000` | Special “value 0 to port 0” → no operation | 1 CLOCK |
| **HALT** | `%11111111 %11111111` | Special **WAIT 63,511** → never matches → halt until reset | — |

- Program store: **2 KiB** → **1024** instructions (indices 0–1023).  
- **CPC** (copper PC): 10 bits, increments after each insn, wraps 1023→0.  
- Non-looping programs: end with WAIT for a line **> 311** (use **HALT**) so the
  wait never completes.

### Upload and control (NextReg $60–$62)

| NextReg | Role |
|---------|------|
| **$60** | Upload program **byte by byte** into copper RAM at write index **I** |
| **$61** + **$62** | Control **word**: write index **I** and mode **c** |

Control word: `%cc000iii %iiiiiiii`

- **I** = storage position **0–2047** (byte index for `$60` writes)  
- **c** = run mode:

| **c** | Effect |
|-------|--------|
| `%00` | **STOP** — idle; CPC frozen |
| `%01` | Reset CPC to 0, then **START** |
| `%10` | **START** from current CPC |
| `%11` | Reset CPC to 0, **START**; **also** reset CPC on **VBlank** |

If **c** is written **unchanged** from the previous value, only **I** is updated
(mode ignored). Typical load: STOP → set **I** → stream via `$60` → set START/VBI.

### Timing notes (wiki)

| Topic | Detail |
|-------|--------|
| Core 2.x | Copper at **14 MHz**; deeper timing in TBBlue `COPPER-v0.1c.TXT` |
| Core 3.x | Copper at **28 MHz**; WAIT coords same in practice; **MOVE twice as fast** |
| Micro | 16-bit insn fetch 1 T; **NOOP** = 1 T total; **MOVE** = 2 T (1 T execute + 1 T nextreg-path delay so CPU/DMA are not starved) |
| Display | Avoid depending on sub-pixel MOVE lead-in without board tests |

### Agent rules

1. Open **https://wiki.specnext.dev/Copper** for full wording; this skill is a
   condensed agent map only.  
2. Copper only **WAIT**s and **MOVE**s nextregs — no Z80 code.  
3. Build 16-bit words → upload via **$60** with **I** set via **$61/$62** → set mode.  
4. One-shot: **HALT** at end. Looping: wrap + mode (often VBlank reset **c=%11**).  
5. Not DMA, CTC, or Pi accel.  
6. Precise raster math: wiki + `COPPER-v0.1c.TXT` — only when debugging timing.

---

## 4. z88dk product notes

| Item | Detail |
|------|--------|
| Target | `+zxn` — `lib/config/zxn.cfg` |
| CPU flag | `-mz80n` / ticks `-mz80n` |
| Float | `math32_z80n.lib` when measuring HW-mul-sensitive code |
| Headers | `include/arch/zxn.h` |
| Config symbols | `libsrc/newlib/target/zxn/config_zxn.h` (`__USE_Z80N_OPCODES_NEXTREG`, copper regs) |
| Platform wiki drafts | `wiki/platforms/Platform---ZX-Spectrum-Next-zxn.md` (on demand only) |

---

## Synthetic opcodes (z80asm)

Inherits Z80 **word-copy** synthetics (normal mode): any of **`bc` / `de` / `hl`**
to any of those pairs — two 8-bit loads each. Use to park a pair
(`ld bc,hl` … `ld hl,bc`) rather than multi-insn swaps. **Not** **`af`** / **`sp`**.

Strict forbids free synthetics. Next-only ops above are **native**, not this set.

## Assembler capability (last resort)

Fixtures: `src/z80asm/dev/cpu/cpu_test_z80n_{ok,err}.asm` (+ `*_strict_*`).

| File | Meaning |
|------|---------|
| `*_ok.asm` | Assembles; `;` comment = encoding |
| `*_err.asm` | Must fail |
| `*_strict_*` | **Strict: synthetics forbidden** |

How to `rg` without bulk-load: **`tool-z80asm`**.

---

## Related

- Base Z80 model: `cpu/z80`
- Assembler fixtures / nextreg mnemonic examples: `tool/z80asm`
- Measure: `methodology/measure`, `tool/ticks`
- SpecNext: [Extended ISA](https://wiki.specnext.dev/Extended_Z80_instruction_set) · [Copper](https://wiki.specnext.dev/Copper) · [Board / nextregs](https://wiki.specnext.dev/Board_feature_control)
