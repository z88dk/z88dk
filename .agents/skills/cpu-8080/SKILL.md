---
name: cpu-8080
description: >
  Intel 8080 assembly for z88dk: original ISA (April 1974), Zilog mnemonics,
  Pastraiser opcode/flag/timing map (S Z 0 A 0 P 1 C), stack-only locals, no
  8085 extras, no Z80 IX/IY/exx. `jr` is a jp synthetic (normal mode).
  Use when writing or reviewing 8080 library asm, +cpm -clib=8080, -m8080,
  mapping Intel↔Zilog, unused *NOP slots, pop-af return-address traps, or
  /cpu-8080. Parent of 8085, KR580VM1, gbz80, and Z80.
---

# CPU — 8080

Intel 8080, April 1974. Successor to the 8008 (not binary-compatible). This is the **original ISA** from which the related CPUs in this tree are derived: 8085, KR580VM1, gbz80 (Sharp LR35902), and Z80 (and later Z80N / Z180). History: [Intel 8080](https://en.wikipedia.org/wiki/Intel_8080). Altair 8800, S-100, original CP/M CPU. Soviet KR580VM80A is an 8080A clone; VM1 extends it.

z88dk writes **Zilog** mnemonics. Pastraiser and Intel manuals use Intel names (`MOV`, `LXI`, `DAD`). Translate on the way in.

Classic path `libsrc/l/sccz80/8-8080/`, products `8080_crt0.lib` / `8080_clib.lib` / `cpm8080_clib.lib`. Assemble `-m8080`. Typical: `zcc +cpm -clib=8080` or `+z80 -clib=8080`. `-D__8080` sets `__CPU_INTEL__`. 9-common `IF __CPU_INTEL__` is the 8080-portable path. **No** `math32` / `math16` 8080 product (those cores need 8085 extras or Z80). Float: **`--math-mbf32`**.

**This skill is complete for 8080 work.** Load `cpu-8085` only when emitting 8085 extended ops.

## Conventions (always follow)

1. **Mnemonics are Zilog** (`ld a,b`, `add hl,sp`). Do not emit Intel `MOV` / `LXI` / `DAD` in tree sources (fixtures may list Intel for compat).
2. **Opcode bytes and timings are 8080**, not 8085 and not Z80.
3. Immediate forms: `*` = d8, `**` = d16/a16. Placeholders only.
4. Conditional cycle counts: **jp always 10**; **call** 17/11; **ret** 11/5.
5. One major function per file under `libsrc`.

Do **not** dump a 16×16 grid here. Opcode/flag/timing authority is Pastraiser. Use this skill body for rules, flags, mnemonic mapping, unused slots, and 8080-portable sequences.

## Sources

| Topic | Source |
|-------|--------|
| Opcode bytes, flags S Z A P C, timings | **[pastraiser i8080 opcodes](https://pastraiser.com/cpu/i8080/i8080_opcodes.html)** (primary) |
| History, programming model, descendants | [Intel 8080 (Wikipedia)](https://en.wikipedia.org/wiki/Intel_8080) |
| z80asm source forms | `src/z80asm/dev/cpu/cpu_test_8080_ok.asm` / `_strict_ok.asm` |
| sccz80 overrides | `libsrc/l/sccz80/8-8080/` |

When sources conflict on **flags or cycles**, trust **Pastraiser**. When they conflict on **mnemonic spelling**, write **Zilog**.

## Registers

```
15 ...... 8  7 ...... 0
     A            F      → AF (PSW); Zilog: af
     B            C      → BC
     D            E      → DE
     H            L      → HL
15 ............... 0
        SP
        PC
```

No IX/IY, no `exx`, no AF′/BC′/DE′/HL′, no I/R. Memory via HL is `(hl)` (Intel `M`). Stack grows downward; `push` stores high byte first at `sp-1`, low at `sp-2`. 256 I/O ports via `in a,(*)` / `out (*),a`.

## Flag register (F)

| Bit | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
|-----|---|---|---|---|---|---|---|---|
|     | S | Z | **0** | A | **0** | P | **1** | C |

| Flag | Meaning |
|------|---------|
| **S** | Sign |
| **Z** | Zero |
| **0** | Unused; always zero (bits 5 and 3) |
| **A** | Auxiliary carry (half-carry / AC) |
| **P** | Parity (even). **Always parity**, not Z80 P/V |
| **1** | Unused; always one (bit 1) |
| **C** | Carry |

Flag columns in Pastraiser are **S Z A P C**:

- letter → that flag is affected as defined by the instruction
- `-` → unchanged

There is **no K**, **no V**, **no N**. Do not copy 8085 K/V or Z80 N/P/V rules. Bit 1 is hardwired 1, not 8085 V and not Z80 N.

Condition codes: `nz` `z` `nc` `c` `po` `pe` `p` `m` only. No `k`/`nk`/`v`.

## Intel → Zilog mnemonic map (primary)

Use Zilog in all generated/edited z88dk code. Intel names appear on Pastraiser, in manuals, and in fixtures; when importing, **translate**.

| Intel | Zilog |
|-------|-------|
| `NOP` | `nop` |
| `LXI rp,d16` | `ld bc/de/hl/sp,**` |
| `STAX B/D` | `ld (bc),a` / `ld (de),a` |
| `LDAX B/D` | `ld a,(bc)` / `ld a,(de)` |
| `INX/DCX rp` | `inc/dec bc/de/hl/sp` |
| `INR/DCR r` | `inc/dec r` ; `M` → `(hl)` |
| `MVI r,d8` | `ld r,*` |
| `MOV r1,r2` | `ld r1,r2` |
| `RLC/RRC` | `rlca` / `rrca` |
| `RAL/RAR` | `rla` / `rra` |
| `DAD rp` | `add hl,bc/de/hl/sp` |
| `LDA/STA a16` | `ld a,(**)` / `ld (**),a` |
| `LHLD/SHLD a16` | `ld hl,(**)` / `ld (**),hl` |
| `DAA` | `daa` |
| `CMA` | `cpl` |
| `STC/CMC` | `scf` / `ccf` |
| `HLT` | `halt` |
| `ADD/ADC r` | `add a,r` / `adc a,r` |
| `SUB/SBB r` | `sub r` / `sbc a,r` |
| `ANA/XRA/ORA/CMP r` | `and r` / `xor r` / `or r` / `cp r` |
| `ADI/ACI/SUI/SBI` | `add a,*` / `adc a,*` / `sub *` / `sbc a,*` |
| `ANI/XRI/ORI/CPI` | `and *` / `xor *` / `or *` / `cp *` |
| `JMP/Jcc` | `jp **` / `jp cc,**` |
| `CALL/Ccc` | `call **` / `call cc,**` |
| `RET/Rcc` | `ret` / `ret cc` |
| `PCHL` | `jp (hl)` |
| `SPHL` | `ld sp,hl` |
| `XCHG` | `ex de,hl` |
| `XTHL` | `ex (sp),hl` |
| `PUSH/POP B\|D\|H\|PSW` | `push/pop bc\|de\|hl\|af` |
| `IN/OUT d8` | `in a,(*)` / `out (*),a` |
| `EI/DI` | `ei` / `di` |
| `RST n` | `rst 00h` … `rst 38h` |

No `RIM`/`SIM` (8085 only).

## Unused opcode slots (do not emit)

Pastraiser marks these with `*`. They are **alternate encodings** of existing ops (`*NOP`, `*JMP`, `*RET`, `*CALL`). **Do not emit them.** Descendants reuse the same bytes for new instructions — that is why 8085 extras, VM1 prefixes, Z80 `jr`/`djnz`/prefixes, and gbz80 `stop`/`reti`/`ldh` are not portable back to 8080.

| Op | 8080 (unused alt) | 8085 | VM1 | Z80 | gbz80 |
|----|-------------------|------|-----|-----|-------|
| `08` | `*NOP` | `sub hl,bc` | `sub hl,bc` | `ex af,af'` | `ld (**),sp` |
| `10` | `*NOP` | `sra hl` | ANX | `djnz` | `stop` |
| `18` | `*NOP` | `rl de` | `sub hl,de` | `jr *` | `jr *` |
| `20` | `*NOP` | `rim` | ORX | `jr nz` | `jr nz` |
| `28` | `*NOP` | `ld de,hl+*` | **MB prefix** | `jr z` | `jr z` |
| `30` | `*NOP` | `sim` | XRX | `jr nc` | `jr nc` |
| `38` | `*NOP` | `ld de,sp+*` | **RS prefix** | `jr c` | `jr c` |
| `CB` | `*JMP` | `rst v` | `cp hl,bc` | CB prefix | CB prefix |
| `D9` | `*RET` | `ld (de),hl` | same | `exx` | `reti` |
| `DD` | `*CALL` | `jp nk` | `cp hl,de` | IX prefix | unused |
| `ED` | `*CALL` | `ld hl,(de)` | same | ED prefix | unused |
| `FD` | `*CALL` | `jp k` | `jp of` | IY prefix | unused |

Details of those extra ops live in `cpu-8085`, `cpu-vm1`, `cpu-z80`, `cpu-gbz80`. On 8080 they are not those instructions.

## Flag rules agents must not get wrong

| Group | Flags (SZAPC) | Notes |
|-------|---------------|-------|
| `inc`/`dec` **16-bit** (`inc bc` … `dec sp`) | `-----` | **No flags.** Not 8085 K. No `dec bc; jp nz` as a count test |
| `inc`/`dec` **8-bit** (incl. `(hl)`) | `SZAP-` | All but **C** |
| `rlca` / `rrca` / `rla` / `rra` | `----C` | **C only.** Z unchanged |
| `add hl,rp` | `----C` | **C only.** Not 8085 V+C |
| 8-bit ALU (`add`…`cp`, immediates) | `SZAPC` | Full set. Logical ops still this mask; no Z80 N |
| `daa` | `SZAPC` | |
| `cpl` | `-----` | **No flags** (Z80 `cpl` sets H,N) |
| `scf` / `ccf` | `----C` | |
| `pop af` | `SZAPC` | Restores S Z A P C; bits 5,3 stay 0 and bit 1 stays 1 |

## Timing notes

Pastraiser T-states (8080 clocks):

- Conditional **ret**: 11 taken / 5 not taken
- Conditional **jp**: **always 10** (both address bytes always fetched)
- Conditional **call**: 17 / 11
- `call **` 17, `ret` 10, `rst` 11
- `halt` is **7** (8085 is 5)
- `push` 11, `pop` 10
- 8-bit ALU register **4**, `(hl)` 7, immediate 7
- `ld r,r'` 5, `ld r,(hl)` / `ld (hl),r` 7
- `add hl,rp` 10, `ex de,hl` 4, `ex (sp),hl` **18** (slowest documented op)
- `ld hl,(**)` / `ld (**),hl` 16; `ld a,(**)` / `ld (**),a` 13
- `jp (hl)` / `ld sp,hl` 5

## Coding rules for this project

1. Emit **Zilog** only (`ld a,b` not `MOV A,B`; `jp nz,label` not `JNZ`).
2. Register pairs: `bc`, `de`, `hl`, `af`, `sp`.
3. Use `(hl)`, `(bc)`, `(de)`, `(**)` for memory; never `M`.
4. Never emit 8085 extras or Z80 `exx`/IX/IY/`djnz` as if they were native. **`jr` / `jr cc` are allowed** in normal mode (synthetics on): z80asm emits `jp` / `jp cc` (3 bytes, always 10T). Same source then assembles for Z80, where `jr` is native. **Strict** / `-no-synth` rejects `jr`. Do not expect a 2-byte relative branch here (`18` is unused `*NOP`).
5. **Assembler last resort:** fixtures `src/z80asm/dev/cpu/cpu_test_8080_{ok,err}.asm` (and `*_strict_*`). **ok** = z80asm accepts that source form (native, synthetic, or `call __z80asm__*`). **err** = rejected. **`_strict_`** = synthetics forbidden. Fixtures may list **Intel** spellings; **tree work is Zilog**. **`tool-z80asm`**. `rg` only. Do not bulk-read `*_err.asm`.

---

# 8080-portable usage

When and how to write library asm that has no 8085/Z80 extras. **Encodings, timings, and flags** are Pastraiser + this skill.

**Always emit Zilog mnemonics.**

## Hard rule: stack variables, not static/BSS

**Static memory (BSS / `label: ds n` / fixed absolute cells) must only hold state that must survive across function calls.** Never use it for intermediate variable storage.

| Allowed in static/BSS | Forbidden in static/BSS |
|-----------------------|-------------------------|
| Values that **must outlive** the current call | Locals, temps, intermediate results |
| MMIO, interrupt vectors, ROM constants | “Scratch” cells to avoid a push or stack frame |

- Function **locals, temporaries, and intermediate results** live **only on the stack** (arguments, return slots, pushes, explicit frames).
- Access with **`ld hl,nn` / `add hl,sp`**, `(hl)` byte walks, `ld a,(de)` / `ld (de),a`, push/pop, **`ex (sp),hl`**.
- Prefer **pointers passed on the stack** over new static cells.

There is **no** native `ld de,sp+*`. That encoding is 8085 LDSI (`38`) and an unused `*NOP` here. z80asm `ld de,sp+n` is a **6-byte** `ex`/`ld hl,nn`/`add hl,sp`/`ex` dance — do not use it in hot paths.

## Core formulations

### 1. Stack access (primary working storage)

```asm
    ld  hl,n           ; 10c, 3B
    add hl,sp          ; 10c, 1B  → 20c / 4B; sets C; DE preserved
    ld  a,(hl)
    inc hl
    ld  h,(hl)
    ld  l,a            ; word load through A
```

z80asm accepts **`ld hl,sp+n`** as that same pair (`21 nn nn 39`). `8-8080` uses it (`l_long_add.asm`, `l_long_div_0.asm`). It **clobbers C** because `add hl,sp` sets C. Save C first if a rotate chain is live:

```asm
    rra                ; C → A
    ld  hl,sp+n
    rla                ; C restored
```

`l_long_div_0.asm` does this around every stack reload in the shift loop.

Leave a pointer in **HL** or **DE** and walk bytes. Second 32-bit value: keep it **on the stack**, not a shadow bank.

### 2. Drop stack arguments

```asm
    pop bc             ; return address — never pop af for this
    pop hl             ; discard a word (or add hl,sp form)
    pop hl
    push bc
    ret
```

No `add sp,*` (gbz80/Z80). SP math is `ld hl,n` / `add hl,sp` / `ld sp,hl`.

### 3. 16-bit subtract and compare — through A

No native `sub hl,bc`. z80asm `sub hl,bc` is **`call __z80asm__sub_hl_bc`**. Do not use the helper as the core of a hot routine. Open-code:

```asm
    ld  a,l
    sub c
    ld  l,a
    ld  a,h
    sbc a,b
    ld  h,a            ; CY is borrow
```

Equality: `ld a,h` / `cp d` / `jp nz` then `ld a,l` / `cp e`. See `l_cmpbcde.asm`. For multi-word subtract with borrow, stay on A + `sbc`.

### 4. Counted loops — inner/outer 8-bit, or test through A

16-bit **`dec bc` does not set Z**. Wikipedia’s memcpy pattern is the portable test:

```asm
    dec bc
    ld  a,b
    or  c
    jp  nz,loop
```

Prefer splitting a 16-bit count into inner and outer 8-bit loops. **`bc`** is the usual counter (`hl`/`de` have pointer work). **`jr nz` is allowed** (normal mode → `jp nz`); use it when the same source may also build for Z80:

```asm
    dec bc
    inc b
    inc c
loop:
    ; body, repeated BC times
    dec c
    jr  nz,loop        ; → jp nz on 8080; native jr on Z80
    dec b
    jr  nz,loop
```

8-bit counts: `dec b` / `jr nz` (or `jp nz`). `djnz` is sugar for `dec b` / `jp nz` (4 bytes) — not the Z80 opcode.

### 5. Shifts — through A (`l_rlde.asm`, `l_asr.asm`)

No native `rl de` / `sra hl`. Those mnemonics are **helper calls**. `8-8080` open-codes them:

```asm
    ; l_rlde — DE rotate left through C
    ld  a,e
    rla
    ld  e,a
    ld  a,d
    rla
    ld  d,a
```

```asm
    ; signed 16-bit >>  (l_asr.asm)
    ld  a,h
    rla                ; C ← sign
    ld  a,h
    rra
    ld  h,a
    ld  a,l
    rra
    ld  l,a
```

**32-bit <<** (value in DEHL):

```asm
    add hl,hl
    ld  a,e
    rla
    ld  e,a
    ld  a,d
    rla
    ld  d,a
```

Logical multi-byte >>: chain **`rra` through A**. Bit scan: `add a,a` / `adc a,a` (`l_long_div_0.asm`) — no `sla`/`rl r`.

### 6. `(de)` — only A

Native: **`ld a,(de)`**, **`ld (de),a`**. There is no `ld (de),l` / `ld (de),hl` / `ld hl,(de)` as a one-byte op.

z80asm `ld hl,(de)` / `ld (de),hl` expand through `ex de,hl` (6–7 bytes). Prefer a pointer in HL, or walk through A. Post-inc `ld a,(hl+)` is two ops (`7E 23`) — legal sugar; `l_long_div_0.asm` uses it.

### 7. Park a pair — word-copy synthetics

```asm
    ld  bc,hl          ; B←H, C←L
    ; … use HL …
    ld  hl,bc
```

`l_long_add.asm` parks the low word this way. Prefer this over `ex de,hl` when you only need to park one pair. **Not** for `af` or `sp`.

### 8. Extra 16-bit slot — `ex (sp),hl`

Push a scratch word; **`ex (sp),hl`** swaps with it when AF/BC/DE/HL are full (18c). **Do not** use `push af`/`pop af` as a free 16-bit temp or to hold a return address.

### 9. `pop af` and the return address

F bits 5 and 3 are hardwired 0; bit 1 is hardwired 1. A word popped into AF is never a faithful 16-bit value (`$FFFF` → `$FFD7`). **Never `pop af` the return address.** Use BC/DE/HL. **`pop af` is OK to discard** intermediate stack words when A/F need not be preserved (unlike VM1, this does not switch a data bank).

### 10. I/O and ops that do not exist

| Prefer on 8080 | Avoid (other CPUs) |
|----------------|--------------------|
| `out (*),a` / `in a,(*)` | `outi`, `in r,(c)`, block I/O |
| `dec b` / `jr nz` (→ `jp nz`) | native `djnz` (`10` is unused `*NOP`) |
| Stack for second long | `exx`, IX/IY |
| Open-code subtract through A | `sub hl,bc` helper; `sbc hl,de` |
| `ld hl,nn` / `add hl,sp` | 8085 `ld de,sp+*`; gbz80 `ld hl,sp+*` native |

---

## Synthetic opcodes (z80asm, normal mode)

Assembler sugar. **Strict** / `-no-synth` forbids free synthetics. Listings (`-l`) show the expansion.

### Word copies — full set

| Allowed | Forbidden in this set |
|---------|------------------------|
| `ld` among `bc` / `de` / `hl` (any → any) | `af`, `sp` |

```asm
    ld  bc,de
    ld  bc,hl
    ld  de,bc
    ld  de,hl
    ld  hl,bc
    ld  hl,de
```

### Useful inline synthetics (not helpers)

| Zilog | Expansion | Notes |
|-------|-----------|-------|
| `ld hl,sp+n` | `ld hl,nn` / `add hl,sp` | **clobbers C**. Used in `8-8080` |
| `ld a,(hl+)` / `ld (hl+),a` | `ld a,(hl)` / `inc hl` | same for `-` |
| `jr` / `jr cc,**` | `jp` / `jp cc,**` | **Allowed** (normal mode). Shared Z80 source. Strict forbids |
| `djnz **` | `dec b` / `jp nz` | sugar; not the Z80 opcode |
| `neg` | `cpl` / `inc a` | |

### Helper calls (`CD @__z80asm__…`) — avoid in hot paths

| Source form | Why not |
|-------------|---------|
| `sub hl,bc` / `de` / `hl` / `sp` | call, not a chip op |
| `sra hl` / `rl de` | call; open-code through A (`l_asr`, `l_rlde`) |
| `ld de,sp+*` | 6-byte `ex` dance |

`ld (de),hl` / `ld hl,(de)` are inline `ex` sequences, not helpers, but still long — prefer HL as the pointer.

## Pitfalls

1. **`pop af` never for function return** — F bits 5,3,1 are hardwired, so AF cannot hold a correct return address (`$FFFF` → `$FFD7`). **`pop af` is OK only to discard.**
2. **`dec rr` does not set Z** (and does not set 8085 K). Test through A, or use inner/outer 8-bit loops.
3. **`rla` / `rra` / `rlca` / `rrca` do not set Z.** Never `rla; jp z`.
4. **`add hl,sp` / `ld hl,sp+n` clobber C.** Save C with `rra`/`rla`.
5. **`jr` is a `jp` synthetic, not a short branch.** Normal mode: emit `jr` (allowed; 3-byte `jp`; shared Z80 source). Strict: write `jp`. Do not cost it as Z80’s 2-byte `jr`.
6. **`$08`/`$10`/`$18`/…/`$38`/`$CB`/`$D9`/`$DD`/`$ED`/`$FD` are unused alts.** Emitting 8085 `ld de,sp+n` here is `*NOP` plus the next byte.
7. **`(de)` stores only A.** A “working” assemble that used `ld (de),l` was not 8080-checked (or expanded through `ex`).
8. **`cpl` does not touch flags.** Do not expect Z80 H/N.
9. **No copt pass on library asm.** Hand-written `libsrc/**` is assembled as-is. Remove dead moves yourself. Match the target file’s whitespace. Do **not** use `xor a` for `ld a,0` when CF must survive. Checklist: **`tool-copt`**, **`methodology-measure`**.
10. **`__CPU_INTEL__` is set for 8080.** 9-common already takes this path. Fork into `8-8080/` only when the 8080 form still needs its own file (`i32/`, `l_asr`, `l_rlde`, `f48/`). Do not “fix” 9-common with `#if __CPU_8080__` to emit 8085 ops.

## Preference order (8080-only code)

1. Stack-only locals/temps/intermediates; **static/BSS only for state that must survive across calls**.
2. **`ld hl,nn` / `add hl,sp`** (or `ld hl,sp+n` sugar) for frames; save C if a rotate chain is live.
3. **`ld bc,hl` / `ld hl,bc`** (and the other pair copies) to park a word.
4. **`(hl)` / `ld a,(de)` / `ld (de),a`** for memory; walk bytes.
5. Inner/outer **`dec c` / `jr nz`** loops (→ `jp nz`); 16-bit counts via `ld a,b` / `or c`.
6. Shifts **through A**; do not `call` `sra hl` / `rl de`.
7. 16-bit subtract **through A**; do not `call` `sub hl,bc`.

## Assembler capability (last resort)

| File | Meaning |
|------|---------|
| `cpu_test_8080_ok.asm` | Assembles; `;` comment = encoding |
| `cpu_test_8080_err.asm` | Must fail |
| `*_strict_*` | Strict: synthetics forbidden |

**ok is not always one native opcode.** How to `rg`: skill **`tool-z80asm`**.

Ticks: `z88dk-ticks -m8080 binary` — CPU flag **before** the path. Disassemble: `z88dk-dis -m8080`.

## Related

- Opcode/flag/timing authority: https://pastraiser.com/cpu/i8080/i8080_opcodes.html
- History: https://en.wikipedia.org/wiki/Intel_8080
- 8085 extras (different map on the unused slots): `cpu-8085` — do not load both for one CPU
- KR580VM1 extras: `cpu-vm1`
- Z80: `cpu-z80` · gbz80: `cpu-gbz80`
- Assembler: `tool-z80asm`
- Measure: `methodology-measure`, `tool-ticks` (`-m8080` before the binary)
- Runtime: `libsrc/l/sccz80/8-8080/`
- Config: `lib/config/cpm.cfg` (`-clib=8080`), `lib/config/z80.cfg`
