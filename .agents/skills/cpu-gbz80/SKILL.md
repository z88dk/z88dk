---
name: cpu-gbz80
description: >
  Game Boy CPU (LR35902 / gbz80) for z88dk: Zilog mnemonics, full opcode map
  (flags ZNHC, timings), GB-only ops (ldh, (hl+)/(hl-), ld hl,sp+*, add sp,*,
  swap, stop, reti), and z80asm synthetics. Use when writing or reviewing
  gbz80 library asm, +gb / -mgbz80 paths, mapping Nintendo↔Zilog, or /cpu-gbz80.
---

# CPU — gbz80

Game Boy CPU (Sharp LR35902). Z80-like with different encodings, a four-flag
register, and no IX/IY/`exx`/`ex de,hl`. Classic path
`libsrc/l/sccz80/8-gbz80/`, product `gbz80_crt0.lib`, target `+gb`, assemble
`-mgbz80`.

z88dk writes **Zilog** mnemonics. Pastraiser and Nintendo docs use mixed
Nintendo / Intel names. Translate on the way in.

## Conventions (always follow)

1. **Mnemonics are Zilog**, as in Z80 assembly — not Nintendo `LDH`/`LDHL`/`LDI`
   as the house spelling (those aliases assemble; do not emit them in new
   sources except `ldh`, which is the Zilog name for the HRAM ops).
2. **Opcode bytes and timings are Game Boy**, not Z80 (many shared mnemonics
   use different encodings or do not exist).
3. Immediate forms: `*` = 8-bit (d8 unsigned, **r8 signed**, a8 HRAM offset).
   `**` = 16-bit immediate/address (d16/a16). These `*`/`**` are placeholders.
4. `add sp,*` and `ld hl,sp+*` take a **signed** 8-bit offset (−128…127).
5. Conditional cycle counts use `taken/not-taken` (e.g. `12/8`, `16/12`,
   `24/12`, `20/8`).
6. One major function per file under `libsrc`.

Prefer the full tables in [references/opcodes.md](references/opcodes.md). Use
this skill body for rules, flags, mnemonic mapping, and GB-only ops.

## Sources

| Topic | Source |
|-------|--------|
| Native ISA, flags ZNHC, timings | [pastraiser Game Boy opcodes](https://www.pastraiser.com/cpu/gameboy/gameboy_opcodes.html) |
| Zilog source forms and encodings | `src/z80asm/dev/cpu/cpu_test_gbz80_ok.asm` / `_strict_ok.asm` |
| Usage | `libsrc/l/sccz80/8-gbz80/` |

Pastraiser is the native-ISA authority. **z80asm encodings match the
Pastraiser opcode bytes 100%** (all 245 used cells and the 11 unused cells).
z80asm is the authority for **source spelling** and for **synthetics**.

One Pastraiser **length** cell disagrees with the assembler and with the
hardware fetch: `ld (c),a` / `ld a,(c)` (`E2`/`F2`). Pastraiser prints 2
bytes. z80asm emits **1 byte**. Use 1 byte.

## Registers

```
15 ...... 8  7 ...... 0
     A            F      → AF
     B            C      → BC
     D            E      → DE
     H            L      → HL
15 ............... 0
        SP
        PC
```

No IX, IY, AF′, BC′, DE′, HL′, I, or R. Memory via HL is `(hl)`. Stack grows
down. `push` stores high byte first at `sp-1`, low at `sp-2`.

HRAM / I/O window is `$FF00`–`$FFFF`. There is no `in` / `out`. Use `ldh`.

## Flag register (F)

| Bit | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
|-----|---|---|---|---|---|---|---|---|
|     | Z | N | H | C | 0 | 0 | 0 | 0 |

| Flag | Meaning |
|------|---------|
| **Z** | Zero |
| **N** | Subtract (BCD) |
| **H** | Half-carry |
| **C** | Carry |
| **0** | Unused. Always zero |

Flag columns in tables are always **Z N H C**:

- letter → that flag is affected as defined by the instruction
- `-` → unchanged
- `0` / `1` → forced clear / set

This is **not** the Z80 layout (Z80 is S Z H P/V N C). Game Boy has **no S**
and **no P/V**. Do not test sign or parity flags. Bits 3–0 of F are hardwired
0, so `pop af` never restores a full 16-bit value.

Condition codes (only these four):

| Zilog cc | Meaning |
|----------|---------|
| `nz` / `z` | Z clear / set |
| `nc` / `c` | C clear / set |

No `po`/`pe`/`p`/`m`. z80asm also accepts signed/unsigned sugar (`eq`, `ne`,
`ltu`, `geu`, …) as synthetics of `z`/`nz`/`c`/`nc`. Write `z`/`nz`/`c`/`nc`.

## Nintendo / Intel → Zilog

Use Zilog in all generated or edited z88dk code. Nintendo names appear on
Pastraiser and in GBDK-style sources.

| Nintendo / Intel (Pastraiser) | Zilog (write this) |
|-------------------------------|--------------------|
| `NOP` | `nop` |
| `LD r,r'` / `LD r,d8` | `ld r,r'` / `ld r,*` |
| `LD BC,d16` | `ld bc,**` (also `de`/`hl`/`sp`) |
| `LD (BC),A` / `LD A,(BC)` | `ld (bc),a` / `ld a,(bc)` (also `de`) |
| `LD (HL+),A` / `LDI (HL),A` / `LD (HLI),A` | `ld (hl+),a` |
| `LD A,(HL+)` / `LDI A,(HL)` / `LD A,(HLI)` | `ld a,(hl+)` |
| `LD (HL-),A` / `LDD (HL),A` / `LD (HLD),A` | `ld (hl-),a` |
| `LD A,(HL-)` / `LDD A,(HL)` / `LD A,(HLD)` | `ld a,(hl-)` |
| `LD (a16),SP` | `ld (**),sp` |
| `LD (a16),A` / `LD A,(a16)` | `ld (**),a` / `ld a,(**)` |
| `LDH (a8),A` / `LD ($FF00+a8),A` | `ldh (*),a` |
| `LDH A,(a8)` / `LD A,($FF00+a8)` | `ldh a,(*)` |
| `LD (C),A` / `LD ($FF00+C),A` | `ld (c),a` or `ldh (c),a` |
| `LD A,(C)` / `LD A,($FF00+C)` | `ld a,(c)` or `ldh a,(c)` |
| `LD HL,SP+r8` / `LDHL SP,r8` | `ld hl,sp+*` |
| `LD SP,HL` | `ld sp,hl` |
| `ADD HL,rp` | `add hl,bc` / `de` / `hl` / `sp` |
| `ADD SP,r8` | `add sp,*` |
| `INC`/`DEC` | `inc`/`dec` |
| `ADD A,r` / `ADC A,r` | `add a,r` / `adc a,r` |
| `SUB r` / `SBC A,r` | `sub r` or `sub a,r` / `sbc a,r` |
| `AND`/`XOR`/`OR`/`CP` | `and`/`xor`/`or`/`cp` |
| `RLCA`/`RRCA`/`RLA`/`RRA` | `rlca`/`rrca`/`rla`/`rra` |
| `JR r8` / `JR cc,r8` | `jr *` / `jr cc,*` |
| `JP a16` / `JP cc,a16` | `jp **` / `jp cc,**` |
| `JP (HL)` | `jp (hl)` |
| `CALL`/`RET`/`RETI` | `call`/`ret`/`reti` |
| `RST 00H`…`38H` | `rst 00h` … `rst 38h` |
| `PUSH`/`POP BC\|DE\|HL\|AF` | `push`/`pop bc\|de\|hl\|af` |
| `STOP 0` | `stop` |
| `HALT`/`DI`/`EI`/`DAA`/`CPL`/`SCF`/`CCF` | `halt`/`di`/`ei`/`daa`/`cpl`/`scf`/`ccf` |
| `SWAP r` | `swap r` |
| `RLC`/`RRC`/`RL`/`RR`/`SLA`/`SRA`/`SRL` | same, lowercase |
| `BIT`/`RES`/`SET n,r` | `bit`/`res`/`set n,r` |

z80asm accepts the Nintendo aliases in the table (`ld (hli),a`, `ldi a,(hl)`,
`ldhl sp,*`, `ld a,(0xff00+c)`, …). They encode the same bytes. **Write the
Zilog column.** `ldh a,(*)` is the house spelling for the `$FF00+a8` ops.
z80asm does **not** encode `ld a,($ff00+n)` as `ldh`. That source form is
an absolute `ld a,(**)` (`FA`, 3 bytes). Always write `ldh a,(n)`.

## GB-only native ops (not Z80)

These encodings are **not** the Z80 instruction at that byte.

| Op | Zilog | Bytes | Cyc | Flags | Effect |
|----|-------|------:|----:|-------|--------|
| `08` | `ld (**),sp` | 3 | 20 | `----` | (`**`)←SP |
| `10 00` | `stop` | 2 | 4 | `----` | stop oscillator. Always emit **two** bytes |
| `22` | `ld (hl+),a` | 1 | 8 | `----` | (HL)←A, HL←HL+1 |
| `2A` | `ld a,(hl+)` | 1 | 8 | `----` | A←(HL), HL←HL+1 |
| `32` | `ld (hl-),a` | 1 | 8 | `----` | (HL)←A, HL←HL−1 |
| `3A` | `ld a,(hl-)` | 1 | 8 | `----` | A←(HL), HL←HL−1 |
| `D9` | `reti` | 1 | 16 | `----` | `ret` + enable interrupts (not Z80 `exx`) |
| `E0` | `ldh (*),a` | 2 | 12 | `----` | (`$FF00`+\*)←A |
| `E2` | `ld (c),a` | 1 | 8 | `----` | (`$FF00`+C)←A |
| `E8` | `add sp,*` | 2 | 16 | `00HC` | SP←SP+signed \*. **Z←0** |
| `F0` | `ldh a,(*)` | 2 | 12 | `----` | A←(`$FF00`+\*) |
| `F2` | `ld a,(c)` | 1 | 8 | `----` | A←(`$FF00`+C) |
| `F8` | `ld hl,sp+*` | 2 | 12 | `00HC` | HL←SP+signed \*. **Z←0** |
| `CB 3x` | `swap r` | 2 | 8/16 | `Z000` | nibble swap |

`(hl+)` / `(hl-)` as a **single native opcode** exist only for **A**.
`ld b,(hl+)` and `add a,(hl+)` are synthetics (`ld b,(hl)` / `inc hl`, …).

## Absent vs Z80 / 8080 (do not emit as native)

| Missing | What to use instead |
|---------|---------------------|
| `ex de,hl` | pair copy `ld de,hl` / `ld hl,de`, or the 4-byte synthetic `ex de,hl` (56c) |
| `ex (sp),hl` | helper `call __z80asm__ex_sp_hl` (**148c**). Avoid in hot paths |
| `exx`, IX, IY, `ex af,af'` | second long on the stack |
| `djnz` | synthetic `dec b` / `jr nz` (accepted in normal mode) |
| `in` / `out` / block I/O | `ldh` / `ld (c),a` |
| `ld hl,(**)` / `ld (**),hl` | two `ld a,(**)` or a pointer in HL |
| `ld sp,(**)` | `ld hl,(**)` synthetic + `ld sp,hl`, or `ld (**),sp` is store-only |
| `sbc hl,de` / `adc hl,bc` | helper `call __z80asm__*` (slow) or open-code through A |
| `ldir` / `ldi` as Z80 block | helper, or `ld a,(hl+)` / `ld (de+),a` |
| `po`/`pe`/`p`/`m` | only `z`/`nz`/`c`/`nc` |
| `im`, `retn`, `neg` as one opcode | `neg` is synthetic `cpl` / `inc a` |

Unused native opcodes (illegal): `D3` `DB` `DD` `E3` `E4` `EB` `EC` `ED`
`F4` `FC` `FD`. Same 11 holes in Pastraiser and in `cpu_test_gbz80_strict_ok.asm`.

## Flag rules agents must not get wrong

| Group | Flags | Notes |
|-------|-------|-------|
| 8-bit `inc` | `Z0H-` | N←0. C unchanged |
| 8-bit `dec` | `Z1H-` | N←1. C unchanged |
| `inc`/`dec` **16-bit** | `----` | no flags (unlike 8085 K) |
| `add a` / `adc a` | `Z0HC` | N←0 |
| `sub` / `sbc` / `cp` | `Z1HC` | N←1 |
| `and` | `Z010` | H forced 1, C←0 |
| `xor` / `or` | `Z000` | H←0, C←0 |
| `add hl,rp` | `-0HC` | Z unchanged |
| `add sp,*` / `ld hl,sp+*` | `00HC` | **Z forced 0**. Save C before these if you still need it |
| `rlca` / `rla` / `rrca` / `rra` | `000C` | **Z forced 0** (not Z80). Never `rla; jr z` |
| CB `rlc`/`rl`/`rrc`/`rr`/`sla`/`srl` | `Z00C` | Z is live (unlike the A rotates) |
| CB `sra` | Pastraiser `Z000` | see below |
| CB `swap` | `Z000` | C←0 |
| CB `bit` | `Z01-` | H←1, C unchanged |
| `daa` | `Z-0C` | |
| `cpl` | `-11-` | N←1, H←1 |
| `scf` | `-001` | C←1 |
| `ccf` | `-00C` | C toggled |
| `pop af` | `ZNHC` | restores Z N H C. Low nibble stays 0 |

**`sra` and C:** Pastraiser prints `Z 0 0 0`. `libsrc/l/sccz80/8-gbz80/l_asr.asm`
does `sra h` / `rr l` and needs C = old bit 0 of H. Write shifts that way.

`rlca`/`rla`/`rrca`/`rra` do **not** set Z. Test with `or a` / `and a` first.

## Timing notes

Pastraiser machine cycles (not Z80 T-states):

- Conditional `jr`: 12 taken / 8 not taken
- Conditional `jp`: 16 / 12
- Conditional `call`: 24 / 12
- Conditional `ret`: 20 / 8
- `call **` 24, `ret` 16, `reti` 16, `rst` 16
- `push` 16, `pop` 12
- 8-bit ALU register 4, `(hl)` 8, immediate 8
- `ld hl,sp+*` 12, `add sp,*` 16
- CB op 8, CB `(hl)` 16 (includes the prefix)

## Coding rules for this project

1. Emit **Zilog** only (`ld a,b` not `MOV A,B`; `ld a,(hl+)` not `LDI A,(HL)`).
2. Register pairs: `bc`, `de`, `hl`, `af`, `sp`.
3. Use `(hl)`, `(bc)`, `(de)`, `(**)`, `(hl+)`, `(hl-)`, `(c)` for memory.
4. Prefer GB-only natives when they win: `ld hl,sp+*`, `add sp,*`,
   `ld a,(hl+)` / `ld (hl+),a`, `ldh`, `swap`.
5. Never assume Z80 prefix encodings (`DD`/`ED`/`FD` are unused or different).
6. When optimizing, consult [references/opcodes.md](references/opcodes.md).
7. **Assembler last resort:** fixtures
   `src/z80asm/dev/cpu/cpu_test_gbz80_{ok,err}.asm` (and `*_strict_*`).
   **ok** = z80asm accepts that source form (native, synthetic, or
   `call __z80asm__*`). **err** = rejected. **`_strict_`** = synthetics
   forbidden. Full decode: **`tool-z80asm`**. `rg` only. Do not bulk-read
   `*_err.asm`.

## Usage (from `libsrc/l/sccz80/8-gbz80/`)

Patterns below are the house style for new gbz80 library asm. Cite the
named file as the example, not as a required callee.

### 1. Stack is the second long — `ld hl,sp+*`

There is no `exx`. The 32-bit primary often sits on the stack.

```asm
    ld  hl,sp+2        ; 12c, 2B; flags 00HC (Z←0)
    ld  a,(hl+)        ; native post-inc
    add a,c
```

See `i32/l_long_add.asm`, `l_long_sub.asm`, `l_long_and.asm`,
`i32/l_long_div_0.asm`.

`*` is **signed**. Offset 0…127 covers a small frame. Larger offsets need
`ld hl,nn` / `add hl,sp` (20c, 4B, Z unchanged).

**C across `ld hl,sp+*`:** that op clobbers C (and forces Z=0). Save C first:

```asm
    rra                ; C → A
    ld  hl,sp+n
    rla                ; C restored
```

`l_long_div_0.asm` does this around every stack reload in the shift loop.

### 2. Drop stack arguments — `add sp,*`

```asm
    pop bc             ; return address
    add sp,4           ; drop a long (signed immediate)
    push bc
    ret
```

Same files as §1. `add sp,*` is 16c and also forces Z=0.

### 3. Stream bytes — native `(hl+)` / `(hl-)` for A

```asm
    ld  a,(hl+)        ; 8c, 1B  vs ld a,(hl)/inc hl = 16c, 2B
    ld  (hl+),a
    ld  a,(hl-)
```

`l_getptr.asm`, `l_case.asm`, `l_glong.asm` (`ld a,(hl-)`), `l_long_neg_mhl.asm`.

ALU with post-inc is a **synthetic** (`sub (hl)` / `inc hl`). Legal in normal
mode and used conceptually in `l_long_div_0.asm` (`ld a,(de+)` / `sub a,(hl+)`).

There is **no** `rl (hl+)`. `l_long_rl_mhl.asm` and `l_long_div_0.asm` do
`rl (hl)` / `inc hl`.

### 4. Park a pair — `ld bc,hl` synthetics

```asm
    ld  bc,hl          ; B←H, C←L
    ; … use HL …
    ld  hl,bc
```

`l_long_add.asm` parks the low word this way. Prefer this over `ex de,hl`.

### 5. 16-bit shifts through CB ops

gbz80 has `sla`/`sra`/`rl`/`rr` on every 8-bit register and on `(hl)`.

```asm
    sra h              ; signed 16-bit >>  (l_asr.asm)
    rr  l              ; C must be old H bit 0
```

```asm
    sla c              ; scan bitlen (l_long_div_0.asm)
    rl  b
```

Word synthetics `sra hl` → `sra h` / `rr l`, `rl de` → `rl e` / `rl d` exist
in normal mode. Prefer them over open-coded pairs when both bytes move.

### 6. Counted loops — `djnz` synthetic or `dec b` / `jr nz`

`djnz` is **not** native (byte `10` is `stop`). z80asm expands
`djnz label` to `dec b` / `jr nz,label`. `l_mult.asm` uses it. Fine in
normal mode. Strict mode rejects it.

16-bit counts: `dec bc` does **not** set Z. Test with `ld a,b` / `or c`.

### 7. HRAM / MMIO — `ldh`

```asm
    ldh a,(n)          ; A ← ($FF00+n)
    ldh (n),a
    ld  a,(c)          ; A ← ($FF00+C)
    ld  (c),a
```

Do not fake `in a,(c)` / `out (c),a`.

### 8. In-place memory ALU

```asm
    ld  a,0            ; not xor a if C must live
    sub a,(hl)
    ld  (hl+),a        ; l_long_neg_mhl.asm
```

### 9. `ex de,hl` and `ex (sp),hl` are last resort

| Form | Encoding | Cost | Use |
|------|----------|-----:|-----|
| `ld de,hl` | `ld d,h` / `ld e,l` | 2B / 8c | prefer |
| `ex de,hl` | `push hl` / `push de` / `pop hl` / `pop de` | 4B / **56c** | only if you need a true swap |
| `ex (sp),hl` | `call __z80asm__ex_sp_hl` | **148c** | almost never |

`l_debug_push_frame.asm` parks HL in DE with two 8-bit loads because there
is no cheap `ex`. `l_div.asm` still writes `ex de,hl` — that is the expensive
synthetic. New code should prefer pair copies.

## Synthetic opcodes (z80asm, normal mode)

Assembler sugar. **Strict** / `-no-synth` forbids free synthetics.
Listings (`-l`) show the expansion. Full set:
`src/z80asm/dev/cpu/cpu_test_gbz80_ok.asm`. Prefer the forms below.

### Word copies — full set

| Allowed | Forbidden in this set |
|---------|------------------------|
| `ld` among `bc` / `de` / `hl` (any → any) | `af`, `sp` |

```asm
    ld  bc,de          ; 42 4B
    ld  bc,hl          ; 44 4D
    ld  de,bc          ; 50 59
    ld  de,hl          ; 54 5D
    ld  hl,bc          ; 60 69
    ld  hl,de          ; 62 6B
```

### Useful inline synthetics (not helpers)

| Zilog | Expansion idea | Notes |
|-------|----------------|-------|
| `ld a,(de+)` / `ld (de+),a` | `ld a,(de)` / `inc de` | same for `bc`, and `-` / `ldi`/`ldd` spellings |
| `ld r,(hl+)` (r≠A) | `ld r,(hl)` / `inc hl` | A form is **native** `2A` |
| `add a,(hl+)` and other ALU+(hl±) | ALU `(hl)` + `inc`/`dec hl` | |
| `ld (hl),bc` / `ld bc,(hl)` | two byte moves + `inc`/`dec` | |
| `djnz *` | `dec b` / `jr nz` | |
| `sra hl` / `rl de` / `rr bc` | two CB ops | |
| `neg` | `cpl` / `inc a` | |
| `clr r` / `clr rp` | `ld r,0` / `ld rp,0` | do not use `xor a` if C must live |
| `jp (bc)` / `jp (de)` | `push rp` / `ret` | |

Do **not** prefer these long expansions when a native exists:

| Avoid | Why |
|-------|-----|
| `ld de,hl+*` / `ld de,sp+*` | many bytes via `ex` synthetic. Use `ld hl,sp+*` |
| `ld (**),hl` / `ld hl,(**)` | two absolute `ld a,(**)` plus park A |
| `ld (de),hl` | `ex` + `(hl)` traffic. Open-code through A |

### Helper calls (`CD @__z80asm__…`)

These assemble in normal mode but link a routine from `src/z80asm/dev/z80asm_lib/`.
They are **not** one-chip ops. Do not use them as the core of a hot hand-written
routine (same rule as other CPUs).

| Source form | Helper | GB cost (from the helper source) |
|-------------|--------|-----------------------------------|
| `ex (sp),hl` | `__z80asm__ex_sp_hl` | 148c |
| `sub hl,bc` (and `de`/`hl`/`sp`) | `__z80asm__sub_hl_*` | 80c |
| `sbc hl,rp` / `adc hl,rp` | `__z80asm__sbc_hl_*` / `adc_hl_*` | helper |
| `add hl,a` / `add de,a` / `add bc,a` | `__z80asm__add_*_a` | helper |
| `ldi` / `ldir` / `ldd` / `lddr` | `__z80asm__ldi*` | uses `(hl+)`/`(de+)` inside |
| `cpi` / `cpir` / `cpd` / `cpdr` | `__z80asm__cpi*` | helper |
| `rld` / `rrd` | `__z80asm__rld` / `rrd` | helper |
| `call (hl)` | `__z80asm__call_hl` | helper |

`__z80asm__ldi` itself is a good template: `ld a,(hl+)` / `ld (de+),a` /
`dec bc`. Open-code that sequence when you do not need Z80 P/V (Game Boy
has no P/V).

## Pitfalls

1. **`ld hl,sp+*` and `add sp,*` clear Z and rewrite H,C.** Save C with
   `rra`/`rla` if a rotate chain is live (`l_long_div_0.asm`).
2. **`rlca`/`rla`/`rrca`/`rra` force Z=0.** They are not test-and-rotate.
3. **No `ex de,hl` as a 1-byte op.** The mnemonic is a 56c stack swap.
4. **No `djnz` opcode.** `10` is `stop` (`10 00`). The mnemonic is sugar.
5. **`stop` is two bytes** (`10 00`). Do not emit a lone `10`.
6. **`reti` is `D9`**, not `ED 4D`. `D9` is not `exx`.
7. **`pop af` is not a 16-bit temp.** F bits 3–0 stay 0.
8. **`ld a,($ff00+n)` is not `ldh`.** It is `ld a,(**)` (`FA`). Write `ldh a,(n)`.
9. **`dec bc` does not set Z.** Do not write `dec bc; jr nz` as a 16-bit
   loop test.
10. **Only A has native `(hl+)`/`(hl-)`.** Other registers are two ops.
11. **No copt pass on library asm.** Hand-written `libsrc/**` is assembled
    as-is. Remove dead moves yourself. Match the target file’s whitespace.
    Checklist: **`tool-copt`**, **`methodology-measure`**.

## Preference order (gbz80-only code)

1. `ld hl,sp+*` for stack pointers (signed −128…127). `add hl,sp` only when
   the offset does not fit or you must keep Z.
2. `add sp,*` to drop arguments.
3. `ld a,(hl+)` / `ld (hl+),a` / `ld a,(hl-)` for streams.
4. `ld bc,hl` / `ld hl,bc` (and the other pair copies) to park a word.
5. `ldh` / `ld (c),a` for `$FF00+n`.
6. CB `sla`/`sra`/`rl`/`rr`/`swap` on registers and `(hl)`.
7. `djnz` sugar or `dec b`/`jr nz` for 8-bit counts.
8. Fall back to helper `call __z80asm__*` only when the expansion is large
   and the path is not hot.

## Assembler capability (last resort)

Fixtures under `src/z80asm/dev/cpu/` answer: does **z80asm** accept this
**source line** for `-mgbz80`, and what encoding does it emit?

| File | Meaning |
|------|---------|
| `cpu_test_gbz80_ok.asm` | Assembles successfully. Comment after `;` is the encoding |
| `cpu_test_gbz80_err.asm` | Must fail (`; Error`) |
| `*_strict_*` | Strict mode: synthetics forbidden |

**ok is not always one native chip opcode** (normal mode may allow
synthetics or `CD @__z80asm__…` helpers).

How to read lines and `rg` without loading huge files: skill **`tool-z80asm`**.

## Related

- Full opcode grid: [references/opcodes.md](references/opcodes.md)
- Assembler: `tool-z80asm`
- Measure: `methodology-measure`, `tool-ticks`
- Target: `lib/config/gb.cfg`, `libsrc/target/gb/`
- sccz80 runtime examples: `libsrc/l/sccz80/8-gbz80/`
