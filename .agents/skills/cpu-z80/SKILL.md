---
name: cpu-z80
description: >
  Z80-family coding notes for z88dk library and app asm: IX/IY, exx, djnz,
  shadow registers, documented vs strict Z80, opcode map (flags and T-states).
  Use when writing or reviewing z80 (not 8085/8080/gbz80) assembly under
  libsrc or hand asm.
---

# CPU — Z80

Default classic and newlib CPU for most targets.

z88dk uses **Zilog mnemonics**. Opcode bytes, flags, and T-states are **Z80**, not 8085.

## Opcode reference

Full grids: [references/opcodes.md](references/opcodes.md).

| Topic | Authority |
|-------|-----------|
| Flags and T-states | [clrhome Z80 table](https://clrhome.org/table/) |
| Native encodings | `src/z80asm/dev/cpu/cpu_test_z80_strict_ok.asm` |
| Undocumented forms z80asm accepts | `cpu_test_z80_ok.asm` (not `*_strict_*`) |
| Assembler reject | `cpu_test_z80_err.asm` — `rg` only, never bulk-read |

Documented encodings in this skill were checked against `cpu_test_z80_strict_ok.asm` (173 representatives, 0 misses). If a fixture and clrhome disagree on **bytes**, the fixture wins. If they disagree on **flags or T-states**, clrhome wins.

clrhome also shows **Z180-only** ops. Those are not Z80. See `cpu-z180`.

## Conventions

1. Emit **Zilog** (`ld a,b`, `jp nz,label`). Do not emit Intel `MOV` / `JNZ` in tree sources.
2. Immediate placeholders in the map: `*` = d8 or displacement, `**` = d16/a16.
3. Conditional T-states are `taken/not-taken` (example `13/8` for `djnz`).
4. **Strict** z80asm forbids synthetics and undocumented index halves / `sll`.
5. Hand-written library asm does **not** run through `z88dk-copt`.

## Registers

```
15 ...... 8  7 ...... 0
     A            F      → AF / af'  (ex af,af')
     B            C      → BC / bc'
     D            E      → DE / de'
     H            L      → HL / hl'
15 ............... 0
        IX   IY
        SP   PC
         I    R
```

`exx` swaps BC/DE/HL with the shadow set. `ex af,af'` swaps AF. Newlib sdcc often reserves **IY**. Classic sccz80 may use IX and IY.

## Flag register (F)

| Bit | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
|-----|---|---|---|---|---|---|---|---|
|     | S | Z | Y | H | X | P/V | N | C |

| Flag | Meaning |
|------|---------|
| **S** | Sign |
| **Z** | Zero |
| **Y** / **X** | Undocumented copies of result bits 5 and 3 |
| **H** | Half-carry |
| **P/V** | Parity **or** overflow (one bit) |
| **N** | Subtract (1 after sub/dec/sbc/cp) |
| **C** | Carry |

Map column order is **SZHPNC**. 8085 has separate P and V, plus K. Do not copy 8085 masks onto Z80.

Condition codes: `nz` `z` `nc` `c` `po` `pe` `p` `m`. No `k` / `nk`.

## Flag rules agents must not get wrong

| Group | SZHPNC | Notes |
|-------|--------|-------|
| `inc`/`dec` **16-bit** (`inc bc` … `dec sp`, `inc ix`) | `------` | **Does not set Z**. Do not `dec bc` / `jp nz`. Test through A (`ld a,b` / `or c`) |
| `inc`/`dec` **8-bit** (incl. `(hl)`) | `SZHV0-` / `SZHV1-` | C unchanged. 8-bit `dec r` **does** set Z |
| `rlca` `rla` `rrca` `rra` | `--0-0C` | **Z unchanged**. Never `rla` / `jp z` |
| `add hl,rp` / `add ix,rp` | `--H-0C` | Z unchanged |
| `adc hl,rp` / `sbc hl,rp` | `SZHV0C` / `SZHV1C` | 16-bit with borrow/carry. Not on 8085 (`sbc hl,de`) |
| 8-bit `add`/`adc` | `SZHV0C` | |
| 8-bit `sub`/`sbc`/`cp` | `SZHV1C` | |
| `and` | `SZ1P00` | H=1, P=parity |
| `or` / `xor` | `SZ0P00` | |
| `djnz` | `------` | B decrements inside the op. No flags |
| `ld a,i` / `ld a,r` | `SZ0*0-` | P/V ← IFF2 |
| `ldi`/`ldd` | `--00*-` | P/V set if BC≠0 after the step |
| `ldir`/`lddr` | `--000-` | P/V reset when the block ends |
| `scf` | `--0-01` | |
| `ccf` | `--*-0*` | N=0, C inverted |
| `pop af` | (loaded) | Restores the stored F |

## Timing notes (clrhome)

- `halt` is **4** T (8085 is 5).
- `jp cc` is **always 10** T (8085 is 10/7).
- `jr cc` is 12/7. `djnz` is 13/8. `call cc` is 17/10. `ret cc` is 11/5.
- `push` is 11 T. `pop` is 10 T.
- `ldir` family: 21 T per repeat, 16 T on the last. Selector stand-in may use `21×n`.
- Indexed ALU `(ix+d)` is 19 T. `inc (ix+d)` is 23 T.

## Style in z88dk `libsrc`

- Prefer documented ops. Use undocumented `ixh` / `sll` only with a measured win, and not under strict assemble.
- Prefer synthetics when the assembler expands them cleanly (see below).
- Match neighbour file whitespace (spaces in most math cores).
- One major function per file — see `style-libsrc-layout`.
- Use `exx` for a second 32-bit value in float/math cores. 8085 cannot.

## Synthetic opcodes (z80asm, normal mode)

**z80asm** expands many source forms into real ops. **Strict** / `-no-synth` forbids free synthetics.

### Word copies — full set

Two 8-bit `ld`s each (example `ld de,hl` → `ld d,h` / `ld e,l`).

| Allowed | Forbidden in this set |
|---------|------------------------|
| `ld` among **bc / de / hl** — any → any | **af**, **sp** |

Prefer `ld bc,hl` / `ld hl,bc` to park and restore one pair.

Other synthetics exist (example `ld a,(hl+)`). Listings (`-l`) show the expansion. **`tool-z80asm`**.

## Contrast with 8085

Do **not** use `exx`, IX/IY, `djnz`, `sbc hl,de`, CB/ED/DD/FD prefixes, or block I/O in `asm/8085/` trees.

On Z80, `CB`/`DD`/`ED`/`FD` are prefixes. On 8085 those bytes are different one-byte extended ops (`rst v`, `jp nk`, `ld hl,(de)`, `jp k`).

16-bit `dec rr` sets **K** on 8085 (underflow to −1). On Z80 it sets **nothing**. Portable 16-bit count test is `or` through A.

## Assembler capability (last resort)

Fixtures under `src/z80asm/dev/cpu/` answer: does **z80asm** accept this **source line** for `-mz80`, and what encoding does it emit?

| File | Meaning |
|------|---------|
| `cpu_test_z80_ok.asm` | Assembles successfully; comment after `;` is expected encoding |
| `cpu_test_z80_err.asm` | Must fail (`; Error`) |
| `*_strict_*` | **Strict mode: synthetics and most undocumented ops forbidden** |
| `*_ixiy_*` | IX/IY swap build |

**ok is not always one native chip opcode** (normal mode may allow synthetics).

How to read lines: skill **`tool-z80asm`**. `rg` one mnemonic. Never bulk-read huge `*_err.asm` files.

## Pitfalls

1. **`dec bc` does not set Z.** Use `ld a,b` / `or c` / `jp nz`, or two 8-bit loops, or `sbc hl,bc` if HL is free and flags may change.
2. **`rla` / `rra` / `rlca` / `rrca` do not set Z.**
3. **`djnz` does not set flags.** A following `jp z` tests an older Z.
4. **`jp cc` is always 10 T.** Do not copy 8085 10/7.
5. **`ld a,i` P/V is IFF2**, not parity of A.
6. **`sll` and `ixh`/`ixl` are undocumented.** Strict assemble rejects them.
7. **`mlt` / `slp` / `in0` are Z180.** They are not on this CPU.
8. **`ei` enables after the next instruction.**
9. No copt pass on library asm. Scan for `ex de,hl` / pair copies before you finish a hot routine.

## Preference order (Z80-only code)

1. Documented ops that z80asm strict accepts.
2. `exx` for a second long. IX/IY when an index or frame is real.
3. `sbc hl,de` / `adc hl,bc` for 16-bit add/sub with carry.
4. `djnz` and `ldir`/`cpir` when the count is in B or BC.
5. Synthetics `ld de,hl` and friends in normal mode.
6. Undocumented `ixh` / `sll` only when the size or T-state win is measured.

## Related

- Full map: [references/opcodes.md](references/opcodes.md)
- Assembler: `tool-z80asm`
- 8085 (different flags and prefixes): `cpu-8085`
- Z80N extras: `cpu-z80n`
- Z180 extras: `cpu-z180`
- Measure: `methodology-measure`, `tool-ticks`
